//
//  AppInfo.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/30.
//  Copyright © 2018 mh. All rights reserved.
//

#import "AppInfo.h"

@implementation AppInfo

+(AppInfo *)sharedInstance
{
    static AppInfo * _AppInfo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _AppInfo = [[AppInfo alloc] init];
    });
    return _AppInfo;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userCity = @"深圳市";
    }
    return self;
}
@end
