//
//  MHMjFooter.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/29.
//  Copyright © 2018 mh. All rights reserved.
//

#import "MHMjFooter.h"

@implementation MHMjFooter

- (void)prepare
{
    [super prepare];
    self.automaticallyRefresh = YES;
    self.triggerAutomaticallyRefreshPercent = 0.5;
    
    self.mj_h = 50;
    // 隐藏状态
    self.stateLabel.hidden = YES;
    NSMutableArray * imgArr = [NSMutableArray arrayWithCapacity:0];
    for (NSUInteger i = 0; i<14; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading%02lu",(unsigned long)i]];
        [imgArr safe_addObject:image];
    }
    // 设置正在刷新状态的动画图片
    [self setImages:imgArr duration:1.0 forState:3];
}
#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    self.gifView.frame = CGRectMake(self.bounds.size.width/2-self.mj_h/2, 0, self.mj_h, self.mj_h);//67*80
}

@end
