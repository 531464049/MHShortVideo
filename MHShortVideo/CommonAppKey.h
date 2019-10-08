//
//  CommonAppKey.h
//  HzWeather
//
//  Created by 马浩 on 2018/8/28.
//  Copyright © 2018年 马浩. All rights reserved.
//

#ifndef CommonAppKey_h
#define CommonAppKey_h

/*所有通用的key，通知名称 通用的数据 类型 全部在这里*/
////首次开启app
static NSString * const UDKey_AppFirstTimeOpen = @"udkey_appIsFirsttimeOpen_udkey";
//UserDefaults 统计 port key
static NSString * const UDKey_TongjiPort = @"UDKey_TongjiPortUDKey_TongjiPort";
//UserDefaults AppKey key
static NSString * const UDKey_AppKey = @"UDKey_AppKeyUDKey_AppKey";
//UserDefaults 分享地址 key
static NSString * const UDKey_ShareAppUrlKey = @"UDKey_ShareAppKeyUDKey_ShareAppKey";


typedef enum : NSInteger  {
    MHShootSpeedTypeMoreSlow       = 0, //极慢
    MHShootSpeedTypeaSlow          = 1, //慢
    MHShootSpeedTypeNomal          = 2, //标准
    MHShootSpeedTypeFast           = 3, //快
    MHShootSpeedTypeMorefast       = 4, //极快
}MHShootSpeedType;//视频拍摄速度类型

typedef enum : NSInteger  {
    MHPostVideoOpenTypeOpen          = 0, //公开
    MHPostVideoOpenTypeOnlyFriend    = 1, //仅好友可见
    MHPostVideoOpenTypeUnOpen        = 2, //不公开
}MHPostVideoOpenType;//视频发布 公开类型

#endif /* CommonAppKey_h */
