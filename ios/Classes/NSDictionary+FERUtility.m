//
//  NSDictionary+FERUtility.m
//  flutter_error_report
//
//  Created by JianFei Wang on 2019/9/5.
//

#import "NSDictionary+FERUtility.h"
#import "NSString+FERUtility.h"

@implementation NSDictionary (FERUtility)

- (NSDictionary *)fer_removeEmptyValues {
    return [self fer_where:^BOOL(id key, id value) {
        if ([value isKindOfClass:NSString.class] && [NSString fer_isEmpty:value]) {
            return NO;
        } else {
            return YES;
        }
    }];
}

- (NSDictionary *)fer_where:(FERKeyValueCondition)predicate {
  NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
  [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    if (predicate(key, obj)) {
      [result setObject:obj forKey:key];
    }
  }];
  return result;
}

- (id)fer_valueForKey:(NSString *)key defaultValue:(id)defaultValue {
    id value = self[key];
    // Dart [null] returns nil or NSNull when nested.
    if (value != nil && ![value isEqual:[NSNull null]]) {
        return value;
    } else {
        return defaultValue;
    }
}

@end
