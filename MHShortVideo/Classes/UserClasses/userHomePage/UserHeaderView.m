//
//  UserHeaderView.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/19.
//  Copyright © 2018 mh. All rights reserved.
//

#import "UserHeaderView.h"

@interface UserHeaderView ()

@property(nonatomic,strong)UIImageView * headerBGImage;//顶部背景图片 随拉伸变大
@property(nonatomic,strong)UIImageView * userImage;//用户头像
@property(nonatomic,strong)UILabel * userNameLab;//用户名
@property(nonatomic,strong)UILabel * userNumberLab;//用户号码
@property(nonatomic,strong)UILabel * zanFocusFanceLab;//赞 关注 粉丝 数量lab

@end

@implementation UserHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(41, 38, 38);
        [self commit_subViews];
    }
    return self;
}
-(void)commit_subViews
{
    //顶部背景图片
    self.headerBGImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, Width(120))];
    self.headerBGImage.contentMode = UIViewContentModeScaleAspectFill;
    self.headerBGImage.clipsToBounds = YES;
    self.headerBGImage.image = [UIImage imageNamed:@"user_bg_image.jpg"];
    [self addSubview:self.headerBGImage];
    
    //用户头像
    self.userImage = [[UIImageView alloc] initWithFrame:CGRectMake(Width(10), Width(100), Width(100), Width(100))];
    self.userImage.contentMode = UIViewContentModeScaleAspectFill;
    self.userImage.clipsToBounds = YES;
    self.userImage.layer.cornerRadius = Width(50);
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.borderWidth = 6;
    self.userImage.layer.borderColor = RGB(41, 38, 38).CGColor;
    [self addSubview:self.userImage];
    [self.userImage yy_setImageWithURL:[NSURL URLWithString:@"http://img1.touxiang.cn/uploads/20131119/19-082840_334.jpg"] placeholder:nil];
    
    //用户名字
    self.userNameLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(18) aligent:NSTextAlignmentLeft];
    self.userNameLab.numberOfLines = 1;
    [self addSubview:self.userNameLab];
    self.userNameLab.sd_layout.leftSpaceToView(self, Width(10)).topSpaceToView(self.userImage, 8).rightSpaceToView(self, Width(10)).heightIs(Width(34));
    [self.userNameLab updateLayout];
    self.userNameLab.text = @"陈二狗8855226633";
    
    //用户号码
    self.userNumberLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(13) aligent:NSTextAlignmentLeft];
    self.userNumberLab.numberOfLines = 1;
    [self addSubview:self.userNumberLab];
    self.userNumberLab.sd_layout.leftSpaceToView(self, Width(10)).topSpaceToView(self.userNameLab, 0).rightSpaceToView(self, Width(10)).heightIs(Width(20));
    [self.userNumberLab updateLayout];
    self.userNumberLab.text = @"**号:8855226655";
    
    //分割线
    UIView * sepLine = [[UIView alloc] init];
    sepLine.backgroundColor = [UIColor grayColor];
    [self addSubview:sepLine];
    sepLine.sd_layout.leftSpaceToView(self, Width(10)).topSpaceToView(self.userNumberLab, 6).rightSpaceToView(self, Width(10)).heightIs(0.5);
    [sepLine updateLayout];
    
    //填写表填提示lab
    UILabel * biaoqianTipLab = [UILabel labTextColor:[UIColor grayColor] font:FONT(14) aligent:NSTextAlignmentLeft];
    biaoqianTipLab.text = @"填写个性签名更容易获得别人关注哦";
    biaoqianTipLab.numberOfLines = 1;
    [self addSubview:biaoqianTipLab];
    biaoqianTipLab.sd_layout.leftSpaceToView(self, Width(10)).topSpaceToView(sepLine, 0).rightSpaceToView(self, Width(10)).heightIs(Width(34));
    [biaoqianTipLab updateLayout];
    
    //标签
    UIView * bqContent = [[UIView alloc] init];
    bqContent.backgroundColor = [UIColor clearColor];
    [self addSubview:bqContent];
    bqContent.sd_layout.leftSpaceToView(self, Width(10)).topSpaceToView(biaoqianTipLab, 0).rightSpaceToView(self, Width(10)).heightIs(Width(22));
    [bqContent updateLayout];
    
    NSArray * biaoqianArr = @[@"18岁",@"深圳",@"北京大学",@"+ 增加性别等标签"];
    CGFloat bqMargin = 3;
    CGFloat bqTextMargin = 5;
    CGFloat oriX = 0;
    for (int i = 0; i < biaoqianArr.count; i ++) {
        NSString * title = biaoqianArr[i];
        CGFloat titleWidth = [title textForLabWidthWithTextHeight:20 font:FONT(14)];
        CGFloat btnWidth = titleWidth + bqTextMargin*2;
        if (oriX + btnWidth > bqContent.frame.size.width) {
            break;
        }
        UIButton * btn = [UIButton buttonWithType:0];
        btn.frame = CGRectMake(oriX, 0, btnWidth, bqContent.frame.size.height);
        btn.backgroundColor = RGB(68, 65, 65);
        [btn setTitle:biaoqianArr[i] forState:0];
        [btn setTitleColor:[UIColor grayColor] forState:0];
        btn.titleLabel.font = FONT(14);
        [bqContent addSubview:btn];
        oriX = oriX + btnWidth + bqMargin;
    }
    
    //赞 关注 粉丝数量
    self.zanFocusFanceLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(16) aligent:NSTextAlignmentLeft];
    self.zanFocusFanceLab.numberOfLines = 1;
    [self addSubview:self.zanFocusFanceLab];
    self.zanFocusFanceLab.sd_layout.leftSpaceToView(self, Width(10)).topSpaceToView(bqContent, Width(10)).rightSpaceToView(self, Width(10)).heightIs(Width(30));
    self.zanFocusFanceLab.text = @"100获赞  200关注  300粉丝";
}
-(void)updateHeaderContentOffY:(CGFloat)offY
{
    if (offY < 0) {
        CGRect imgRect = self.headerBGImage.frame;
        imgRect.origin.y = offY;
        imgRect.size.height = Width(120) - offY;
        self.headerBGImage.frame = imgRect;
    }else{
        self.headerBGImage.frame = CGRectMake(0, 0, self.frame.size.width, Width(120));
    }
}
@end
