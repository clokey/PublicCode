//
//  PathRestrictionFormatter.h
//  VirtualSerialPortApp
//
//  Created by Matt Cloke on 22/08/2009.
//  Copyright 2009 clokey.co.uk. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PathRestrictionFormatter : NSFormatter 
{
	NSString * result;
}

-(BOOL)getObjectValue:(id *)anObject forString:(NSString *)aString errorDescription:(NSString **)errorPtr;
-(NSString *)stringForObjectValue:(id)anObject;
-(BOOL)isPartialStringValid:(NSString*) partialString newEditingString:(NSString **) newString errorDescription:(NSString **)error;

@end
