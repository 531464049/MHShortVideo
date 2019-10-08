//
//  UserProductionModel.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/20.
//  Copyright © 2018 mh. All rights reserved.
//

#import "UserProductionModel.h"

@implementation UserProductionModel

+(NSArray *)testProductionModels
{
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < 30; i ++) {
        UserProductionModel * model = [[UserProductionModel alloc] init];
        model.preImage = [MHVideoTool t_videoPreImage:i];
        model.likedNumStr = @"1.3w";
        [arr addObject:model];
    }
    
    return [NSArray arrayWithArray:arr];
}

@end
