//
//  NSDictionary+FERUtility.h
//  flutter_error_report
//
//  Created by JianFei Wang on 2019/9/5.
//

#import <Foundation/Foundation.h>

typedef BOOL (^FERKeyValueCondition)(id _Nonnull key, id _Nonnull value);

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (FERUtility)

- (NSDictionary *)fer_removeEmptyValues;
- (NSDictionary *)fer_where:(FERKeyValueCondition)predicate;
- (nullable id)fer_valueForKey:(NSString *)key defaultValue:(nullable id)defaultValue;

@end

NS_ASSUME_NONNULL_END
