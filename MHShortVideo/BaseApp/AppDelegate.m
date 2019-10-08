//
//  AppDelegate.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/13.
//  Copyright © 2018年 mh. All rights reserved.
//

#import "AppDelegate.h"
#import "RootTabBarVC.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface AppDelegate ()

@property(nonatomic,strong)AMapLocationManager * locationManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //高德地图配置
    [AMapServices sharedServices].apiKey = @"16f20c2e3f1c611994dcdf580f2a109f";
    //定位
    [self requestUserLocation];
    
    UIWindow * keywindow = [UIApplication sharedApplication].keyWindow;
    if (!keywindow) {
        keywindow = [[UIApplication sharedApplication].windows firstObject];
    }
    RootTabBarVC * tab = [RootTabBarVC sharedInstance];
    keywindow.rootViewController = tab;
    
    return YES;
}
#pragma mark - 定位
-(void)requestUserLocation
{
    self.locationManager = [[AMapLocationManager alloc] init];
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =2;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error) {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            AppInfo.sharedInstance.userLatitude = 22.52426676;
            AppInfo.sharedInstance.userLongitude = 113.93607964;
            AppInfo.sharedInstance.userCity = @"深圳市";
            
            if (error.code == AMapLocationErrorLocateFailed) {
                return;
            }
        }
        NSLog(@"location:%@", location);
        AppInfo.sharedInstance.userLatitude = location.coordinate.latitude;
        AppInfo.sharedInstance.userLongitude = location.coordinate.longitude;
        if (regeocode) {
            NSLog(@"reGeocode:%@", regeocode);
            AppInfo.sharedInstance.userCity = regeocode.city;
        }
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
