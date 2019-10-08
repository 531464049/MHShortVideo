//
//  SearchTopBar.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/10.
//  Copyright © 2018 mh. All rights reserved.
//

#import "BaseView.h"

@protocol SearchTopBarDelegate <NSObject>

@optional
-(void)searchTopBarSearchForKey:(NSString *)searchKey;
/** 退出按钮点击 回调 */
-(void)searchTopBarQuitHandle;
/** 查看热搜榜 回调 */
-(void)searchTopBarHandleCheckHotBD;

@end

@interface SearchTopBar : BaseView

@property(nonatomic,weak)id <SearchTopBarDelegate> delegate;
@property(nonatomic,copy)NSString * searchKey;//当前搜索关键词
@property(nonatomic,assign)BOOL quitLeft;//退出按钮在左边


@end
