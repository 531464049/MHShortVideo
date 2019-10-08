//
//  BangDanModel.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/11.
//  Copyright © 2018 mh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger  {
    BanDanListTypeHotSearch          = 0, //热搜榜
    BanDanListTypeVideo              = 1, //视频榜
    BanDanListTypeZhengPower         = 2, //正能量
}BanDanListType;//热搜榜单类型

@interface BangDanModel : NSObject

@property(nonatomic,assign)BanDanListType type;

@property(nonatomic,assign)NSInteger hotIndex;//热搜排行
@property(nonatomic,copy)NSString * hotSearchKey;//热搜-关键词
@property(nonatomic,copy)NSString * searchTimeStr;//热搜-搜索次数字符串
@property(nonatomic,copy)NSString * preImageUrl;//热搜视频预览图
@property(nonatomic,copy)NSString * videoUserName;//视频用户名


//随机数据
+(NSArray *)random_dataWithType:(BanDanListType)type;

@end
