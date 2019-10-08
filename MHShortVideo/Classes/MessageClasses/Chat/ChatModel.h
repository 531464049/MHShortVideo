//
//  ChatModel.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/17.
//  Copyright © 2018 mh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    MHChatMsgFromTypeMeSend,         //我发送的
    MHChatMsgFromTypeSendToMe        //发送给我的
} MHChatMsgFromType;//消息来源类型

typedef enum : NSUInteger {
    MHChatMsgTypeText,         //文本类型
    MHChatMsgTypeImage         //图片类型
} MHChatMsgType;//消息类型

@interface ChatModel : NSObject

@property(nonatomic,assign)MHChatMsgFromType fromType;//消息来源 是否我发送的
@property(nonatomic,assign)MHChatMsgType msgType;//消息类型

@property(nonatomic,copy)NSString * userIcon;//用户头像
@property(nonatomic,copy)NSString * userName;//用户名字

@property(nonatomic,copy)NSString * msgText;//消息文本

@property(nonatomic,copy)NSString * imageUrl;//图片地址
@property(nonatomic,assign)CGFloat imageWidth;//图片原始宽度
@property(nonatomic,assign)CGFloat imageHeight;//图片原始高度



@property(nonatomic,strong)YYTextLayout * msgTextLayout;//消息内容约束-文本消息时可用
@property(nonatomic,assign)CGFloat imageCellWidth;//图片在cell中显示的宽度-图片消息时可用
@property(nonatomic,assign)CGFloat imageCellHeight;//图片在cell中显示的高度-图片消息时可用

@property(nonatomic,assign)CGFloat containerWidth;//内容容器宽度
@property(nonatomic,assign)CGFloat containerHeight;//内容容器高度
@property(nonatomic,assign)CGFloat cellHeight;

+(NSArray *)testChatModels;

+(void)test200Models:(void(^)(NSArray * models))callBack;

@end

