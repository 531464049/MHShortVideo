//
//  MHStatistics.m
//  HZWebBrowser
//
//  Created by 马浩 on 2018/5/7.
//  Copyright © 2018年 HuZhang. All rights reserved.
//

#import "MHStatistics.h"

static NSString * const KLastUnUoloadCloseTime = @"KLastUnUoloadCloseTime";

@interface MHStatistics ()

@property(nonatomic,assign)NSInteger openTime;
@property(nonatomic,assign)NSInteger closeTime;

@end

@implementation MHStatistics
+(MHStatistics *)sharedInstance
{
    static MHStatistics * _info;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _info = [[MHStatistics alloc] init];
    });
    
    return _info;
}
-(id)init
{
    self = [super init];
    if (self) {
        self.closeTime = 0;
        self.openTime = 0;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}
#pragma mark - app状态变更回调
- (void)applicationWillTerminate:(NSNotification *)not
{
    NSLog(@"----applicationWillTerminate----");
    //在这里保存信息（如果有必要的话）
    if (self.closeTime > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:@(self.closeTime) forKey:KLastUnUoloadCloseTime];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@([[NSObject getCurentTimeStr] integerValue]) forKey:KLastUnUoloadCloseTime];
    }
}
- (void)applicationWillResignActive:(NSNotification *)not
{
    NSLog(@"----applicationWillResignActive----");
    self.closeTime = [[NSObject getCurentTimeStr] integerValue];
    [[NSUserDefaults standardUserDefaults] setObject:@(self.closeTime) forKey:KLastUnUoloadCloseTime];
    
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^(){
        //程序在10分钟内未被系统关闭或者强制关闭，则程序会调用此代码块，可以在这里做一些保存或者清理工作
        NSLog(@"程序关闭");
        [self uploadCloseTime:self.closeTime];
    }];
}
- (void)applicationDidBecomeActive:(NSNotification *)not
{
//    NSLog(@"----applicationDidBecomeActive----");
    //启动
    //发送上次未上传的退出时间
    
    if (self.closeTime == 0 && self.openTime == 0) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:KLastUnUoloadCloseTime]) {
            //上次的退出时间还未上传
            NSString * last = [[NSUserDefaults standardUserDefaults] objectForKey:KLastUnUoloadCloseTime];
            NSInteger lastUpUploadTime = [last integerValue];
            [self uploadCloseTime:lastUpUploadTime];
        }
    }

    if (self.closeTime > 0) {
        //间隔太少 不记录
        self.closeTime = 0;
    }else{
        self.openTime = [[NSObject getCurentTimeStr] integerValue];
        self.closeTime = 0;
        [self uploadOpenTime:self.openTime];
    }
}
#pragma mark - 上传开启时间
-(void)uploadOpenTime:(NSInteger )openTime
{
    if (openTime < 10) {
        return;
    }
//    NSDictionary * postDic = @{@"appkey":TongJi_AppKey(),
//                               @"platform":@"2",
//                               @"deviceid":[MHSystemHelper getDeviceUUID],
//                               @"appversion":[MHSystemHelper getAppVersion],
//                               @"phonemodels":[MHSystemHelper getDeviceName],
//                               @"systemversion":[MHSystemHelper getSysVersion],
//                               @"mobilescreen":[MHSystemHelper getDeviceSize],
//                               @"mobilenet":[MHSystemHelper getNetworkType],
//                               @"mobilecarrier":[MHSystemHelper getTelephonyInfo],
//                               @"inout":@"0",
//                               @"logtimestamp":[NSString stringWithFormat:@"%ld",(long)openTime]
//                               };
//    NSString * url = [NSString stringWithFormat:@"%@app/statistical",PORT_TongJi()];
//    [HZNetWork POST:url param:postDic callback:^(NetWorkModel *netModel) {
//
//    }];
}
#pragma mark - 上传关闭时间
-(void)uploadCloseTime:(NSInteger )closeTime
{
    if (closeTime < 10) {
        return;
    }
//    NSDictionary * postDic = @{@"appkey":TongJi_AppKey(),
//                               @"platform":@"2",
//                               @"deviceid":[MHSystemHelper getDeviceUUID],
//                               @"appversion":[MHSystemHelper getAppVersion],
//                               @"phonemodels":[MHSystemHelper getDeviceName],
//                               @"systemversion":[MHSystemHelper getSysVersion],
//                               @"mobilescreen":[MHSystemHelper getDeviceSize],
//                               @"mobilenet":[MHSystemHelper getNetworkType],
//                               @"mobilecarrier":[MHSystemHelper getTelephonyInfo],
//                               @"inout":@"1",
//                               @"logtimestamp":[NSString stringWithFormat:@"%ld",(long)closeTime]
//                               };
//    NSString * url = [NSString stringWithFormat:@"%@app/statistical",PORT_TongJi()];
//    [HZNetWork POST:url param:postDic callback:^(NetWorkModel *netModel) {
//
//    }];
    self.closeTime = 0;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KLastUnUoloadCloseTime];
}
-(void)startStatistics
{
    //NSLog(@"统计==========开启");
}
+(void)startStatistics
{
    [[MHStatistics sharedInstance] startStatistics];
}
@end
