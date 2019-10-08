//
//  HomeVideoPlayer.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/4.
//  Copyright © 2018 mh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

/** 当前视频播放完成 回调 */
typedef void(^mhPlayerDidPlayToEndTimeHandle)(void);
/** 当前视频正在缓冲-加载 回调 */
typedef void(^mhPlayerVideoLoadingHandle)(void);
/** 当前视频可以播放 回调 */
typedef void(^mhPlayerVideoCanPlayHandle)(void);
/** 当前视频播放状态-是否在播放 回调 */
typedef void(^mhPlayerVideoPlayStateHandle)(BOOL isPlaying);

@interface HomeVideoPlayer : UIView

/**
 重置播放器
 @param videoUrl 视频地址
 @param frame 播放器位置
 */
-(void)playVideo:(NSString *)videoUrl frame:(CGRect)frame;

-(void)playerLoadingHandle:(mhPlayerVideoLoadingHandle)loadingHandle canPlayHandle:(mhPlayerVideoCanPlayHandle)canPlayHandle playStateHandle:(mhPlayerVideoPlayStateHandle)playStateHandle playToEndHandle:(mhPlayerDidPlayToEndTimeHandle)playToEndHandle;


-(void)pageShow_startPlay;
-(void)pageHiden_stopPlay;

/** 清除播放器信息 */
-(void)clearAllPlayInfo;

/** 播放器单例 */
+ (instancetype)sharedPlayer;


@end

