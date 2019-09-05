#import "FlutterErrorReportPlugin.h"
#import "FlutterBuglyErrorReport.h"
#import "NSString+FERUtility.h"
#import "FERFlutterException.h"
#import "NSDictionary+FERUtility.h"
#import "NSArray+FERUtility.h"

@implementation FlutterErrorReportPlugin {
    BOOL _buglyInitialized;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel =
    [FlutterMethodChannel methodChannelWithName:@"flutter_error_report"
                                binaryMessenger:[registrar messenger]];
    FlutterErrorReportPlugin *instance = [[FlutterErrorReportPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call
                  result:(FlutterResult)result {
    NSString *method = call.method;
    id arguments = call.arguments;
    if ([@"initializeBugly" isEqualToString:method]) {
        [self _initializeBuglyWithArguments:arguments result:result];
    } else if ([@"setUserId" isEqualToString:method]) {
        [self _setUserIdWithArguments:arguments result:result];
    } else if ([@"reportError" isEqualToString:method]) {
        [self _reportErrorWithArguments:arguments result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

#pragma mark - Action

- (void)_initializeBuglyWithArguments:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *appId = arguments[@"appId"];
    if ([NSString fer_isEmpty:appId]) {
        result([self _resultWithMessage:@"AppId不能为空" success:NO]);
        return;
    }
    [FlutterBuglyErrorReport startWithAppId:appId config:arguments[@"config"]];
    result([self _resultWithMessage:@"Bugly初始化成功" success:YES]);
    _buglyInitialized = YES;
}

- (void)_setUserIdWithArguments:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *userId = arguments[@"userId"];
    if ([NSString fer_isEmpty:userId]) {
        result([self _resultWithMessage:@"userId不能为空" success:NO]);
        return;
    }
    if (_buglyInitialized) {
        [FlutterBuglyErrorReport setUserId:userId];
    }
    result([self _resultWithMessage:@"设置userId成功" success:YES]);
}

- (void)_reportErrorWithArguments:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *cause = [arguments fer_valueForKey:@"cause" defaultValue:@"Flutter Error"];
    NSString *message = [arguments fer_valueForKey:@"message" defaultValue:@""];
    NSArray<NSDictionary *> *traces = arguments[@"trace"];
    BOOL forceCrash = arguments[@"forceCrash"] ? [arguments[@"forceCrash"] boolValue] : false;
    NSArray<FERStackFrame *> *stackFrames = [traces fer_select:^id _Nonnull(id  _Nonnull item) {
        return [FERStackFrame stackFrameWithTrace:item];
    }];
//    FERFlutterException *exception = [FERFlutterException exceptionWithName:cause reason:message stackFrames:stackFrames];
    if (_buglyInitialized) {
//        [FlutterBuglyErrorReport reportException:exception];
        [FlutterBuglyErrorReport reportExceptionWithName:cause reason:message callStack:stackFrames terminateApp:forceCrash];
    }
    result([self _resultWithMessage:@"上报错误成功" success:YES]);
}

#pragma mark - Utility

- (NSString *)_resultWithMessage:(NSString *)message success:(BOOL)success {
    NSDictionary *resultInfo = @{ @"message": (message ?: @""), @"success": @(success) };
    NSData *resultInfoJSONData = [NSJSONSerialization dataWithJSONObject:resultInfo options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:resultInfoJSONData encoding:NSUTF8StringEncoding];
}

@end
