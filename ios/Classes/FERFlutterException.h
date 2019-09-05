//
//  FERFlutterException.h
//  flutter_error_report
//
//  Created by JianFei Wang on 2019/9/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FERStackFrame : NSObject

+ (instancetype)stackFrame;
+ (instancetype)stackFrameWithAddress:(NSUInteger)address;
+ (instancetype)stackFrameWithSymbol:(NSString *)symbol;
+ (instancetype)stackFrameWithTrace:(NSDictionary *)trace;

@property (nonatomic, copy, nullable) NSString *symbol;
@property (nonatomic, copy, nullable) NSString *rawSymbol;
@property (nonatomic, copy, nullable) NSString *library;
@property (nonatomic, copy, nullable) NSString *fileName;
@property (nonatomic, assign) uint32_t lineNumber;
@property (nonatomic, assign) uint64_t offset;
@property (nonatomic, assign) uint64_t address;

@end

@interface FERFlutterException : NSException

@property (nonnull, strong) NSArray<FERStackFrame *> *stackFrames;

+ (instancetype)exceptionWithName:(NSExceptionName)aName reason:(nullable NSString *)aReason stackFrames:(NSArray<FERStackFrame *> *)stackFrames;
- (instancetype)initWithName:(NSExceptionName)aName reason:(nullable NSString *)aReason stackFrames:(NSArray<FERStackFrame *> *)stackFrames;

@end

NS_ASSUME_NONNULL_END
