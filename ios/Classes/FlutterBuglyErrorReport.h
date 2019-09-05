//
//  FlutterBuglyErrorReport.h
//  flutter_error_report
//
//  Created by JianFei Wang on 2019/9/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlutterBuglyErrorReport : NSObject

+ (void)startWithAppId:(NSString *)appId config:(NSDictionary *)config;
+ (void)setUserId:(NSString *)userId;
+ (void)reportException:(NSException *)exception;
+ (void)reportExceptionWithName:(NSString *)aName
                         reason:(NSString *)aReason
                      callStack:(NSArray *)aStackArray
                   terminateApp:(BOOL)terminate;

@end

NS_ASSUME_NONNULL_END
