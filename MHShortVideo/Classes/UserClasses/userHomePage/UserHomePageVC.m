//
//  UserHomePageVC.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/30.
//  Copyright © 2018 mh. All rights reserved.
//

#import "UserHomePageVC.h"
#import "UserHeaderView.h"
#import "MHMutipleGeatureScrollView.h"
#import "UserPageContentView.h"

#import "UIViewController+CWLateralSlide.h"
#import "UserRightVC.h"

#define kHeaderHeight    Width(390)   //header总高度

@interface UserHomePageVC ()<UserPageContentDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)MHMutipleGeatureScrollView * contentScrollView;
@property(nonatomic,strong)UserHeaderView * headerView;
@property(nonatomic,strong)UserPageContentView * sliderContentView;
@property(nonatomic,assign)BOOL contentNeedKeep;

@property(nonatomic,strong)UIView * navBGview;//导航栏背景

@property(nonatomic,strong)UserRightVC * rightVC; //右侧抽屉 强引用，可以避免每次显示都去创建

@end

@implementation UserHomePageVC
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self commit_navBar];
    [self commit_subViews];
    
    // 注册手势驱动
    __weak typeof(self)weakSelf = self;
    [self cw_registerShowIntractiveWithEdgeGesture:NO transitionDirectionAutoBlock:^(CWDrawerTransitionDirection direction) {
        if (direction == CWDrawerTransitionFromRight) {
            // 右侧滑出
            [weakSelf maskAnimationFromRight];
        }
    }];
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
    
    _sliderContentView = [[UserPageContentView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headerView.frame), self.view.frame.size.width, self.view.frame.size.height - NavHeight) isOtherUser:NO];
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
    
    [self mh_setTitle:@"二狗子"];
    [self mh_setNavBottomlineHiden:YES];
    
    self.mh_navTitle.alpha = 0.0;
    self.navBGview.alpha = 0.0;
}
#pragma mark - 右滑页面出现
-(void)maskAnimationFromRight
{
    CWLateralSlideConfiguration *conf = [CWLateralSlideConfiguration defaultConfiguration];
    conf.direction = CWDrawerTransitionFromRight; // 从右边滑出
    conf.finishPercent = 0.6f;
    conf.showAnimDuration = 0.2;
    conf.HiddenAnimDuration = 0.2;
    conf.maskAlpha = 0.1;
    conf.distance = Screen_WIDTH/3*2;
    
    [self cw_showDrawerViewController:self.rightVC animationType:CWDrawerAnimationTypeDefault configuration:conf];
}
-(UserRightVC *)rightVC
{
    if (!_rightVC) {
        _rightVC = [[UserRightVC alloc] init];
    }
    return _rightVC;
}
@end
