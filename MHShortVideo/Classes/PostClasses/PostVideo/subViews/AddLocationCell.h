//
//  AddLocationCell.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/3.
//  Copyright © 2018 mh. All rights reserved.
//

#import "BaseView.h"

@class LocationModel;

@interface AddLocationCell : BaseCell

@property(nonatomic,strong)LocationModel * model;

@end



@interface LocationModel : NSObject

@property(nonatomic,copy)NSString * locationNmae;//位置名称
@property(nonatomic,copy)NSString * locationDetail;//详细位置
@property(nonatomic,assign)NSInteger distance;//距中心点的距离，单位米

@property(nonatomic,copy)NSString * searchKey;//搜索key

/** 是否是用户所在的城市的城市名称 */
@property(nonatomic,assign)BOOL isUserCity;

@end
