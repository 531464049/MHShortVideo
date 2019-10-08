//
//  BangDanModel.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/11.
//  Copyright © 2018 mh. All rights reserved.
//

#import "BangDanModel.h"

@implementation BangDanModel

+(NSArray *)random_dataWithType:(BanDanListType)type
{
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < 20; i ++) {
        BangDanModel * model = [[BangDanModel alloc] init];
        model.type = type;
        
        if (type == BanDanListTypeHotSearch) {
            model.hotIndex = i + 1;
            model.hotSearchKey = [self t_title:i%10];
            model.searchTimeStr = @"123.4w";
        }
        
        [arr addObject:model];
    }
    
    return [NSArray arrayWithArray:arr];
}
+(NSString *)t_title:(NSInteger)index
{
    NSArray * arr = @[
                      @"阿拉伯国有电视台",
                      @"卡塔尔",
                      @"海外网",
                      @"《报告》作者",
                      @"资产管理机构缺少有效",
                      @"洪磊上述分报告",
                      @"避免面",
                      @"还不能完全满足",
                      @"具体来说",
                      @"我国仅有三只股指期货"];
    return arr[index];
}
@end
