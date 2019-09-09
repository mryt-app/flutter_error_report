//
//  FERFlutterException.m
//  flutter_error_report
//
//  Created by JianFei Wang on 2019/9/5.
//

#import "FERFlutterException.h"
#import "NSString+FERUtility.h"
#import "NSDictionary+FERUtility.h"

@implementation FERStackFrame

+ (instancetype)stackFrame {
    return [FERStackFrame new];
}

+ (instancetype)stackFrameWithAddress:(NSUInteger)address {
    FERStackFrame *instance = [FERStackFrame new];
    instance.address = address;
    return instance;
}

+ (instancetype)stackFrameWithSymbol:(NSString *)symbol {
    FERStackFrame *instance = [FERStackFrame new];
    instance.symbol = symbol;
    return instance;
}

+ (instancetype)stackFrameWithTrace:(NSDictionary *)trace {
    NSString *className = [trace fer_valueForKey:@"class" defaultValue:@""];
    NSString *methodName = [trace fer_valueForKey:@"method" defaultValue:@""];
    NSString *libraryName = [trace fer_valueForKey:@"library" defaultValue:@""];
    NSString *symbol = [NSString stringWithFormat:@"%@.%@", className, methodName];
    
    FERStackFrame *instance = [FERStackFrame stackFrameWithSymbol:symbol];
    instance.library = libraryName;
    instance.rawSymbol = className;
    instance.fileName = libraryName;
    
    if (trace[@"line"] != nil && ![trace[@"line"] isEqual:[NSNull null]]) {
        instance.lineNumber = [(NSNumber *)trace[@"line"] unsignedIntValue];
    }
    return instance;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@(%@:%u)", self.symbol ?: @"", self.fileName, self.lineNumber];
}

@end

@implementation FERFlutterException {
    NSArray<NSString *> *_callStackSymbols;
}

+ (instancetype)exceptionWithName:(NSExceptionName)aName reason:(nullable NSString *)aReason stackFrames:(NSArray<FERStackFrame *> *)stackFrames {
    FERFlutterException *instance = [[FERFlutterException alloc] initWithName:aName reason:aReason stackFrames:stackFrames];
    return instance;
}

- (instancetype)initWithName:(NSExceptionName)aName reason:(nullable NSString *)aReason stackFrames:(NSArray<FERStackFrame *> *)stackFrames {
    self = [super initWithName:aName reason:aReason userInfo:nil];
    if (self) {
        self.stackFrames = stackFrames;
        
        NSMutableArray<NSString *> *data = [[NSMutableArray <NSString *> alloc] initWithCapacity:self.stackFrames.count];
        for (NSUInteger i = 0; i < self.stackFrames.count; ++i) {
            [data insertObject:self.stackFrames[i].description atIndex:i];
        }
        
        _callStackSymbols = data;
    }
    return self;
}

@end
