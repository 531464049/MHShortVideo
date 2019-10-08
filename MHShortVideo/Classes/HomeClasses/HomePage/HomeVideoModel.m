//
//  HomeVideoModel.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/3.
//  Copyright © 2018 mh. All rights reserved.
//

#import "HomeVideoModel.h"

@implementation HomeVideoModel

+(HomeVideoModel *)randomAModel
{
    int i = arc4random() % 20;
    HomeVideoModel * model = [HomeVideoModel new];
    model.videoUrl = [MHVideoTool test_getAVideoUrl:i];
    model.videoPreImage = [MHVideoTool t_videoPreImage:i];
    model.videoTitle = [HomeVideoModel t_videotitle:i];
    model.userName = @"二狗";
    model.isLiked = NO;
    model.userImage = @"http://pic32.photophoto.cn/20140819/0008020285038599_b.jpg";
    
    int x = arc4random() % 2000000;
    model.zanNum = x;
    int y = arc4random() % 2000000;
    model.commentNum = y;
    int z = arc4random() % 2000000;
    model.shareNum = z;
    return model;
}

+(NSString *)t_videotitle:(NSInteger)index
{
    NSArray * arr = @[
                      @"阿拉伯国有电视台等媒体报道，卡塔尔能源部长表示，该国将在2019年初退出石油输出国组织欧佩克",
                      @"卡塔尔方面表示，退出的时间确定为2019年1月，当日早间已将此决定告知这一组织。",
                      @"海外网12月3日电",
                      @"《报告》作者不少来自金融监管部门，其中一篇题为“现代金融体系中的金融市场改革”分报告就由现任中国基金业协会会长洪磊撰写，发展金融衍生品的重要性被多次提及，格外引人关注。",
                      @"资产管理机构缺少有效风险管理工具",
                      @"洪磊上述分报告中提到了国内资本市场现状与问题",
                      @"避免面对同一冲击产生强烈的市场共振。与境外成熟市场相比，我国金融衍生品市场起步晚、发展慢、产品少、发挥不充分等问题仍然比较突出，还不能",
                      @"还不能完全满足各类机构日益增长的多元化风险管理需求。",
                      @"具体来说，产品层面",
                      @"我国仅有三只股指期货、两只国债期货、一只股票期权，股指期权、外汇期权尚未空白"];
    return arr[index];
}
@end
