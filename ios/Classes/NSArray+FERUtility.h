//
//  NSArray+FERUtility.h
//  flutter_error_report
//
//  Created by JianFei Wang on 2019/9/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef id _Nonnull (^FERSelector)(id item);

@interface NSArray (FERUtility)

/** Projects each element of a sequence into a new form.
 
 @param transform A transform function to apply to each element.
 @return An array whose elements are the result of invoking the transform function on each element of source.
 */
- (NSArray *)fer_select:(FERSelector)transform;

@end

NS_ASSUME_NONNULL_END
