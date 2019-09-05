//
//  NSArray+FERUtility.m
//  flutter_error_report
//
//  Created by JianFei Wang on 2019/9/5.
//

#import "NSArray+FERUtility.h"

@implementation NSArray (FERUtility)

- (NSArray *)fer_select:(FERSelector)transform {
    return [self fer_select:transform andStopOnError:NO];
}

- (NSArray *)fer_select:(FERSelector)transform andStopOnError:(BOOL)shouldStopOnError
{
    NSMutableArray* result = [[NSMutableArray alloc] initWithCapacity:self.count];
    for(id item in self)
    {
        id object = transform(item);
        if (nil != object)
        {
            [result addObject: object];
        }
        else
        {
            if (shouldStopOnError)
            {
                return nil;
            }
            else
            {
                [result addObject: [NSNull null]];
            }
        }
    }
    return result;
}

@end
