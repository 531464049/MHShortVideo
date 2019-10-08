//
//  HomeContentView.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/3.
//  Copyright © 2018 mh. All rights reserved.
//

#import "HomeContentView.h"
#import "VideoPageView.h"
#import "HomeVideoModel.h"

@interface HomeContentView ()<UIScrollViewDelegate,VideoPageDelegate>

@property(nonatomic,strong)NSMutableArray * dataArr;
@property(nonatomic,strong)UIScrollView * contentScrollView;

@property(nonatomic,assign)CGFloat lastVideoOffy;//上一个偏移量
@property(nonatomic,assign)NSInteger videoIndex;//当前播放视频下标
@property(nonatomic,strong)NSArray * videoPageArr;//保存三个视频page
@property(nonatomic,strong)VideoPageView * curentPage;//当前显示page

@end

@implementation HomeContentView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self commit_contentScroll];
        [self firstTimeRequest];
    }
    return self;
}
-(void)setCurentNav:(UINavigationController *)curentNav
{
    [super setCurentNav:curentNav];
    for (int i = 0; i < self.videoPageArr.count; i ++) {
        VideoPageView * page = (VideoPageView *)self.videoPageArr[i];
        page.curentNav = self.curentNav;
    }
}
#pragma mark - 初始化主容器
-(void)commit_contentScroll
{
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.contentScrollView.backgroundColor = [UIColor clearColor];
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.delegate = self;
    self.contentScrollView.bounces = NO;
    [self addSubview:self.contentScrollView];
    [self.contentScrollView setContentSize:CGSizeMake(self.frame.size.width, self.frame.size.height*3)];
    self.contentScrollView.pagingEnabled = YES;
}
#pragma mark - 首页进入=开始播放
-(void)pageStartPlay
{
    [self.curentPage startPlay];
}
#pragma mark - 首页消失-停止播放
-(void)pageStopPlay
{
    [self.curentPage stopPlay];
}
#pragma mark - 初始化三个videopage
-(void)buildThreeVideoPage
{
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 3; i ++) {
        VideoPageView * page = [[VideoPageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height * i, self.frame.size.width, self.frame.size.height)];
        page.delegate = self;
        page.curentNav = self.curentNav;
        [self.contentScrollView addSubview:page];
        [arr addObject:page];
    }
    self.videoPageArr = [NSArray arrayWithArray:arr];
}
#pragma mark - 更新三个页面
-(void)updateVideoPage
{
    VideoPageView * page0 = (VideoPageView *)self.videoPageArr[0];
    VideoPageView * page1 = (VideoPageView *)self.videoPageArr[1];
    VideoPageView * page2 = (VideoPageView *)self.videoPageArr[2];
    
    [[HomeVideoPlayer sharedPlayer] clearAllPlayInfo];
    
    if (self.videoIndex == 0) {
        //按正常顺序排列三个页面，scrolloffy=0 第一个页面播放
        page0.videoModel = self.dataArr[self.videoIndex];
        page1.videoModel = self.dataArr[self.videoIndex + 1];
        page2.videoModel = self.dataArr[self.videoIndex + 2];
        
        [self.contentScrollView setContentOffset:CGPointMake(0, 0)];
        self.lastVideoOffy = 0.f;
        [page0 autoStartPlay];
        self.curentPage = page0;
    }else if (self.videoIndex == self.dataArr.count-1) {
        //最后一个
        page0.videoModel = self.dataArr[self.videoIndex-2];
        page1.videoModel = self.dataArr[self.videoIndex-1];
        page2.videoModel = self.dataArr[self.videoIndex];
        
        [self.contentScrollView setContentOffset:CGPointMake(0, self.frame.size.height * 2)];
        self.lastVideoOffy = self.frame.size.height * 2;
        [page2 autoStartPlay];
        self.curentPage = page2;
    }else{
        page0.videoModel = self.dataArr[self.videoIndex-1];
        page1.videoModel = self.dataArr[self.videoIndex];
        page2.videoModel = self.dataArr[self.videoIndex+1];
        
        [self.contentScrollView setContentOffset:CGPointMake(0, self.frame.size.height)];
        self.lastVideoOffy = self.frame.size.height;
        [page1 autoStartPlay];
        self.curentPage = page1;
    }
}
#pragma mark - videopage视频播放结束
-(void)videoPagePlayToEndHandle
{
    if (self.videoIndex == self.dataArr.count-1) {
        //已经是最后一个了，没办法再播放下一个 请求数据
        return;
    }
    
    CGFloat offY = self.contentScrollView.contentOffset.y + self.frame.size.height;
    if (offY >= self.frame.size.height * 2) {
        offY = self.frame.size.height * 2;
    }
    [self.contentScrollView setContentOffset:CGPointMake(0, offY) animated:YES];
}
#pragma mark - 第一次请求数据 获取三个数据
-(void)firstTimeRequest
{
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    self.videoIndex = 0;
    self.lastVideoOffy = 0.f;
    //先获取三个视频地址
    for (int i = 0; i < 10; i ++) {
        HomeVideoModel * model = [HomeVideoModel new];
        model.videoUrl = [MHVideoTool test_getAVideoUrl:i];
        model.videoPreImage = [MHVideoTool t_videoPreImage:i];
        model.videoTitle = [HomeVideoModel t_videotitle:i];
        model.userName = @"二狗";
        model.isLiked = i/2==0;
        model.userImage = @"http://pic32.photophoto.cn/20140819/0008020285038599_b.jpg";
        
        int x = arc4random() % 2000000;
        model.zanNum = x;
        int y = arc4random() % 2000000;
        model.commentNum = y;
        int z = arc4random() % 2000000;
        model.shareNum = z;
        [self.dataArr addObject:model];
    }
    [self buildThreeVideoPage];
    [self updateVideoPage];
}
#pragma mark - 处理滑动事件
-(void)hanldeScerollEndOffy:(CGFloat)offy
{
    if (offy == self.lastVideoOffy) {
        //当前偏移量=上一次处理的偏移量 页面没切换
        return;
    }
    if (offy == 0) {
        self.videoIndex -= 1;
    }else if (offy == self.frame.size.height) {
        if (self.lastVideoOffy == 0) {
            self.videoIndex += 1;
        }else if (self.lastVideoOffy == self.frame.size.height*2){
            self.videoIndex -= 1;
        }
    }else if (offy == self.frame.size.height*2) {
        self.videoIndex += 1;
    }
    [self updateVideoPage];
}
#pragma mark - setContentOffset:animated: finished
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self hanldeScerollEndOffy:scrollView.contentOffset.y];
}
#pragma mark - 松手时已经静止, 只会调用scrollViewDidEndDragging
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate == NO){
        // scrollView已经完全静止
        [self hanldeScerollEndOffy:scrollView.contentOffset.y];
    }
}
#pragma mark - 松手时还在运动, 先调用scrollViewDidEndDragging, 再调用scrollViewDidEndDecelerating
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // scrollView已经完全静止
    [self hanldeScerollEndOffy:scrollView.contentOffset.y];
}
#pragma mark - scroll代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}
@end
