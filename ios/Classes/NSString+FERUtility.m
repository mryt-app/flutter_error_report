//
//  NSString+FERUtility.m
//  flutter_error_report
//
//  Created by JianFei Wang on 2019/9/5.
//

#import "NSString+FERUtility.h"

@implementation NSString (FERUtility)

+ (BOOL)fer_isEmpty:(NSString *)aString {
    if ((NSNull *)aString == [NSNull null]) {
        return YES;
    }
    if (aString == nil) {
        return YES;
    } else if ([aString length] == 0) {
        return YES;
    } else {
        aString = [aString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([aString length] == 0) {
            return YES;
        }
    }
    return NO;
}

@end
