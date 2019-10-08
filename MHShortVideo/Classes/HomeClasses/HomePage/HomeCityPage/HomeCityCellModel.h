//
//  HomeCityCellModel.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/7.
//  Copyright © 2018 mh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeCityCellModel : NSObject

@property(nonatomic,copy)NSString * preImageUrl;//预览图
@property(nonatomic,assign)CGFloat distance;//距离
@property(nonatomic,copy)NSString * location;//位置
@property(nonatomic,copy)NSString * title;//标题
@property(nonatomic,copy)NSString * userImage;//用户头像
@property(nonatomic,copy)NSString * userName;//用户名
@property(nonatomic,assign)BOOL isZan;//是否点赞
@property(nonatomic,assign)NSInteger zanNum;//点赞数量

@property(nonatomic,assign)CGFloat preImageHeight;//预览图cell显示高度
@property(nonatomic,assign)CGFloat titleHeight;//标题高度

@property(nonatomic,assign)CGFloat cellHeight;//cell整体高度

+(NSArray<HomeCityCellModel *> *)getSomemModels;

@end
