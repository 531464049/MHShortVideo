//
//  SearchHeaderView.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/10.
//  Copyright © 2018 mh. All rights reserved.
//

#import "BaseView.h"
#import "SearchModel.h"

@protocol searchHeaderViewDelegate <NSObject>

@optional
/** 查看更多热搜榜单 */
-(void)searchHeaderHotBangDanHandle;

@end

@interface SearchHeaderView : BaseView

@property(nonatomic,strong)SearchHeaderModel * model;

@property(nonatomic,weak)id <searchHeaderViewDelegate> delegate;

+(CGFloat)headerHeight;

@end
