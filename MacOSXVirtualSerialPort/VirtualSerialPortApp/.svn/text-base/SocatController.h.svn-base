//
//  SocatController.h
//  VirtualSerialPortApp
//
//  Created by Matt Cloke on 10/09/2009.
//  Copyright 2009 Matt Cloke (clokey.co.uk). All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SocatController : NSObject 
{
	NSString * pid;
	NSString * logfileLocation;
	NSString * socatPath;
	NSString * group;
}

- (BOOL)createPairFrom:(NSString *)address1 to:(NSString *)address2 withBaudRate:(NSString *)baudRate;
- (BOOL)breakPairAndRemoveProcess;
- (void)terminate;

- (BOOL)runToolWithPath:(NSString*)path arguments:(NSArray*)args blockRead:(BOOL)blockingValue;
- (NSString *) getPidFromLogfile;
- (NSString *)getDefaultGroupForCurrentUser;
- (void)appendData:(NSData *)data;
- (void)dataReady:(NSNotification *)note;

@end
