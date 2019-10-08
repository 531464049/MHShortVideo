//
//  SRVideoCell.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/12.
//  Copyright © 2018 mh. All rights reserved.
//

#import "SRVideoCell.h"

@interface SRVideoCell ()

@property(nonatomic,strong)UIImageView * preImage;
@property(nonatomic,strong)UIImageView * headerImage;
@property(nonatomic,strong)UILabel * nameLab;
@property(nonatomic,strong)UILabel * zanNumLab;
@property(nonatomic,strong)UIImageView * zanIcon;
@property(nonatomic,strong)UILabel * titleLab;

@end

@implementation SRVideoCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        CGFloat width = CGRectGetWidth(self.frame);
        CGFloat height = CGRectGetHeight(self.frame);
        
        self.preImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        self.preImage.contentMode = UIViewContentModeScaleAspectFill;
        self.preImage.clipsToBounds = YES;
        [self.contentView addSubview:self.preImage];
        
        self.headerImage = [[UIImageView alloc] init];
        self.headerImage.contentMode = UIViewContentModeScaleAspectFill;
        self.headerImage.clipsToBounds = YES;
        self.headerImage.layer.cornerRadius = Width(15);
        self.headerImage.layer.masksToBounds = YES;
        [self.contentView addSubview:self.headerImage];
        self.headerImage.sd_layout.leftSpaceToView(self.contentView, Width(15)).bottomSpaceToView(self.contentView, Width(10)).widthIs(Width(30)).heightEqualToWidth();
        
        self.nameLab = [UILabel labTextColor:[UIColor grayColor] font:FONT(14) aligent:NSTextAlignmentLeft];
        self.nameLab.numberOfLines = 1;
        [self.contentView addSubview:self.nameLab];
        self.nameLab.sd_layout.leftSpaceToView(self.headerImage, 3).centerYEqualToView(self.headerImage).rightSpaceToView(self.contentView, Width(70)).heightIs(20);
        
        self.zanNumLab = [UILabel labTextColor:[UIColor grayColor] font:FONT(14) aligent:NSTextAlignmentRight];
        self.zanNumLab.numberOfLines = 1;
        [self.contentView addSubview:self.zanNumLab];
        self.zanNumLab.sd_layout.rightSpaceToView(self.contentView, Width(15)).centerYEqualToView(self.headerImage).heightIs(20);
        [self.zanNumLab setSingleLineAutoResizeWithMaxWidth:Width(50)];
        
        self.zanIcon = [[UIImageView alloc] init];
        self.zanIcon.contentMode = UIViewContentModeScaleAspectFit;
        self.zanIcon.clipsToBounds = YES;
        self.zanIcon.image = [UIImage imageNamed:@"home_likeUnSelected"];
        [self.contentView addSubview:self.zanIcon];
        self.zanIcon.sd_layout.rightSpaceToView(self.zanNumLab, 10).centerYEqualToView(self.headerImage).widthIs(15).heightEqualToWidth();
        
        self.titleLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(15) aligent:NSTextAlignmentLeft];
        self.titleLab.numberOfLines = 0;
        [self.contentView addSubview:self.titleLab];
    }
    return self;
}
- (void)setCellIndex:(NSInteger)cellIndex
{
    _cellIndex = cellIndex;
    [self.preImage yy_setImageWithURL:[NSURL URLWithString:[self t_images:cellIndex%10]] placeholder:nil];
    [self.headerImage yy_setImageWithURL:[NSURL URLWithString:@"http://pic32.photophoto.cn/20140819/0008020285038599_b.jpg"] placeholder:nil];
    self.nameLab.text = @"二狗子";
    self.zanNumLab.text = @"1234";
    
    NSString * title = [self t_videotitle:cellIndex%10];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat titleHeight = [title textHeight:FONT(15) width:width - Width(15)*2 lineSpace:7 keming:0];
    if (titleHeight > FONT(15).lineHeight * 3 + 7*3) {
        titleHeight = FONT(15).lineHeight * 3 + 7*3;
    }
    self.titleLab.attributedText = [title attributedStr:FONT(15) textColor:[UIColor whiteColor] lineSpace:7 keming:0];
    self.titleLab.sd_resetLayout.leftSpaceToView(self.contentView, Width(15)).bottomSpaceToView(self.headerImage, 5).rightSpaceToView(self.contentView, Width(15)).heightIs(titleHeight);
}
-(NSString *)t_images:(NSInteger)index
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
-(NSString *)t_videotitle:(NSInteger)index
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
