//
//  PostWhoCanSeeView.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/30.
//  Copyright © 2018 mh. All rights reserved.
//

#import "PostWhoCanSeeView.h"

@interface PostWhoCanSeeView ()

@property(nonatomic,strong)UILabel * rightlab;

@end

@implementation PostWhoCanSeeView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commit_subviews];
    }
    return self;
}
-(void)commit_subviews
{
    UIImageView * icon = [[UIImageView alloc] init];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    icon.clipsToBounds = YES;
    icon.image = [UIImage imageNamed:@"location"];
    [self addSubview:icon];
    icon.sd_layout.leftSpaceToView(self, Width(10)).topSpaceToView(self,Width(15)).widthIs(Width(20)).heightEqualToWidth();
    
    UILabel * titleLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(15) aligent:NSTextAlignmentLeft];
    titleLab.text = @"谁可以看";
    [self addSubview:titleLab];
    titleLab.sd_layout.leftSpaceToView(icon, Width(10)).centerYEqualToView(icon).heightIs(Width(20)).widthIs(200);
    
    UIImageView * rightIcon = [[UIImageView alloc] init];
    rightIcon.image = [UIImage imageNamed:@"common_next"];
    [self addSubview:rightIcon];
    rightIcon.sd_layout.rightSpaceToView(self,0).centerYEqualToView(icon).widthIs(Width(40)).heightEqualToWidth();
    
    self.rightlab = [UILabel labTextColor:[UIColor grayColor] font:FONT(14) aligent:NSTextAlignmentRight];
    self.rightlab.text = @"公开";
    [self addSubview:self.rightlab];
    self.rightlab.sd_layout.rightSpaceToView(rightIcon, Width(10)).centerYEqualToView(icon).widthIs(180).heightIs(20);
    
    UIButton * moreBtn = [UIButton buttonWithType:0];
    [moreBtn addTarget:self action:@selector(more_itemClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:moreBtn];
    moreBtn.sd_layout.rightSpaceToView(self,0).centerYEqualToView(icon).widthIs(Width(180)).heightEqualToWidth();
}
-(void)updateOpenType:(MHPostVideoOpenType)openType
{
    NSString * str = @"公开";
    if (openType == MHPostVideoOpenTypeOnlyFriend) {
        str = @"仅朋友可见";
    }else if (openType == MHPostVideoOpenTypeUnOpen) {
        str = @"不公开";
    }
    self.rightlab.text = str;
}
-(void)more_itemClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(whoCanSeeJumpToChoose)]) {
        [self.delegate whoCanSeeJumpToChoose];
    }
}
@end
