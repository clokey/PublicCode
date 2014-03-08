//
//  MonitorController.m
//  VirtualSerialPortApp
//
//  Created by Matt Cloke on 23/08/2009.
//  Copyright 2009 clokey.co.uk. All rights reserved.
//

#import "MonitorController.h"


@implementation MonitorController

@synthesize connected;
- (id)init
{
    if (![super init])
	{
        return nil;
    }	
	[monitorOutput setFont:[NSFont fontWithName:@"Panic Sans" size:10.0]];
	connected = NO;
	return self;
}

- (void)awakeFromNib
{
	connected = NO;
}

- (void)connectAndMonitor:(NSString *)bsdPath;
{
	NSLog(@"Connecting to [%@] for monitoring",bsdPath);
	if(monitorPort == nil)
	{
		monitorPort = [[AMSerialPort alloc] init:bsdPath withName:bsdPath type:(NSString*)CFSTR(kIOSerialBSDRS232Type)];
		[monitorPort retain];
	}
	[monitorWindow setTitle:[NSString stringWithFormat:@"Monitoring - %@",bsdPath]];
}

- (IBAction)didSelectSendData:(id)sender
{
	NSString *sendString = [[sendDataField stringValue] stringByAppendingString:@"\r"];
	
	if(!monitorPort)
	{
		NSLog(@"No monitorPort to send data, perhaps we aren't connected");
	}
	
	if([monitorPort isOpen])
	{
		[monitorPort writeString:sendString usingEncoding:NSUTF8StringEncoding error:NULL];
	}
}

- (IBAction)didSelectConnectDisconnect:(id)sender
{
	NSLog(@"Did Attempt connectDisconnect");
	if(!connected)
		[self doConnect];
	else
		[self doDisconnect];
}

- (void)doConnect
{
	if(![monitorPort available])
	{
		NSLog(@"Port un-available");
	}
	
	// register self as delegate for port
	[monitorPort setDelegate:self];
	
	NSLog(@"attempting to open port\n");

	// open port - may take a few seconds ...
	if ([monitorPort open]) 
	{
		NSLog(@"port opened\n");

		[monitorPort readDataInBackground];
		[connectDisconnectButton setLabel:@"Disconnect"];
		self.connected = YES;		
	}
	else
	{ 
		NSLog(@"couldn't open port for device\n");
		self.connected = NO;
		monitorPort = nil;
	}
}

-(void)serialPortWriteProgress:(NSDictionary *)progressDictionary
{
	for (id key in progressDictionary) 
	{
		NSLog(@"key: %@, value: %@", key, [progressDictionary objectForKey:key]);
	}	
}

- (void)serialPortReadData:(NSDictionary *)dataDictionary
{
	// this method is called if data arrives 
	// @"data" is the actual data, @"serialPort" is the sending port
	AMSerialPort *sendPort = [dataDictionary objectForKey:@"serialPort"];
	NSData *data = [dataDictionary objectForKey:@"data"];
	if ([data length] > 0) 
	{
		[self appendDataToMonitorView:data];
		// continue listening
		[sendPort readDataInBackground];
	}
	else 
	{ 
		NSLog(@"Port closed");
	}
}

- (void)doDisconnect
{
	[monitorPort setDelegate:nil];
	[monitorPort close];
	[monitorPort release];
	self.connected = NO;
	[connectDisconnectButton setLabel:@"Connect"];	
}

- (IBAction)didSelectOpenFile:(id)sender
{
	NSOpenPanel * openPanel = [NSOpenPanel openPanel];
	[openPanel setAllowsMultipleSelection:NO];
	[openPanel setCanChooseDirectories:NO];
	[openPanel beginSheetForDirectory:nil
									file:nil
								   types:nil
						  modalForWindow:monitorWindow
						   modalDelegate:self
						  didEndSelector:@selector(openPanelDidEnd:returnCode:contextInfo:)
							 contextInfo:nil];
}
	
- (void)openPanelDidEnd:(NSOpenPanel *)panel returnCode:(int)returnCode  contextInfo:(void  *)contextInfo
{
	if(returnCode == NSOKButton)
	{
		NSLog(@"Files selected");
		// We've blocked multiple selection so index 0 has the file selected
		[monitorPort writeDataInBackground:[NSData dataWithContentsOfFile:[[panel filenames]objectAtIndex:0]]];
//		NSArray * array = [NSArray arrayWithArray:[panel filenames]];
//		for(NSString * file in array)
//		{
//			NSLog(@"file:%@",file);
//			[port writeDataInBackground:[NSData dataWithContentsOfFile:file]];
//		}
	}
	else
	{
		NSLog(@"User canceled load");
	}
}

- (IBAction)didSelectMonitorSlave:(id)sender
{
	[monitorWindow makeKeyAndOrderFront:sender];
	[self didSelectMonitor:[slaveName stringValue]];
}

- (IBAction)didSelectMonitorMaster:(id)sender
{
	[monitorWindow makeKeyAndOrderFront:sender];
	[self didSelectMonitor:[masterName stringValue]];
}

-(void)didSelectMonitor:(NSString *)bsdPath
{
	[self connectAndMonitor:[NSString stringWithFormat:@"/dev/%@",bsdPath]];
}

- (void)appendDataToMonitorView:(NSData *)data
{
	NSRange endRange = NSMakeRange([[monitorOutput string] length], 0);
	NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	[monitorOutput replaceCharactersInRange:endRange withString:string];
	[string release];
}

@end
