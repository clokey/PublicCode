//
//  PathRestrictionFormatter.m
//  VirtualSerialPortApp
//
//  Created by Matt Cloke on 22/08/2009.
//  Copyright 2009 clokey.co.uk. All rights reserved.
//

#import "PathRestrictionFormatter.h"

/**
 * @see NSFormatter
 */ 
@implementation PathRestrictionFormatter


-(BOOL)getObjectValue:(id *)anObject forString:(NSString *)aString errorDescription:(NSString **)errorPtr
{
	*anObject = [NSString stringWithString:aString];
	return YES;
}

-(NSString *)stringForObjectValue:(id)anObject
{
	return [NSString stringWithFormat:@"%@", anObject];
}

/**
 * If you don't want to accept the partial string, return NO. If you don't 
 * supply a newString then the string that was in the field prior to the 
 * edit will be kept. You can also return an error and error description 
 * (though nothing is done with them by default).
 */
-(BOOL)isPartialStringValid:(NSString*) partialString newEditingString:(NSString **) newString errorDescription:(NSString **)error
{
	NSRange aRange;
	
	aRange = [partialString rangeOfString:@"/"];
	if(aRange.length!=0)
		return NO;
	aRange = [partialString rangeOfString:@"."];
	if(aRange.length!=0)
		return NO;
	aRange = [partialString rangeOfString:@","];
	if(aRange.length!=0)
		return NO;
	aRange = [partialString rangeOfString:@";"];
	if(aRange.length!=0)
		return NO;
	aRange = [partialString rangeOfString:@"\\"];
	if(aRange.length!=0)
		return NO;

	return YES;

}
@end
