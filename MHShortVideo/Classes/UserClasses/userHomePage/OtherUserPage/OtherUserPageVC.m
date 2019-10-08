//
//  OtherUserPageVC.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/21.
//  Copyright © 2018 mh. All rights reserved.
//

#import "OtherUserPageVC.h"
#import "UserHeaderView.h"
#import "MHMutipleGeatureScrollView.h"
#import "UserPageContentView.h"

#define kHeaderHeight    Width(390)   //header总高度

@interface OtherUserPageVC ()<UserPageContentDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)MHMutipleGeatureScrollView * contentScrollView;
@property(nonatomic,strong)UserHeaderView * headerView;
@property(nonatomic,strong)UserPageContentView * sliderContentView;
@property(nonatomic,assign)BOOL contentNeedKeep;

@property(nonatomic,strong)UIView * navBGview;//导航栏背景

@end

@implementation OtherUserPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commit_navBar];
    [self commit_subViews];
}
-(void)commit_subViews
{
    _contentNeedKeep = NO;
    _contentScrollView = [[MHMutipleGeatureScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _contentScrollView.delegate = self;
    _contentScrollView.showsVerticalScrollIndicator = NO;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    [_contentScrollView setContentSize:CGSizeMake(self.view.frame.size.width, _contentScrollView.frame.size.height + kHeaderHeight - NavHeight)];
    [self.view addSubview:_contentScrollView];
    
    _headerView = [[UserHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kHeaderHeight)];
    [_contentScrollView addSubview:_headerView];
    
    _sliderContentView = [[UserPageContentView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headerView.frame), self.view.frame.size.width, self.view.frame.size.height - NavHeight) isOtherUser:YES];
    _sliderContentView.delegate = self;
    _sliderContentView.curentNav = self.navigationController;
    [_contentScrollView addSubview:_sliderContentView];
    
    [self.view bringSubviewToFront:self.mhNavBar];
}
-(void)userPageContentIsScroll:(BOOL)isScroll
{
    _contentScrollView.scrollEnabled = !isScroll;
}
-(void)childPageDidScroll:(UIScrollView *)scroll
{
    BOOL needKeep = scroll.contentOffset.y > 0 ? YES : NO;
    if (needKeep) {
        [_contentScrollView setContentOffset:CGPointMake(0,kHeaderHeight-NavHeight)];
    }
    _contentNeedKeep = needKeep;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView != _contentScrollView) {
        return;
    }
    if (!_contentNeedKeep) {
        if (scrollView.contentOffset.y < (kHeaderHeight - NavHeight)) {
            _sliderContentView.listCanScroll = NO;
        }else if (scrollView.contentOffset.y >= (kHeaderHeight - NavHeight)) {
            [scrollView setContentOffset:CGPointMake(0, (kHeaderHeight - NavHeight))];
            _sliderContentView.listCanScroll = YES;
        }
    }else{
        [scrollView setContentOffset:CGPointMake(0, (kHeaderHeight - NavHeight))];
    }
    [_headerView updateHeaderContentOffY:scrollView.contentOffset.y];
    [self updateNavState:scrollView.contentOffset.y];
}
-(void)updateNavState:(CGFloat)offy
{
    if (offy <= 0) {
        offy = 0;
    }
    CGFloat y = (kHeaderHeight - NavHeight) - offy;
    CGFloat alpha = 0.0;
    if (y >= NavHeight) {
        alpha = 0.f;
    }else{
        alpha = (NavHeight - y)/NavHeight;
    }
    self.mh_navTitle.alpha = alpha;
    self.navBGview.alpha = alpha;
}
#pragma mark - 初始化导航栏
-(void)commit_navBar
{
    self.mhNavBar.hidden = NO;
    self.mhNavBar.backgroundColor = [UIColor clearColor];
    
    self.navBGview = [[UIView alloc] initWithFrame:self.mhNavBar.bounds];
    self.navBGview.backgroundColor = [UIColor base_color];
    
    [self.mhNavBar addSubview:self.navBGview];
    
    [self mh_setNeedBackItemWithTitle:@"王二麻子"];
    [self mh_setNavBottomlineHiden:YES];
    
    self.mh_navTitle.alpha = 0.0;
    self.navBGview.alpha = 0.0;
}
-(void)mh_navBackItem_click
{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
