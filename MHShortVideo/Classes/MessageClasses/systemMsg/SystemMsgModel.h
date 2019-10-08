//
//  SystemMsgModel.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/14.
//  Copyright © 2018 mh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageHomeModel.h"

@interface SystemMsgModel : NSObject

@property(nonatomic,assign)HomeMessageType messageType;//消息类型

/** 资讯消息 */
@property(nonatomic,copy)NSString * newsTypeIcon;//资讯来源icon
@property(nonatomic,copy)NSString * newsImage;//资讯图片


@property(nonatomic,copy)NSString * msgTitle;//消息标题-通用
@property(nonatomic,copy)NSString * msgDes;//消息描述-通用
@property(nonatomic,copy)NSString * msgTime;//消息时间-通用

@property(nonatomic,assign)CGFloat msgDesHeight;//消息描述 高度
@property(nonatomic,assign)CGFloat cellHeight;//整体cell高度


+(NSArray *)test_someModels:(HomeMessageType)msgType;

@end



@interface SystemMsgLayout : NSObject

@property(nonatomic,assign)CGFloat iconLeft;//图标-左边距
@property(nonatomic,assign)CGFloat iconTop;//图标-上边距
@property(nonatomic,assign)CGFloat iconWidth;//图标宽度

@property(nonatomic,assign)CGFloat titleLeft;//标题-图标-间隔
@property(nonatomic,assign)CGFloat titleTop;//标题-上边距
@property(nonatomic,assign)CGFloat titleRight;//标题-右边距
@property(nonatomic,assign)CGFloat titleHeight;//标题-高度 固定
@property(nonatomic,strong)UIFont * titleFont;//标题 字体

@property(nonatomic,assign)CGFloat desTop;//详情-标题-上边距
@property(nonatomic,strong)UIFont * desFont;//详情 字体

@property(nonatomic,assign)CGFloat rightItemRight;//右侧按钮/图片 右边距
@property(nonatomic,assign)CGFloat rightItemWidth;//右侧按钮/图片宽度

@property(nonatomic,assign)CGFloat time_des_Top;//时间-详情-间隔
@property(nonatomic,assign)CGFloat timeHeight;//时间 高度 固定
@property(nonatomic,strong)UIFont * timeFont;//详情 字体
@property(nonatomic,assign)CGFloat timeBottom;//时间-底部 间隔
@end
