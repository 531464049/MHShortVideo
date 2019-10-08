//
//  PostWhoCanSeeView.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/30.
//  Copyright © 2018 mh. All rights reserved.
//

#import "BaseView.h"

@protocol PostWhoCanSeeDelgate;
@interface PostWhoCanSeeView : BaseView

@property(nonatomic,weak)id <PostWhoCanSeeDelgate> delegate;

-(void)updateOpenType:(MHPostVideoOpenType )openType;

@end

@protocol PostWhoCanSeeDelgate <NSObject>

@optional
-(void)whoCanSeeJumpToChoose;

@end
