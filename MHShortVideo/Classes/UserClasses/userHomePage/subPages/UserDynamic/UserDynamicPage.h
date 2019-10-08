//
//  UserDynamicPage.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/19.
//  Copyright © 2018 mh. All rights reserved.
//

#import "BaseViewController.h"
#import "MHMultipleGestureHeader.h"

@interface UserDynamicPage : BaseViewController

@property(nonatomic,weak)id <ChildScrollViewDidScrollDelegate> delegate;

@property(nonatomic,assign)BOOL isOtherUser;//是否是其他用户的主页

@property(nonatomic,assign)BOOL canScroll;

-(void)curentViewDidLoad;
@end
