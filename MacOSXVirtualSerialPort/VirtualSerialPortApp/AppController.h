//
//  AppController.h
//  VirtualSerialPortApp
//
//  Created by Matt Cloke on 22/08/2009.
//  Copyright 2009 clokey.co.uk. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MonitorController.h"
#import "SocatController.h"
#import <Security/Authorization.h>

@interface AppController : NSObject
{
	IBOutlet NSTextField * masterNameField;
	IBOutlet NSTextField * slaveNameField;
	IBOutlet NSButton * createPairButton;
	IBOutlet NSWindow * monitorWindow;
	IBOutlet NSButton * monitorSlave;
	IBOutlet NSButton * monitorMaster;
	NSMutableArray * allBaudRates;
	NSMutableArray * socatOutputLevel;
	int socatIndexSelectionIndex;
	NSString * currentlySelectedBaudRate;

	BOOL created;
	SocatController * socatController;
}

@property (nonatomic, copy) NSMutableArray * allBaudRates;
@property (nonatomic, copy) NSString * currentlySelectedBaudRate;
@property BOOL created;

#pragma mark -
#pragma mark Interface action methods
- (IBAction)doCreateBreakPairAction:(id)sender;

#pragma mark -
#pragma mark NSApplication delegate methods
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender;



@end
