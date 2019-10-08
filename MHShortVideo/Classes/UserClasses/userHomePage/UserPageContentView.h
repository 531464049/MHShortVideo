//
//  UserPageContentView.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/19.
//  Copyright © 2018 mh. All rights reserved.
//

#import "BaseView.h"

@protocol UserPageContentDelegate <NSObject>

@optional
-(void)userPageContentIsScroll:(BOOL)isScroll;
-(void)childPageDidScroll:(UIScrollView *)scroll;

@end

@interface UserPageContentView : BaseView

-(instancetype)initWithFrame:(CGRect)frame isOtherUser:(BOOL)isOtherUser;
@property(nonatomic,weak)id <UserPageContentDelegate> delegate;
@property(nonatomic,assign)BOOL listCanScroll;

@end
