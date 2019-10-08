//
//  MHCarouselView.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/10.
//  Copyright © 2018 mh. All rights reserved.
//

#import "MHCarouselView.h"

@interface MHCarouselView ()<UIScrollViewDelegate>
//滚动视图
@property (nonatomic, strong) UIScrollView * scrollView;
//分页控件
@property (nonatomic, strong) UIPageControl * pageControl;

//当前显示的imageView
@property (nonatomic, strong) UIImageView *curentImageView;
//上一个显示的imageView
@property (nonatomic, strong) UIImageView *lastImageView;
//下一个显示的imageView
@property (nonatomic, strong) UIImageView *nextImageView;
//当前显示图片的索引
@property (nonatomic, assign) NSInteger curentIndex;
//pageControl图片大小
@property (nonatomic, assign) CGSize pageImageSize;
//定时器
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation MHCarouselView

-(void)willMoveToWindow:(UIWindow *)newWindow
{
    if (newWindow) {
        [self startTimer];
    }else{
        [self stopTimer];
    }
}
- (CGFloat)height {
    return self.scrollView.frame.size.height;
}

- (CGFloat)width {
    return self.scrollView.frame.size.width;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.curentIndex = 0;
        [self initSubView];
    }
    return self;
}
-(void)initSubView
{
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
}
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.scrollsToTop = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(self.width * 3, self.height);
        //添加手势监听图片的点击
        [_scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick)]];
        
        _lastImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _lastImageView.clipsToBounds = YES;
        _lastImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_scrollView addSubview:_lastImageView];
        
        _curentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width, 0, self.width, self.height)];
        _curentImageView.clipsToBounds = YES;
        _curentImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_scrollView addSubview:_curentImageView];

        _nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width*2, 0, self.width, self.height)];
        _nextImageView.clipsToBounds = YES;
        _nextImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_scrollView addSubview:_nextImageView];
    }
    return _scrollView;
}
- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    }
    return _pageControl;
}
-(void)updatePageControl
{
    CGSize pageControlSize = [_pageControl sizeForNumberOfPages:_pageControl.numberOfPages];
    pageControlSize.height = 8;
    _pageControl.frame = CGRectMake(0, 0, pageControlSize.width, pageControlSize.height);
    _pageControl.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height - 10 - 4);
    _pageControl.currentPage = 0;
}
- (void)setImageArray:(NSArray *)imageArray
{
    _imageArray = imageArray;
    
    if (_imageArray.count > 1) {
        
        self.pageControl.numberOfPages = _imageArray.count;
        self.curentIndex = 0;
        [self updatePageControl];
        [self updateThreeImages];
        [self startTimer];
        
    }else{
        //只有一个？？？？不滑动
        self.pageControl.hidden = YES;
        self.scrollView.contentOffset = CGPointMake(self.width, 0);
        [self.curentImageView yy_setImageWithURL:[NSURL URLWithString:self.imageArray[0]] placeholder:nil];
        self.scrollView.scrollEnabled = NO;
    }
}
-(void)startTimer
{
    if (self.timer) {
        [self stopTimer];
    }
    self.timer = [NSTimer timerWithTimeInterval:_time < 2? 2 : _time target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
-(void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}
- (void)nextPage
{
    [self.scrollView setContentOffset:CGPointMake(self.width * 2, 0) animated:YES];
}
#pragma mark - 更新显示图片
-(void)updateThreeImages
{
    NSInteger lastIndex = self.curentIndex - 1;
    NSInteger curentIndex = self.curentIndex;
    NSInteger nextIndex = self.curentIndex + 1;
    if (self.curentIndex == 0) {
        lastIndex = self.imageArray.count - 1;
    }else if (self.curentIndex == self.imageArray.count - 1) {
        nextIndex = 0;
    }
    [self.lastImageView yy_setImageWithURL:[NSURL URLWithString:self.imageArray[lastIndex]] placeholder:nil];
    [self.curentImageView yy_setImageWithURL:[NSURL URLWithString:self.imageArray[curentIndex]] placeholder:nil];
    [self.nextImageView yy_setImageWithURL:[NSURL URLWithString:self.imageArray[nextIndex]] placeholder:nil];
    
    [self.scrollView setContentOffset:CGPointMake(self.width, 0) animated:NO];
    self.pageControl.currentPage = self.curentIndex;
}
-(void)hanldeScerollEndOffx:(CGFloat)offx
{
    [self startTimer];
    if (ceil(offx) == 0) {
        if (self.curentIndex == 0) {
            self.curentIndex = self.imageArray.count - 1;
        }else{
            self.curentIndex -= 1;
        }
    }else if (ceil(offx) == ceil(self.width * 2)) {
        if (self.curentIndex == self.imageArray.count - 1) {
            self.curentIndex = 0;
        }else{
            self.curentIndex += 1;
        }
    }
    
    [self updateThreeImages];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self hanldeScerollEndOffx:scrollView.contentOffset.x];
}
#pragma mark - 松手时已经静止, 只会调用scrollViewDidEndDragging
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate == NO){
        // scrollView已经完全静止
        [self hanldeScerollEndOffx:scrollView.contentOffset.x];
    }
}
#pragma mark - 松手时还在运动, 先调用scrollViewDidEndDragging, 再调用scrollViewDidEndDecelerating
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // scrollView已经完全静止
    [self hanldeScerollEndOffx:scrollView.contentOffset.x];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}
@end
