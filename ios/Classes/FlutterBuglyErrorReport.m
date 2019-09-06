//
//  FlutterBuglyErrorReport.m
//  flutter_error_report
//
//  Created by JianFei Wang on 2019/9/5.
//

#import "FlutterBuglyErrorReport.h"
#import <Bugly/Bugly.h>
#import "NSDictionary+FERUtility.h"

@implementation FlutterBuglyErrorReport

+ (void)startWithAppId:(NSString *)appId config:(NSDictionary *)config {
    NSNumber *debugMode = [config fer_valueForKey:@"debugMode" defaultValue:@(NO)];
    NSString *channel = [config fer_valueForKey:@"channel" defaultValue:nil];
    NSString *deviceId = [config fer_valueForKey:@"deviceId" defaultValue:[[UIDevice currentDevice].identifierForVendor UUIDString]];
    NSNumber *reportLogLevel = [config fer_valueForKey:@"reportLogLevel" defaultValue:@(0)];
    
    BuglyConfig *buglyConfig = [BuglyConfig new];
    buglyConfig.debugMode = debugMode.boolValue;
    buglyConfig.channel = channel;
    buglyConfig.deviceIdentifier = deviceId;
    buglyConfig.reportLogLevel = reportLogLevel.integerValue;
    buglyConfig.version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    [Bugly startWithAppId:appId config:buglyConfig];
}

+ (void)setUserId:(NSString *)userId {
    [Bugly setUserIdentifier:userId];
}

+ (void)reportException:(NSException *)exception {
    [Bugly reportException:exception];
}

+ (void)reportExceptionWithName:(NSString *)aName
                         reason:(NSString *)aReason
                      callStack:(NSArray *)aStackArray
                   terminateApp:(BOOL)terminate {
    [Bugly reportExceptionWithCategory:5
                                  name:aName
                                reason:aReason
                             callStack:aStackArray
                             extraInfo:@{}
                          terminateApp:terminate];
}

@end
