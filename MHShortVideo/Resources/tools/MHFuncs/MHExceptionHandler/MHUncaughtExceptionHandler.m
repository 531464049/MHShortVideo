//
//  MHUncaughtExceptionHandler.m
//  HZWebBrowser
//
//  Created by 马浩 on 2018/4/13.
//  Copyright © 2018年 HuZhang. All rights reserved.
//

#import "MHUncaughtExceptionHandler.h"

// 沙盒的地址
NSString * WeatherExcetionDocumentsDirectory() {
    NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject;
    NSString * dicpath = [cacheDir stringByAppendingPathComponent:@"WeatherExcetion"];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSError *error = nil;
    if(![filemgr createDirectoryAtPath:dicpath withIntermediateDirectories:YES attributes:nil error:&error]) {
        NSLog(@"Failed to create cache directory at %@", dicpath);
    }
    return dicpath;
    
}

// 崩溃时的回调函数
void UncaughtExceptionHandler(NSException * exception) {
    NSArray * arr = [exception callStackSymbols];
    NSString * reason = [exception reason]; // // 崩溃的原因  可以有崩溃的原因(数组越界,字典nil,调用未知方法...) 崩溃的控制器以及方法
    NSString * name = [exception name];
    NSDictionary * userInfo = [exception userInfo];
    NSString * url = [NSString stringWithFormat:@"========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@\nuserInfo:%@",name,reason,[arr componentsJoinedByString:@"\n"],userInfo];
    // 将一个txt文件写入沙盒
    [MHUncaughtExceptionHandler writeError:url];
}

@implementation MHUncaughtExceptionHandler

+ (void)setDefaultHandler {
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    [MHUncaughtExceptionHandler sendExceptionLog];
}

+ (NSUncaughtExceptionHandler *)getHandler {
    return NSGetUncaughtExceptionHandler();
}

+ (void)TakeException:(NSException *)exception {
    NSArray * arr = [exception callStackSymbols];
    NSString * reason = [exception reason]; // // 崩溃的原因  可以有崩溃的原因(数组越界,字典nil,调用未知方法...) 崩溃的控制器以及方法
    NSString * name = [exception name];
    NSDictionary * userInfo = [exception userInfo];
    NSString * url = [NSString stringWithFormat:@"========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@\nuserInfo:%@",name,reason,[arr componentsJoinedByString:@"\n"],userInfo];
    [MHUncaughtExceptionHandler writeError:url];
}
+(void)writeError:(NSString *)errorMsg
{
    //以当前时间戳命名文件  - 服务器那边对文件名没要求
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970];
    NSString * fileName = [NSString stringWithFormat:@"WeatherException%f.txt",time];
    NSString * path = [WeatherExcetionDocumentsDirectory() stringByAppendingPathComponent:fileName];
    // 将一个txt文件写入沙盒
    //    [NSKeyedArchiver archiveRootObject:errorMsg toFile:path];
    [errorMsg writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
#pragma mark - 发送错误日志
+ (void)sendExceptionLog
{
    // 发送崩溃日志
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:WeatherExcetionDocumentsDirectory()];
    for (NSString *subFile in files) {
        NSString *path = [WeatherExcetionDocumentsDirectory() stringByAppendingPathComponent:subFile];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [MHUncaughtExceptionHandler uploadFile:path];
        }
    }
}
+(void)uploadFile:(NSString *)path
{
    //文件存在-上传
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"%@",content);
    if ([content containsString:@"WXOMTASocket"]) {
        //这貌似是微信什么返回的错误
        //删除
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    }else{
//        NSDictionary * postDic = @{@"appkey":TongJi_AppKey(),
//                                   @"platform":@"2",
//                                   @"deviceid":[MHSystemHelper getDeviceUUID],
//                                   @"appversion":[MHSystemHelper getAppVersion],
//                                   @"phonemodels":[MHSystemHelper getDeviceName],
//                                   @"systemversion":[MHSystemHelper getSysVersion],
//                                   @"logtimestamp":[NSString stringWithFormat:@"%@",[NSObject getCurentTimeStr]],
//                                   @"errormsg":content
//                                   };
//        NSString * url = [NSString stringWithFormat:@"%@app/log",PORT_TongJi()];
//        [HZNetWork POST:url param:postDic callback:^(NetWorkModel *netModel) {
//            //删除
//            NSError *error;
//            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
//        }];
    }

}
+(void)cleanAll
{
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:WeatherExcetionDocumentsDirectory()];
    for (NSString *subFile in files) {
        NSString *path = [WeatherExcetionDocumentsDirectory() stringByAppendingPathComponent:subFile];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            //删除
            NSError *error;
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        }
    }
}
@end
