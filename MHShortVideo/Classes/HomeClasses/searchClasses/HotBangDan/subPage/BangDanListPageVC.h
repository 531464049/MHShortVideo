//
//  BangDanListPageVC.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/11.
//  Copyright © 2018 mh. All rights reserved.
//

#import "BaseViewController.h"
#import "BangDanModel.h"

@protocol BangDanListPageDelegate<NSObject>

@optional
- (void)BangDanListPageDidScroll:(UIScrollView *)scrollView;

@end

@interface BangDanListPageVC : BaseViewController

@property(nonatomic,weak)id <BangDanListPageDelegate> delegate;
@property(nonatomic,assign)BanDanListType listType;//榜单列表类型
@property(nonatomic,assign)BOOL canScroll;

-(void)curentViewDidLoad;
@end

