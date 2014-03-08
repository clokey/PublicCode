//
//  SocatController.m
//  VirtualSerialPortApp
//
//  Created by Matt Cloke on 10/09/2009.
//  Copyright 2009 Matt Cloke (clokey.co.uk). All rights reserved.
//

#import "SocatController.h"


@implementation SocatController

-(id)init
{
	group = [[self getDefaultGroupForCurrentUser]retain];
	if ((socatPath = [[[NSBundle bundleForClass:[self class]] pathForResource:@"socat" ofType:nil] retain]))
	{
		NSLog(@"path to socat is:[%@]",socatPath);
		NSLog(@"Current user is :[%@]",NSUserName());
	}
	else
	{
		NSLog(@"unable to locate socat");
	}
	pid = nil;
	return self;
}

- (NSString *)getTemporaryFileForWriting
{
	NSString *nowString = [[NSDate  date] descriptionWithCalendarFormat:@"%Y%m%d-%H%M%S" timeZone:nil locale:nil];
	return [NSString stringWithFormat:@"%@%@-socat", NSTemporaryDirectory(), nowString ];	
}

- (BOOL)runToolWithPath:(NSString*)path arguments:(NSArray*)args blockRead:(BOOL)blockingValue
{
	OSStatus myStatus;
	AuthorizationFlags myFlags = kAuthorizationFlagDefaults;
	AuthorizationRef myAuthorizationRef;
	
	myStatus = AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment, myFlags, &myAuthorizationRef);
	if (myStatus != errAuthorizationSuccess)
		return NO;
	
	AuthorizationItem myItems = {kAuthorizationRightExecute, 0, NULL, 0};
	AuthorizationRights myRights = { 1, &myItems };
	myFlags = ( kAuthorizationFlagDefaults | kAuthorizationFlagInteractionAllowed | kAuthorizationFlagPreAuthorize | kAuthorizationFlagExtendRights );
	
	myStatus = AuthorizationCopyRights (myAuthorizationRef, &myRights, NULL, myFlags, NULL );
	if (myStatus != errAuthorizationSuccess)
		return NO;
	
	const char *myToolPath = [path UTF8String];
	
	const char **myArguments = calloc([args count] + 1, sizeof(char*));
	
	int i = 0;
	for (NSString *argStr in args)
		myArguments[i++] = [argStr UTF8String];
	
	FILE *myCommunicationsPipe = NULL;
	
	myFlags = kAuthorizationFlagDefaults;
	myStatus = AuthorizationExecuteWithPrivileges(myAuthorizationRef, myToolPath, myFlags, (char**)myArguments, &myCommunicationsPipe);
	
	free(myArguments);
	
	AuthorizationFree(myAuthorizationRef, myFlags);
	
	if(blockingValue)
	{
		NSData * data;
		NSString * aString;
		
		NSFileHandle * fh = [[NSFileHandle alloc] initWithFileDescriptor:fileno(myCommunicationsPipe)];
		
		data = [fh readDataToEndOfFile];
		aString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
		
		NSLog(@"Run tool blocked and got:[%@]",aString);
		
		[fh release];
		[aString release];
	}
	else
	{
		NSFileHandle * fh = [[[NSFileHandle alloc] initWithFileDescriptor:fileno(myCommunicationsPipe)] autorelease];
		
		[fh readInBackgroundAndNotify];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(dataReady:) 
													 name:NSFileHandleReadCompletionNotification 
												   object:fh];
	}
	
	return (myStatus == errAuthorizationSuccess);
}

/**
 * Method to determine primary group of the current user. Equivalent
 * to executing id -gn <username> at the prompt (and in fact, that's how
 * it's implemented!)
 * @return NSString containing the current users primary group
 */
