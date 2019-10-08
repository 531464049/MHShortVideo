//
//  FoutListModel.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/14.
//  Copyright © 2018 mh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger  {
    HomeMsgFourTypeFance            = 0, //粉丝
    HomeMsgFourTypeZanMe            = 1, //赞我
    HomeMsgFourTypeAtMe             = 2, //@我的
    HomeMsgFourTypePingLunMe        = 3, //评论
}HomeMsgFourType;//消息首页 顶部四个按钮 类型

@interface MyFanceModel : NSObject

@property(nonatomic,copy)NSString * userHeaderImage;//头像
@property(nonatomic,copy)NSString * userName;//名字
@property(nonatomic,copy)NSString * timeStr;//时间

@end


@interface ZanMeModel : NSObject

@property(nonatomic,copy)NSString * userHeaderImage;//头像
@property(nonatomic,copy)NSString * userName;//名字
@property(nonatomic,copy)NSString * timeStr;//时间
@property(nonatomic,copy)NSString * videoPreImage;//视频预览图

@end


@interface ATMeModel : NSObject

@end


@interface PingLunMeModel : NSObject

@property(nonatomic,copy)NSString * userHeaderImage;//头像
@property(nonatomic,copy)NSString * userName;//名字
@property(nonatomic,copy)NSString * timeStr;//时间
@property(nonatomic,copy)NSString * videoPreImage;//视频预览图
@property(nonatomic,copy)NSString * content;//评论内容

@property(nonatomic,assign)CGFloat contentHeight;//评论内容高度
@property(nonatomic,strong)YYTextLayout * contentTextLayout;//评论内容约束
@property(nonatomic,assign)CGFloat cellHeight;//整体cell高度

@end





@interface FoutListModel : NSObject

+(NSArray *)testModels:(HomeMsgFourType)type;

@end
