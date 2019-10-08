//
//  MHUncaughtExceptionHandler.h
//  HZWebBrowser
//
//  Created by 马浩 on 2018/4/13.
//  Copyright © 2018年 HuZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHUncaughtExceptionHandler : NSObject

+ (void)setDefaultHandler;
+ (void)sendExceptionLog;
+ (NSUncaughtExceptionHandler *)getHandler;
+ (void)TakeException:(NSException *) exception;


+(void)writeError:(NSString *)errorMsg;

+(void)cleanAll;
@end
