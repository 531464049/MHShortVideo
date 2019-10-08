//
//  HomePageVC.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/30.
//  Copyright © 2018 mh. All rights reserved.
//

#import "HomePageVC.h"
#import "HomeContentView.h"
#import "HomeCityPage.h"
#import "HomeTopBar.h"
#import "ScanVC.h"
#import "SearchPageVC.h"
#import "OtherUserPageVC.h"

#import "BaseNavController.h"
#import "UIViewController+CWLateralSlide.h"

@interface HomePageVC ()<HomeTopBarDelegate>

@property(nonatomic,strong)HomeContentView * contentView;//推荐页面
@property(nonatomic,assign)BOOL notFirstTime;//判断不是第一次进入页面（初始化）
@property(nonatomic,strong)HomeCityPage * cityPage;//城市页面

@property(nonatomic,strong)HomeTopBar * topBar;

@property(nonatomic,assign)BOOL isNowTuiJianpage;//是否当前显示推荐页面

@end

@implementation HomePageVC
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    DLog(@"首页-消失-停止播放");

    [self.contentView pageStopPlay];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    if (!self.notFirstTime) {
        self.notFirstTime = YES;
        return;
    }
    DLog(@"首页-展示-开始播放");
    if (self.isNowTuiJianpage && [self.contentView isDisplayedInScreen]) {
        [self.contentView pageStartPlay];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor base_color];
    self.isNowTuiJianpage = YES;
    [self commit_contentView];
    [self commit_topBar];
    
    // 注册手势驱动
    __weak typeof(self)weakSelf = self;
    [self cw_registerShowIntractiveWithEdgeGesture:NO transitionDirectionAutoBlock:^(CWDrawerTransitionDirection direction) {
        if (direction == CWDrawerTransitionFromRight) {
            // 右侧滑出
            [weakSelf maskAnimationFromRight];
        }else{
            // 左侧滑出
            [weakSelf maskAnimationFromLeft];
        }
    }];
}
#pragma mark - 初始化主容器
-(void)commit_contentView
{
    self.contentView = [[HomeContentView alloc] initWithFrame:self.view.bounds];
    self.contentView.curentNav = self.navigationController;
    [self.view addSubview:self.contentView];
}
#pragma mark - 初始化顶部bar
-(void)commit_topBar
{
    self.topBar = [[HomeTopBar alloc] initWithFrame:CGRectMake(0, K_StatusHeight, self.view.frame.size.width, Width(44))];
    self.topBar.delegate = self;
    [self.view addSubview:self.topBar];
}
#pragma mark - 推荐/城市切换
-(void)homeTopBarChangeTo:(BOOL)isTuiJIan
{
    if (self.isNowTuiJianpage == isTuiJIan) {
        return;
    }
    self.isNowTuiJianpage = isTuiJIan;
    if (isTuiJIan) {
        self.cityPage.hidden = YES;
        self.contentView.hidden = NO;
        [self.contentView pageStartPlay];
    }else{
        self.cityPage.hidden = NO;
        self.contentView.hidden = YES;
        [self.contentView pageStopPlay];
    }
    [self.view bringSubviewToFront:self.topBar];
}
#pragma mark - 搜索
-(void)homeTopBarSearchItemHandle
{
    [self maskAnimationFromLeft];
}
#pragma mark - 二维码
-(void)homeTopBarScanItemHandle
{
    ScanVC * vc = [[ScanVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (HomeCityPage *)cityPage
{
    if (!_cityPage) {
        _cityPage = [[HomeCityPage alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_cityPage];
    }
    return _cityPage;
}
#pragma mark - 右滑页面出现
-(void)maskAnimationFromRight
{
    OtherUserPageVC * vc = [[OtherUserPageVC alloc] init];
    BaseNavController * nvc = [[BaseNavController alloc] initWithRootViewController:vc];
    nvc.navigationBar.tintColor = [UIColor whiteColor];
    nvc.navigationBar.translucent = NO;
    nvc.navigationBarHidden = YES;
    
    CWLateralSlideConfiguration *conf = [CWLateralSlideConfiguration defaultConfiguration];
    conf.direction = CWDrawerTransitionFromRight; // 从左边滑出
    conf.finishPercent = 0.5f;
    conf.showAnimDuration = 0.2;
    conf.HiddenAnimDuration = 0.2;
    conf.maskAlpha = 0.1;
    conf.distance = Screen_WIDTH;
    
    [self cw_showDrawerViewController:nvc animationType:CWDrawerAnimationTypeDefault configuration:conf];
}
#pragma mark - 左滑页面出现
-(void)maskAnimationFromLeft
{
    SearchPageVC * vc = [[SearchPageVC alloc] init];
    BaseNavController * nvc = [[BaseNavController alloc] initWithRootViewController:vc];
    nvc.navigationBar.tintColor = [UIColor whiteColor];
    nvc.navigationBar.translucent = NO;
    nvc.navigationBarHidden = YES;
    
    CWLateralSlideConfiguration *conf = [CWLateralSlideConfiguration defaultConfiguration];
    conf.direction = CWDrawerTransitionFromLeft; // 从左边滑出
    conf.finishPercent = 0.5f;
    conf.showAnimDuration = 0.2;
    conf.HiddenAnimDuration = 0.2;
    conf.maskAlpha = 0.1;
    conf.distance = Screen_WIDTH;
    
    [self cw_showDrawerViewController:nvc animationType:CWDrawerAnimationTypeDefault configuration:conf];
}
@end
