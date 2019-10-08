//
//  MessageHomeModel.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/14.
//  Copyright © 2018 mh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger  {
    HomeMessageTypeNews            = 0, //资讯消息
    HomeMessageTypeHelper          = 1, //助手消息
    HomeMessageTypeSystem          = 2, //系统消息
    HomeMessageTypeUserContact     = 3, //用户聊天
}HomeMessageType;//消息首页 类型

@interface MessageHomeModel : NSObject

@property(nonatomic,assign)HomeMessageType messageType;//消息类型

@property(nonatomic,copy)NSString * msgStr;//消息文本
@property(nonatomic,copy)NSString * msgTimeStr;//消息时间文本

@property(nonatomic,copy)NSString * userHeaderImage;//联系人头像-聊天类型可用
@property(nonatomic,copy)NSString * userName;//联系人头像-聊天类型可用


+(NSArray *)testModels;
@end
