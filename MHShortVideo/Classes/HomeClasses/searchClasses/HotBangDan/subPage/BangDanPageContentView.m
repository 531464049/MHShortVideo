//
//  BangDanPageContentView.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/11.
//  Copyright © 2018 mh. All rights reserved.
//

#import "BangDanPageContentView.h"
#import "BangDanListPageVC.h"
#import "MHTitleSliderBar.h"

@interface BangDanPageContentView ()<UIScrollViewDelegate,BangDanListPageDelegate,MHTitleSliderBarDelegate>

@property(nonatomic,strong)MHTitleSliderBar * sliderBar;
@property(nonatomic,strong)UIScrollView * contentScroll;
@property(nonatomic,copy)NSArray * listVCArr;
@property(nonatomic,assign)NSInteger curentSeleIndex;

@end

@implementation BangDanPageContentView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commit_content];
    }
    return self;
}
-(void)commit_content
{
    _sliderBar = [[MHTitleSliderBar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, Width(50)) titleArr:@[@"热搜榜",@"视频榜",@"正能量"]];
    _sliderBar.delegate = self;
    [self addSubview:_sliderBar];
    
    _contentScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, Width(50), self.frame.size.width, self.frame.size.height - Width(50))];
    _contentScroll.delegate = self;
    _contentScroll.showsVerticalScrollIndicator = NO;
    _contentScroll.showsHorizontalScrollIndicator = NO;
    _contentScroll.pagingEnabled = YES;
    _contentScroll.contentSize = CGSizeMake(_contentScroll.frame.size.width*3, _contentScroll.frame.size.height);
    [self addSubview:_contentScroll];

    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 3; i ++) {
        BangDanListPageVC * pageVC = [[BangDanListPageVC alloc] init];
        pageVC.canScroll = NO;
        pageVC.delegate = self;
        
        if (i == 0) {
            pageVC.listType = BanDanListTypeHotSearch;
        }else if (i == 1) {
            pageVC.listType = BanDanListTypeVideo;
        }else{
            pageVC.listType = BanDanListTypeZhengPower;
        }
        
        pageVC.view.frame = CGRectMake(_contentScroll.frame.size.width*i, 0, _contentScroll.frame.size.width, _contentScroll.frame.size.height);
        [_contentScroll addSubview:pageVC.view];
        [arr addObject:pageVC];
    }
    self.listVCArr = [NSArray arrayWithArray:arr];
    _curentSeleIndex = 0;
    
    BangDanListPageVC * curentVC = (BangDanListPageVC *)self.listVCArr[_curentSeleIndex];
    [curentVC curentViewDidLoad];
}
- (void)setListCanScroll:(BOOL)listCanScroll
{
    _listCanScroll = listCanScroll;
    for (int i = 0; i < self.listVCArr.count; i ++) {
        BangDanListPageVC * pageVC = (BangDanListPageVC *)self.listVCArr[i];
        pageVC.canScroll = listCanScroll;
    }
}
- (void)BangDanListPageDidScroll:(UIScrollView *)scrollView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(childPageDidScroll:)]) {
        [self.delegate childPageDidScroll:scrollView];
    }
}
- (void)titleSliderBar:(MHTitleSliderBar *)bar selected:(NSInteger)index
{
    [_contentScroll setContentOffset:CGPointMake(Screen_WIDTH * index, 0) animated:NO];
    [self.listVCArr[index] curentViewDidLoad];
    if (self.delegate && [self.delegate respondsToSelector:@selector(bangDanPageContentIsScroll:)]) {
        [self.delegate bangDanPageContentIsScroll:NO];
    }
    _curentSeleIndex = index;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scrFl = (NSInteger)scrollView.contentOffset.x/Screen_WIDTH;
    [self.sliderBar titleSliderBarScrollBottomLine:scrFl];
    if (self.delegate && [self.delegate respondsToSelector:@selector(bangDanPageContentIsScroll:)]) {
        [self.delegate bangDanPageContentIsScroll:YES];
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bangDanPageContentIsScroll:)]) {
        [self.delegate bangDanPageContentIsScroll:NO];
    }
    NSInteger tag = (NSInteger)scrollView.contentOffset.x/Screen_WIDTH;
    if (tag == _curentSeleIndex) {
        return;
    }
    [self.sliderBar titleSliderBarOutSideScrollEnd:tag];
}
@end
