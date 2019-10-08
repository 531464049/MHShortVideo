//
//  MHMjHeader.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/29.
//  Copyright © 2018 mh. All rights reserved.
//

#import "MHMjHeader.h"

@interface MHMjHeader ()

@property (weak, nonatomic) UIImageView * imgView;

@end

@implementation MHMjHeader

- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 50;
    
    // imgView
    UIImageView * imgView = [[UIImageView alloc] init];
    imgView.contentMode = UIViewContentModeCenter;
    
    imgView.image = [UIImage imageNamed:@"icon_storyhome_open"];
    
    [self addSubview:imgView];
    self.imgView = imgView;
}
-(void)mdiy_startLoading
{
    if ([self.imgView isAnimating]) {
        return;
    }
    
    NSMutableArray * imgArr = [NSMutableArray arrayWithCapacity:0];
    for (NSUInteger i = 0; i<14; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading%02lu",(unsigned long)i]];
        [imgArr safe_addObject:image];
    }

    //设置动画数组
    [self.imgView setAnimationImages:imgArr];
    //设置动画播放次数
    [self.imgView setAnimationRepeatCount:0];
    //设置动画播放时间
    [self.imgView setAnimationDuration:1.0];
    //开始动画
    [self.imgView startAnimating];
}
-(void)mdiy_stopLoading
{
    if ([self.imgView isAnimating]) {
        [self.imgView stopAnimating];
    }
}
#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    self.imgView.frame = CGRectMake(self.bounds.size.width/2-self.mj_h/2, 0, self.mj_h, self.mj_h);//67*80
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case 1:
            [self mdiy_stopLoading];
            break;
        case 2:
            [self mdiy_stopLoading];
            break;
        case 3:
            [self mdiy_startLoading];
            break;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
}
@end
