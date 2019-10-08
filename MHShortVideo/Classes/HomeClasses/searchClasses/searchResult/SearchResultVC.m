//
//  SearchResultVC.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/11.
//  Copyright © 2018 mh. All rights reserved.
//

#import "SearchResultVC.h"
#import "SearchTopBar.h"
#import "MHTitleSliderBar.h"
#import "SearchResultListVC.h"
#import "HotBangDanContentVC.h"

@interface SearchResultVC ()<SearchTopBarDelegate,MHTitleSliderBarDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)SearchTopBar * searchTopBar;//搜索框
@property(nonatomic,strong)MHTitleSliderBar * sliderBar;
@property(nonatomic,strong)UIScrollView * contentScroll;
@property(nonatomic,copy)NSArray * listVCArr;
@property(nonatomic,assign)NSInteger curentSeleIndex;
@end

@implementation SearchResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commit_navbar];
    [self commit_UIUI];
}
#pragma mark - 初始化界面
-(void)commit_UIUI
{
    _sliderBar = [[MHTitleSliderBar alloc] initWithFrame:CGRectMake(0, NavHeight, self.view.frame.size.width, Width(50)) titleArr:@[@"综合",@"视频",@"用户",@"音乐",@"话题",@"位置"]];
    _sliderBar.delegate = self;
    [self.view addSubview:_sliderBar];
    
    _contentScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavHeight + Width(50), self.view.frame.size.width, self.view.frame.size.height - (NavHeight + Width(50)))];
    _contentScroll.delegate = self;
    _contentScroll.showsVerticalScrollIndicator = NO;
    _contentScroll.showsHorizontalScrollIndicator = NO;
    _contentScroll.pagingEnabled = YES;
    _contentScroll.contentSize = CGSizeMake(_contentScroll.frame.size.width*6, _contentScroll.frame.size.height);
    [self.view addSubview:_contentScroll];
    
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    NSArray * vcNameArr = @[@"SRCompositeListVC",@"SRVideoListVC",@"SRUserListVC",@"SRMusicListVC",@"SRTopicListVC",@"SRLocationListVC"];
    for (int i = 0; i < vcNameArr.count; i ++) {
        SearchResultListVC * vc = [NSClassFromString(vcNameArr[i]) new];
        vc.view.frame = CGRectMake(_contentScroll.frame.size.width*i, 0, _contentScroll.frame.size.width, _contentScroll.frame.size.height);
        [_contentScroll addSubview:vc.view];
        [arr addObject:vc];
    }
    self.listVCArr = [NSArray arrayWithArray:arr];
    _curentSeleIndex = 0;
    
    SearchResultListVC * curentVC = (SearchResultListVC *)self.listVCArr[_curentSeleIndex];
    [curentVC curentViewDidLoad];
}
- (void)titleSliderBar:(MHTitleSliderBar *)bar selected:(NSInteger)index
{
    [_contentScroll setContentOffset:CGPointMake(Screen_WIDTH * index, 0) animated:NO];
    [self.listVCArr[index] curentViewDidLoad];
    _curentSeleIndex = index;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scrFl = (NSInteger)scrollView.contentOffset.x/Screen_WIDTH;
    [self.sliderBar titleSliderBarScrollBottomLine:scrFl];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger tag = (NSInteger)scrollView.contentOffset.x/Screen_WIDTH;
    if (tag == _curentSeleIndex) {
        return;
    }
    [self.sliderBar titleSliderBarOutSideScrollEnd:tag];
}
#pragma mark - 导航栏 返回
-(void)searchTopBarQuitHandle;
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)searchTopBarSearchForKey:(NSString *)searchKey
{
    
}
- (void)searchTopBarHandleCheckHotBD
{
    HotBangDanContentVC * vc = [[HotBangDanContentVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 初始化导航栏
-(void)commit_navbar
{
    self.mhNavBar.hidden = YES;
    
    self.searchTopBar = [[SearchTopBar alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH, NavHeight)];
    self.searchTopBar.delegate = self;
    self.searchTopBar.quitLeft = YES;
    [self.view addSubview:self.searchTopBar];
}

@end
