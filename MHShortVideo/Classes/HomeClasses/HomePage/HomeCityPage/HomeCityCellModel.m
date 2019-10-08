//
//  HomeCityCellModel.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/7.
//  Copyright © 2018 mh. All rights reserved.
//

#import "HomeCityCellModel.h"

@implementation HomeCityCellModel

+ (NSArray<HomeCityCellModel *> *)getSomemModels
{
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 10; i ++) {
        HomeCityCellModel * model = [[HomeCityCellModel alloc] init];
        model.preImageUrl = [self t_videoPreImage:i];
        model.distance = 12.5;
        model.location = @"凤凰上森林宏源-凤凰公园345号";
        model.title = [self t_videotitle:i];
        model.userImage = @"http://pic32.photophoto.cn/20140819/0008020285038599_b.jpg";
        model.userName = @"二狗";
        model.isZan = i/2==0;
        int zanNUm = arc4random() % 2000 + 10;
        model.zanNum = zanNUm;
        
        model.preImageHeight = [self t_preHieght];
        
        
        CGFloat waterWidth = (Screen_WIDTH - 25) / 2;//流水cell宽度
        //计算标题高度
        CGFloat textHeight = [model.title textHeight:FONT(14) width:waterWidth lineSpace:7 keming:0];
        if (textHeight >= (FONT(14).lineHeight * 3 + 7*2)) {
            textHeight = FONT(14).lineHeight * 3 + 7*2;
        }
        model.titleHeight = textHeight + 10;
        
        CGFloat totleHieght = model.preImageHeight + Width(30) + model.titleHeight + Width(30) + Width(20);
        model.cellHeight = totleHieght;
        [arr addObject:model];
    }
    return [NSArray arrayWithArray:arr];
}
+(CGFloat)t_preHieght
{
    NSArray * arr = @[@(180.f),@(200.f),@(240.f),@(280.f),@(320.f),@(360.f),@(350.f),@(340.f),@(300.f),@(120.f)];
    int a = arc4random() % arr.count;
    return [arr[a] floatValue];
}
+(NSString *)t_videoPreImage:(NSInteger)index
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
    return arr[index];
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
