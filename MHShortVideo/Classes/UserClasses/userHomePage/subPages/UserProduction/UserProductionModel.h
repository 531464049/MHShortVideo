//
//  UserProductionModel.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/20.
//  Copyright © 2018 mh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProductionModel : NSObject

@property(nonatomic,copy)NSString * preImage;//视频预览图
@property(nonatomic,copy)NSString * likedNumStr;//点赞人数字符串

+(NSArray *)testProductionModels;

@end
