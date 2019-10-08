//
//  VideoPageView.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/3.
//  Copyright © 2018 mh. All rights reserved.
//

#import "BaseView.h"
#import "HomeVideoModel.h"

@protocol VideoPageDelegate;

@interface VideoPageView : BaseView

@property(nonatomic,weak)id <VideoPageDelegate> delegate;
@property(nonatomic,strong)HomeVideoModel * videoModel;

/** 自动播放 */
-(void)autoStartPlay;

/** 开始播放 */
-(void)startPlay;
/** 停止播放 */
-(void)stopPlay;

@end


@protocol VideoPageDelegate <NSObject>

@optional
-(void)videoPagePlayToEndHandle;

@end
