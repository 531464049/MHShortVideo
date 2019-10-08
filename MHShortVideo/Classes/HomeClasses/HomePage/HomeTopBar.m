//
//  HomeTopBar.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/7.
//  Copyright © 2018 mh. All rights reserved.
//

#import "HomeTopBar.h"

@interface HomeTopBar ()

@property(nonatomic,strong)UIButton * tuijianBtn;
@property(nonatomic,strong)UIButton * locationBtn;

@property(nonatomic,assign)BOOL isTuiJianPage;//是否显示的是推荐页面

@end

@implementation HomeTopBar

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isTuiJianPage = YES;
        [self commit_subViews];
    }
    return self;
}
-(void)commit_subViews
{
    UIButton * searchItem = [UIButton buttonWithType:0];
    searchItem.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
    [searchItem setImage:[UIImage imageNamed:@"search_gray"] forState:0];
    [searchItem addTarget:self action:@selector(searchItemClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:searchItem];
    
    UIView * centerline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, Width(10))];
    centerline.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    centerline.backgroundColor = [UIColor grayColor];
    [self addSubview:centerline];
    
    self.tuijianBtn = [UIButton buttonWithType:0];
    [self.tuijianBtn setTitle:@"推荐" forState:0];
    [self.tuijianBtn setTitleColor:[UIColor whiteColor] forState:0];
    self.tuijianBtn.titleLabel.font = FONT(18);
    [self.tuijianBtn addTarget:self action:@selector(tuijianItemCLick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.tuijianBtn];
    self.tuijianBtn.sd_layout.rightSpaceToView(centerline, 0).topEqualToView(self).bottomEqualToView(self).widthIs(Width(60));
    
    self.locationBtn = [UIButton buttonWithType:0];
    [self.locationBtn setTitle:@"深圳" forState:0];
    [self.locationBtn setTitleColor:[UIColor whiteColor] forState:0];
    self.locationBtn.titleLabel.font = FONT(18);
    [self.locationBtn addTarget:self action:@selector(locationItemCLick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.locationBtn];
    
    [self updateLocationItemWidth];
    [self updateItemState];
    
    UIButton * scanBtn = [UIButton buttonWithType:0];
    scanBtn.frame = CGRectMake(self.frame.size.width - self.frame.size.height, 0, self.frame.size.height, self.frame.size.height);
    [scanBtn setImage:[UIImage imageNamed:@"search_gray"] forState:0];
    [scanBtn addTarget:self action:@selector(scanItemClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:scanBtn];
}
-(void)updateLocationItemWidth
{
    NSString * city = AppInfo.sharedInstance.userCity;
    if ([city hasSuffix:@"市"]) {
        city = [city substringWithRange:NSMakeRange(0, city.length - 1)];
    }
    [self.locationBtn setTitle:city forState:0];
    CGFloat titleWidth = [city textForLabWidthWithTextHeight:50 font:FONT(18)];
    self.locationBtn.frame = CGRectMake(self.frame.size.width/2, 0, titleWidth + Width(15)*2, self.frame.size.height);
}
-(void)updateItemState
{
    if (self.isTuiJianPage) {
        [self.tuijianBtn setTitleColor:[UIColor whiteColor] forState:0];
        self.tuijianBtn.titleLabel.font = FONT(18);
        [self.locationBtn setTitleColor:[UIColor grayColor] forState:0];
        self.locationBtn.titleLabel.font = FONT(16);
    }else{
        [self.tuijianBtn setTitleColor:[UIColor grayColor] forState:0];
        self.tuijianBtn.titleLabel.font = FONT(16);
        [self.locationBtn setTitleColor:[UIColor whiteColor] forState:0];
        self.locationBtn.titleLabel.font = FONT(18);
    }
}
#pragma mark - 推荐
-(void)tuijianItemCLick
{
    if (self.isTuiJianPage) {
        return;
    }
    
    self.isTuiJianPage = YES;
    [self updateItemState];
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeTopBarChangeTo:)]) {
        [self.delegate homeTopBarChangeTo:YES];
    }
}
#pragma mark - 城市
-(void)locationItemCLick
{
    if (!self.isTuiJianPage) {
        return;
    }
    
    self.isTuiJianPage = NO;
    [self updateItemState];
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeTopBarChangeTo:)]) {
        [self.delegate homeTopBarChangeTo:NO];
    }
}
#pragma mark - 二维码扫描
-(void)searchItemClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeTopBarSearchItemHandle)]) {
        [self.delegate homeTopBarSearchItemHandle];
    }
}
#pragma mark - 二维码扫描
-(void)scanItemClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeTopBarScanItemHandle)]) {
        [self.delegate homeTopBarScanItemHandle];
    }
}
@end
