//
//  AppController.m
//  VirtualSerialPortApp
//
//  Created by Matt Cloke on 22/08/2009.
//  Copyright 2009 clokey.co.uk. All rights reserved.
//

#import "AppController.h"


@implementation AppController

@synthesize allBaudRates, currentlySelectedBaudRate, created;

/**
 * init method creates and initialises a number of objects used by the default
 * xib file.
 * @return id point to this instance. Return nil if super initialisation fails.
 */
-(id)init
{
	
    if (![super init])
	{
        return nil; // Bail.
    }
	
	allBaudRates = [NSArray arrayWithObjects:@"300", @"1200", @"2400", @"4800", @"9600", @"14400", @"19200", @"28800", @"38400", @"57600",@"115200",nil];
	currentlySelectedBaudRate = @"9600";

	socatOutputLevel = [NSArray arrayWithObjects:@"Error",@"Warning",@"Info", @"Debug", nil];
	socatIndexSelectionIndex = 3;
	
	socatController = [[[SocatController alloc] init] retain];
	
	self.created = NO;
    return self;
}

#pragma mark -
#pragma mark NSApplication delegate methods
/**
 * Delegate method for NSApplication.
 * @param sender is the @see NSApplication class that this method is delegating for
 * @return NSApplicationTerminateReply enum indicating whether the application should quit.
 */
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
	if(created)
	{
		[socatController terminate];
	}
	return NSTerminateNow;
}

#pragma mark -
#pragma mark Interface action methods
/**
 * Action method for invoking the create/break pair button
 * @param sender is the invoker of the action
 */
- (IBAction)doCreateBreakPairAction:(id)sender
{

	if (created)
	{
		if([socatController breakPairAndRemoveProcess])
		{
			[createPairButton setTitle:@"Create Pair"];
			[masterNameField setEnabled:YES];
			[slaveNameField setEnabled:YES];			
			self.created = NO;			
		}
	}
	else
	{
		if([socatController createPairFrom:[masterNameField stringValue] 
										to:[slaveNameField stringValue] 
								  withBaudRate:currentlySelectedBaudRate])
		{
			[createPairButton setTitle:@"Break Pair"];
			[masterNameField setEnabled:NO];
			[slaveNameField setEnabled:NO];
			self.created = YES;			
		}
	}
}






@end
