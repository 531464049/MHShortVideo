//
//  HotBangDanContentVC.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/11.
//  Copyright © 2018 mh. All rights reserved.
//

#import "HotBangDanContentVC.h"
#import "BangDanHeaderView.h"
#import "MHMutipleGeatureScrollView.h"
#import "BangDanPageContentView.h"

@interface HotBangDanContentVC ()<BangDanPageContentDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)MHMutipleGeatureScrollView * contentScrollView;
@property(nonatomic,strong)BangDanHeaderView * headerView;
@property(nonatomic,strong)BangDanPageContentView * sliderContentView;
@property(nonatomic,assign)BOOL contentNeedKeep;


@property(nonatomic,strong)UIView * navBGview;//导航栏背景
@end

@implementation HotBangDanContentVC

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
    [_contentScrollView setContentSize:CGSizeMake(self.view.frame.size.width, _contentScrollView.frame.size.height + Width(160) - NavHeight)];
    [self.view addSubview:_contentScrollView];
    
    _headerView = [[BangDanHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, Width(160))];
    [_contentScrollView addSubview:_headerView];
    
    _sliderContentView = [[BangDanPageContentView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headerView.frame), self.view.frame.size.width, self.view.frame.size.height - NavHeight)];
    _sliderContentView.delegate = self;
    [_contentScrollView addSubview:_sliderContentView];
    
    [self.view bringSubviewToFront:self.mhNavBar];
}
-(void)bangDanPageContentIsScroll:(BOOL)isScroll
{
    _contentScrollView.scrollEnabled = !isScroll;
}
-(void)childPageDidScroll:(UIScrollView *)scroll
{
    BOOL needKeep = scroll.contentOffset.y > 0 ? YES : NO;
    if (needKeep) {
        [_contentScrollView setContentOffset:CGPointMake(0,Width(160)-NavHeight)];
    }
    _contentNeedKeep = needKeep;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView != _contentScrollView) {
        return;
    }
    if (!_contentNeedKeep) {
        if (scrollView.contentOffset.y < (Width(160) - NavHeight)) {
            _sliderContentView.listCanScroll = NO;
        }else if (scrollView.contentOffset.y >= (Width(160) - NavHeight)) {
            [scrollView setContentOffset:CGPointMake(0, (Width(160) - NavHeight))];
            _sliderContentView.listCanScroll = YES;
        }
    }else{
        [scrollView setContentOffset:CGPointMake(0, (Width(160) - NavHeight))];
    }
    [_headerView updateHeaderContentOffY:scrollView.contentOffset.y];
    [self updateNavState:scrollView.contentOffset.y];
}
-(void)updateNavState:(CGFloat)offy
{
    if (offy <= 0) {
        offy = 0;
    }
    if (offy >= NavHeight) {
        offy = NavHeight;
    }
    CGFloat alpha = offy / NavHeight;
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
    
    [self mh_setNeedBackItemWithTitle:@"热搜"];
    [self mh_setNavBottomlineHiden:YES];
    
    self.mh_navTitle.alpha = 0.0;
    self.navBGview.alpha = 0.0;
}
@end
