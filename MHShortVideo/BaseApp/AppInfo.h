//
//  AppInfo.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/30.
//  Copyright © 2018 mh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppInfo : NSObject

@property(nonatomic,copy)NSString * userCity;//城市
@property(nonatomic,assign)CGFloat userLatitude;//纬度
@property(nonatomic,assign)CGFloat userLongitude;//经度

+(AppInfo *)sharedInstance;

@end
