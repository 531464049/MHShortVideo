//
//  UserPageContentView.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/19.
//  Copyright © 2018 mh. All rights reserved.
//

#import "UserPageContentView.h"
#import "UserDynamicPage.h"
#import "UserLikedPage.h"
#import "UserProductionPage.h"
#import "MHTitleSliderBar.h"
#import "MHMultipleGestureHeader.h"

#define sliderBarHeight    Width(40)   //分栏高度

@interface UserPageContentView ()<UIScrollViewDelegate,ChildScrollViewDidScrollDelegate,MHTitleSliderBarDelegate>

@property(nonatomic,strong)MHTitleSliderBar * sliderBar;
@property(nonatomic,strong)UIScrollView * contentScroll;
@property(nonatomic,copy)NSArray * listVCArr;
@property(nonatomic,assign)NSInteger curentSeleIndex;

@property(nonatomic,assign)BOOL isOtherUser;//是否是其他用户的主页

@end

@implementation UserPageContentView

-(instancetype)initWithFrame:(CGRect)frame isOtherUser:(BOOL)isOtherUser
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isOtherUser = isOtherUser;
        [self commit_content];
    }
    return self;
}
-(void)setCurentNav:(UINavigationController *)curentNav
{
    [super setCurentNav:curentNav];
    if (self.listVCArr.count > 0) {
        UserProductionPage * vc1 = (UserProductionPage *)self.listVCArr[0];
        vc1.curentNav = self.curentNav;
        UserDynamicPage * vc2 = (UserDynamicPage *)self.listVCArr[1];
        vc2.curentNav = self.curentNav;
        UserLikedPage * vc3 = (UserLikedPage *)self.listVCArr[2];
        vc3.curentNav = self.curentNav;
    }
}
-(void)commit_content
{
    _sliderBar = [[MHTitleSliderBar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, sliderBarHeight) titleArr:@[@"作品",@"动态",@"喜欢"]];
    _sliderBar.delegate = self;
    [self addSubview:_sliderBar];
    
    _contentScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, sliderBarHeight, self.frame.size.width, self.frame.size.height - sliderBarHeight)];
    _contentScroll.delegate = self;
    _contentScroll.showsVerticalScrollIndicator = NO;
    _contentScroll.showsHorizontalScrollIndicator = NO;
    _contentScroll.pagingEnabled = YES;
    _contentScroll.contentSize = CGSizeMake(_contentScroll.frame.size.width*3, _contentScroll.frame.size.height);
    [self addSubview:_contentScroll];
    
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    
    UserProductionPage * vc1 = [[UserProductionPage alloc] init];
    vc1.canScroll = NO;
    vc1.delegate = self;
    vc1.isOtherUser = self.isOtherUser;
    vc1.view.frame = CGRectMake(_contentScroll.frame.size.width*0, 0, _contentScroll.frame.size.width, _contentScroll.frame.size.height);;
    [_contentScroll addSubview:vc1.view];
    [arr addObject:vc1];
    
    UserDynamicPage * vc2 = [[UserDynamicPage alloc] init];
    vc2.canScroll = NO;
    vc2.delegate = self;
    vc2.isOtherUser = self.isOtherUser;
    vc2.view.frame = CGRectMake(_contentScroll.frame.size.width*1, 0, _contentScroll.frame.size.width, _contentScroll.frame.size.height);;
    [_contentScroll addSubview:vc2.view];
    [arr addObject:vc2];
    
    UserLikedPage * vc3 = [[UserLikedPage alloc] init];
    vc3.canScroll = NO;
    vc3.delegate = self;
    vc3.isOtherUser = self.isOtherUser;
    vc3.view.frame = CGRectMake(_contentScroll.frame.size.width*2, 0, _contentScroll.frame.size.width, _contentScroll.frame.size.height);;
    [_contentScroll addSubview:vc3.view];
    [arr addObject:vc3];
    
    self.listVCArr = [NSArray arrayWithArray:arr];
    _curentSeleIndex = 0;

    UserProductionPage * curentVC = (UserProductionPage *)self.listVCArr[0];
    [curentVC curentViewDidLoad];
}
- (void)setListCanScroll:(BOOL)listCanScroll
{
    _listCanScroll = listCanScroll;
    
    UserProductionPage * vc1 = (UserProductionPage *)self.listVCArr[0];
    vc1.canScroll = listCanScroll;
    UserDynamicPage * vc2 = (UserDynamicPage *)self.listVCArr[1];
    vc2.canScroll = listCanScroll;
    UserLikedPage * vc3 = (UserLikedPage *)self.listVCArr[2];
    vc3.canScroll = listCanScroll;
}
-(void)childScrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(childPageDidScroll:)]) {
        [self.delegate childPageDidScroll:scrollView];
    }
}
- (void)titleSliderBar:(MHTitleSliderBar *)bar selected:(NSInteger)index
{
    [_contentScroll setContentOffset:CGPointMake(Screen_WIDTH * index, 0) animated:NO];
    [self.listVCArr[index] curentViewDidLoad];
    if (self.delegate && [self.delegate respondsToSelector:@selector(userPageContentIsScroll:)]) {
        [self.delegate userPageContentIsScroll:NO];
    }
    _curentSeleIndex = index;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scrFl = (NSInteger)scrollView.contentOffset.x/Screen_WIDTH;
    [self.sliderBar titleSliderBarScrollBottomLine:scrFl];
    if (self.delegate && [self.delegate respondsToSelector:@selector(userPageContentIsScroll:)]) {
        [self.delegate userPageContentIsScroll:YES];
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(userPageContentIsScroll:)]) {
        [self.delegate userPageContentIsScroll:NO];
    }
    NSInteger tag = (NSInteger)scrollView.contentOffset.x/Screen_WIDTH;
    if (tag == _curentSeleIndex) {
        return;
    }
    [self.sliderBar titleSliderBarOutSideScrollEnd:tag];
}
@end
