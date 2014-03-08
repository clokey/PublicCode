//
//  MonitorController.h
//  VirtualSerialPortApp
//
//  Created by Matt Cloke on 23/08/2009.
//  Copyright 2009 clokey.co.uk. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AMSerialPort.h"
#import "AMSerialPortAdditions.h"
#import "AMSerialPortList.h"

@interface MonitorController : NSObject 
{
	AMSerialPort * monitorPort;
	NSString * test;
	IBOutlet NSTextView * monitorOutput;
	IBOutlet NSWindow * monitorWindow;
	IBOutlet NSTextField * slaveName;
	IBOutlet NSTextField * masterName;
	IBOutlet NSTextField * sendDataField;
	IBOutlet NSToolbarItem * connectDisconnectButton;
	BOOL connected;
}

@property BOOL connected;

#pragma mark -
#pragma mark Interface action methods
- (IBAction)didSelectSendData:(id)sender;
- (IBAction)didSelectConnectDisconnect:(id)sender;
- (IBAction)didSelectOpenFile:(id)sender;
- (IBAction)didSelectMonitorMaster:(id)sender;
- (IBAction)didSelectMonitorSlave:(id)sender;

- (void)didSelectMonitor:(NSString *)bsdPath;

#pragma mark -
#pragma mark Serial Interaction methods
- (void)doConnect;
- (void)doDisconnect;

#pragma mark -
#pragma mark AMSerial delegate methods
- (void)serialPortWriteProgress:(NSDictionary *)progressDictionary;
- (void)serialPortReadData:(NSDictionary *)dataDictionary;

#pragma mark -
#pragma mark Output methods
- (void)appendDataToMonitorView:(NSData *)data;
- (void)connectAndMonitor:(NSString *)bsdPath;
@end
