//
//  SearchModel.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/10.
//  Copyright © 2018 mh. All rights reserved.
//

#import "SearchModel.h"

@implementation SearchModel

+(NSArray *)randomDataArr
{
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 10; i ++) {
        SearchModel * model = [[SearchModel alloc] init];
        model.topicName = [self t_topictitle:i];
        model.dataNumStr = @"202.9w";
        model.topicImagesArr = [self t_topicImages];
        
        [arr addObject:model];
    }
    return [NSArray arrayWithArray:arr];
}
+(NSString *)t_topictitle:(NSInteger)index
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
+(NSArray *)t_topicImages
{
    NSArray * arr = @[
                      @"https://img.xiaohua.com/picture/201811266367884726093581093832945.jpg",
                      @"https://img.xiaohua.com/Picture/0/11/11205_20180526024238883_0.jpg",
                      @"https://img.xiaohua.com/picture/201811296367910506009836023194005.jpg",
                      @"https://img.xiaohua.com/Picture/0/13/13175_20180525214554225_0.jpg",
                      @"https://img.xiaohua.com/Picture/0/15/15854_20180525150149323_0.jpg",
                      @"https://img.xiaohua.com/Picture/0/103/103172_20180520005428048_0.jpg",
                      @"https://img.xiaohua.com/picture/201811306367919210476342532131195.jpeg",
                      @"https://img.xiaohua.com/Picture/0/28/28635_20180524194832739_0.jpg",
                      @"https://img.xiaohua.com/Picture/0/48/48488_20180516144029305_0.jpg",
                      @"https://img.xiaohua.com/Picture/0/16/16199_20180525141023968_0.jpg"];
    return arr;
}
@end


@implementation SearchHeaderModel

+(SearchHeaderModel *)randomHeadeModel
{
    SearchHeaderModel * model = [[SearchHeaderModel alloc] init];
    
    NSMutableArray * hotArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 6; i ++) {
        HotSearchModel * hot = [[HotSearchModel alloc] init];
        hot.title = [self t_topictitle:i];
        hot.imgUrl = [self t_topicImages:i];
        hot.hotType = i % 3;
        [hotArr addObject:hot];
    }
    model.hotSearchModels = [NSArray arrayWithArray:hotArr];
    
    NSArray * arr = @[
                      @"https://img.xiaohua.com/picture/201811266367884726093581093832945.jpg",
                      @"https://img.xiaohua.com/Picture/0/11/11205_20180526024238883_0.jpg",
                      @"https://img.xiaohua.com/picture/201811296367910506009836023194005.jpg",
                      @"https://img.xiaohua.com/Picture/0/13/13175_20180525214554225_0.jpg",
                      @"https://img.xiaohua.com/Picture/0/15/15854_20180525150149323_0.jpg",
                      @"https://img.xiaohua.com/Picture/0/103/103172_20180520005428048_0.jpg"
                      ];
    model.adArr = arr;
    
    return model;
}
+(NSString *)t_topictitle:(NSInteger)index
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
+(NSString *)t_topicImages:(NSInteger)index
{
    NSArray * arr = @[
                      @"https://img.xiaohua.com/picture/201811266367884726093581093832945.jpg",
                      @"https://img.xiaohua.com/Picture/0/11/11205_20180526024238883_0.jpg",
                      @"https://img.xiaohua.com/picture/201811296367910506009836023194005.jpg",
                      @"https://img.xiaohua.com/Picture/0/13/13175_20180525214554225_0.jpg",
                      @"https://img.xiaohua.com/Picture/0/15/15854_20180525150149323_0.jpg",
                      @"https://img.xiaohua.com/Picture/0/103/103172_20180520005428048_0.jpg"
                      ];
    return arr[index];
}
@end

@implementation HotSearchModel

@end
