//
//  NSObject+MHException.m
//  HZWebBrowser
//
//  Created by 马浩 on 2018/5/5.
//  Copyright © 2018年 HuZhang. All rights reserved.
//

#import "NSObject+MHException.h"

@implementation NSObject (MHException)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
-(id)forwardingTargetForSelector:(SEL)aSelector
{
    
    NSString *selectorStr = NSStringFromSelector(aSelector);
    //NSLog(@"[%@]-----[%@]",self.class,selectorStr);
    // 做一次类的判断，只对 UIResponder 和 NSNull 有效
    if ([self isKindOfClass: [NSArray class]] ||
        [self isKindOfClass: [NSDictionary class]] ||
        [self isKindOfClass: [NSNull class]] ||
        [self isKindOfClass: [NSString class]] ||
        [self isKindOfClass: [NSMutableArray class]] ||
        [self isKindOfClass: [NSMutableDictionary class]])
    {
        NSString * errorMsg1 = [NSString stringWithFormat:@"PROTECTOR: -[%@ %@]", [self class], selectorStr];
        NSLog(@"%@", errorMsg1);
        NSString * errorMsg2 = [NSString stringWithFormat:@"PROTECTOR: unrecognized selector \"%@\" sent to instance: %p", selectorStr, self];
        NSLog(@"%@", errorMsg2);
        NSString * errorMsg3 = [NSString stringWithFormat:@"PROTECTOR: call stack: %@", [NSThread callStackSymbols]];
        NSLog(@"%@", errorMsg3);
        
        NSString * allErrerMsg = [NSString stringWithFormat:@"%@\n%@\n%@",errorMsg1,errorMsg2,errorMsg3];
        [MHUncaughtExceptionHandler writeError:allErrerMsg];
        // 对保护器插入该方法的实现
        Class protectorCls = NSClassFromString(@"Protector");
        if (!protectorCls)
        {
            protectorCls = objc_allocateClassPair([NSObject class], "Protector", 0);
            objc_registerClassPair(protectorCls);
        }
        
        // 检查类中是否存在该方法，不存在则添加
        if (![self isExistSelector:aSelector inClass:protectorCls])
        {
            class_addMethod(protectorCls, aSelector, [self safeImplementation:aSelector],
                            [selectorStr UTF8String]);
        }
        
        Class Protector = [protectorCls class];
        id instance = [[Protector alloc] init];
        
        return instance;
    }
    else
    {
        return nil;
    }
    
}
// 一个安全的方法实现
- (IMP)safeImplementation:(SEL)aSelector
{
    IMP imp = imp_implementationWithBlock(^()
                                          {
                                              NSLog(@"PROTECTOR: %@ Done", NSStringFromSelector(aSelector));
                                          });
    return imp;
}
// 判断某个class中是否存在某个SEL
- (BOOL)isExistSelector: (SEL)aSelector inClass:(Class)currentClass
{
    BOOL isExist = NO;
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(currentClass, &methodCount);
    
    for (int i = 0; i < methodCount; i++)
    {
        Method temp = methods[i];
        SEL sel = method_getName(temp);
        NSString *methodName = NSStringFromSelector(sel);
        if ([methodName isEqualToString: NSStringFromSelector(aSelector)])
        {
            isExist = YES;
            break;
        }
    }
    return isExist;
}
#pragma clang diagnostic pop
@end
