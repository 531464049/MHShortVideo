//
//  MHTitleSliderBar.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/11.
//  Copyright © 2018 mh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHTitleSliderBar;

@protocol MHTitleSliderBarDelegate <NSObject>

-(void)titleSliderBar:(MHTitleSliderBar *)bar selected:(NSInteger)index;

@end

@interface MHTitleSliderBar : UIView

@property(nonatomic,weak)id <MHTitleSliderBarDelegate> delegate;

/**
 外界滑动偏移量-底部线条会随偏移量变化
 @param cfl 偏移量
 */
-(void)titleSliderBarScrollBottomLine:(CGFloat )cfl;

/**
 外界滑动结束-结束位置
 @param index 结束的位置
 */
-(void)titleSliderBarOutSideScrollEnd:(NSInteger)index;

/**
 初始化方法
 @param frame frame
 @param titleArr 标题数组
 @return self
 */
-(instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr;

@end
