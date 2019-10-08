//
//  HomeTopBar.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/7.
//  Copyright © 2018 mh. All rights reserved.
//

#import "BaseView.h"

@protocol HomeTopBarDelegate <NSObject>

@optional

/**
 首页顶部按钮切换-推荐/城市
 @param isTuiJIan 是否切换到推荐页面
 */
-(void)homeTopBarChangeTo:(BOOL)isTuiJIan;
/** 二维码扫描 */
-(void)homeTopBarScanItemHandle;
/** 搜索 */
-(void)homeTopBarSearchItemHandle;

@end

@interface HomeTopBar : BaseView

@property(nonatomic,weak)id <HomeTopBarDelegate> delegate;

@end