- (NSString *)getDefaultGroupForCurrentUser
{
	NSPipe * aPipe;
	NSData * data;
	NSString * aString;
	NSTask * idTask;
	NSArray * argumentArray = [NSArray arrayWithObjects:@"-gn",NSUserName(),nil];
	
	aPipe = [[NSPipe alloc] init];
	idTask = [[NSTask alloc] init];
	
	[idTask setLaunchPath:@"/usr/bin/id"];
	[idTask setArguments:argumentArray];
	[idTask setStandardOutput:aPipe];
	[idTask launch];
	
	data = [[aPipe fileHandleForReading] readDataToEndOfFile];
	aString = [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
	
	[aPipe release];
	[idTask release];
    
	// their is a carriage return appended to the end of the string we get back from the pipe so remove it
	return [NSString stringWithString:[aString substringToIndex:([aString length])-1]];
}

/**
 * dataReady is the method invoked from the default notification center if the NSPipe
 * detects that there is data to be read from the underlying NSTask. Invokes @see
 * appendData.
 * @param note an NSNotification object.
 */
- (void)dataReady:(NSNotification *)note
{
	NSData * data = [[note userInfo] valueForKey:NSFileHandleNotificationDataItem];
	if(data)
		[self appendData:data];
}

/**
 * appendData is invoked by the dataMethod to display the data object. This
 * implementation assumes that it is encoded as a UTF-8 string and is written to
 * NSLog.
 * @param data an NSData object containing the data read from the NSPipe. 
 */
- (void)appendData:(NSData *)data
{
	
	NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	NSLog(@"[socatTask]->%@", string);
	
	[string release];
}

/**
 * parse the passed data looking for the socat task pid, needed for killing the task
 * example output from socat: D setenv("SOCAT_PID", "7768", 1)
 */
- (NSString *)getPidFromLogfile
{
	NSRange startRange, endRange, interRange, subStringRange;
	NSString * result = nil;
	NSError * error;
	
	NSString * logfile = [NSString stringWithContentsOfFile:logfileLocation encoding:NSUTF8StringEncoding error:&error];
	
	if(!logfile)
	{
		NSLog(@"Unable to open logfile to parse. %@", error);
		return nil;
	}
	
	startRange = [logfile rangeOfString:@"setenv(\"SOCAT_PID\""];
	if(startRange.location != NSNotFound)
	{
		interRange.location = startRange.location;
		interRange.length = [logfile length]-startRange.location;
		endRange = [logfile rangeOfString:@")" options:NSCaseInsensitiveSearch range:interRange];
		if(endRange.location != NSNotFound)
		{
			subStringRange.location = startRange.location;
			subStringRange.length = endRange.location - startRange.location;
			NSArray * splitString = [[logfile substringWithRange:subStringRange] componentsSeparatedByString:@", "];
			result = [[splitString objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
		}
	}
	
	return result;
}

/**
 * @todo set the socat output level at the interface level
 * @todo add the baud rate to the startup paremeters
 */
- (BOOL)createPairFrom:(NSString *)address1 to:(NSString *)address2 withBaudRate:(NSString *)baudRate
{
	NSMutableArray *argumentArray = [NSMutableArray array];
	NSString * from = [NSString stringWithFormat:@"pty,link=/dev/%@,raw,echo=0,user=%@,group=%@", address1, NSUserName(),group];
	NSString * to = [NSString stringWithFormat:@"pty,link=/dev/%@,raw,echo=0,user=%@,group=%@", address2, NSUserName(), group];
	
	logfileLocation = [[self getTemporaryFileForWriting] retain];
	
	[argumentArray addObject:@"-d"];
	[argumentArray addObject:@"-d"];
	[argumentArray addObject:@"-d"];
	[argumentArray addObject:@"-d"];
	[argumentArray addObject:@"-lf"];
	[argumentArray addObject:logfileLocation];
	[argumentArray addObject:from];
	[argumentArray addObject:to];

     NSLog(@"%@",argumentArray);
	
	if([self runToolWithPath:socatPath arguments:argumentArray blockRead:NO])
	{
		return YES;
	}
	
	return NO;
	
}

- (BOOL)breakPairAndRemoveProcess
{
	NSMutableArray *argumentArray = [NSMutableArray array];
	pid = [self getPidFromLogfile];
	NSLog(@"Attempting to kill pid:%@", pid);
	[argumentArray addObject:@"-9"];
	[argumentArray addObject:pid];
	
	// turn off notifications, could cause weird behaviour when invoking AuthorizedAction
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSFileHandleReadCompletionNotification object:nil ];
	
	if([self runToolWithPath:@"/bin/kill" arguments:argumentArray blockRead:YES])
	{
		return YES;
	}
	return NO;
}

- (void)terminate
{
	NSLog(@"Terminate called");
}

@end
