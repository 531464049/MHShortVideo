//
//  MHCarouselView.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/10.
//  Copyright © 2018 mh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHCarouselView;

//pageControl的显示位置
typedef enum {
    MHCarouselPageDefault,          //默认值 == MHCarouselPageBottomCenter
    MHCarouselPageHide,           //隐藏
    MHCarouselPageTopCenter,      //中上
    MHCarouselPageBottomLeft,     //左下
    MHCarouselPageBottomCenter,   //中下
    MHCarouselPageBottomRight     //右下
} MHCarouselPageCPosition;

@protocol MHCarouselViewDelegate <NSObject>

/**
 *  该方法用来处理图片的点击，会返回图片在数组中的索引
 *  @param carouselView 控件本身
 *  @param index        图片索引
 */
- (void)carouselView:(MHCarouselView *)carouselView clickImageAtIndex:(NSInteger)index;

@end

@interface MHCarouselView : UIView

/** 图片地址数组 */
@property (nonatomic, strong) NSArray *imageArray;
/** 每一页停留时间，默认为5s，最少2s */
@property (nonatomic, assign) NSTimeInterval time;
/** 代理 */
@property (nonatomic, weak) id<MHCarouselViewDelegate> delegate;

@end
