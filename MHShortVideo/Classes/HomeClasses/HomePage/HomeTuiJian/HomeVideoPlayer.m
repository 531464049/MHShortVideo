//
//  HomeVideoPlayer.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/4.
//  Copyright © 2018 mh. All rights reserved.
//

#import "HomeVideoPlayer.h"

@interface HomeVideoPlayer ()

@property (nonatomic, strong) NSURL * videoURL;
@property(nonatomic,strong)AVPlayer * player;
@property(nonatomic,strong)AVPlayerItem * playerItem;
@property(nonatomic,strong)AVURLAsset * urlAsset;
@property(nonatomic,strong)AVPlayerLayer * playerLayer;
@property (nonatomic, strong) id timeObserve;

/** 是否在播放 */
@property(nonatomic,assign)BOOL isPlaying;
/** 是否是因为进入后台 暂停 */
@property(nonatomic,assign)BOOL isBackgroundPause;
/** 是否是因为切换页面 暂停 */
@property(nonatomic,assign)BOOL isPageUnShowPause;

@property(nonatomic,strong)UIButton * playPauseBtn;//播放-暂停按钮

@property(nonatomic,copy)mhPlayerVideoLoadingHandle loadingHandle;//加载回调
@property(nonatomic,copy)mhPlayerVideoCanPlayHandle canPlayHandle;//加载结束 可以播放回调
@property(nonatomic,copy)mhPlayerDidPlayToEndTimeHandle playToEndHandle;//播放完成回调
@property(nonatomic,copy)mhPlayerVideoPlayStateHandle playStateHandle;//播放状态-是否在播放 回调

@end
@implementation HomeVideoPlayer

+ (instancetype)sharedPlayer {
    static HomeVideoPlayer *playerView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playerView = [[HomeVideoPlayer alloc] init];
    });
    return playerView;
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
#pragma mark - 设置视频地址+frame
-(void)playVideo:(NSString *)videoUrl frame:(CGRect)frame
{
    self.isPlaying = NO;
    self.isBackgroundPause = NO;
    self.isPageUnShowPause = NO;
    
    self.frame = frame;
    NSURL * url = [NSURL URLWithString:videoUrl];
    self.videoURL = url;
    
    [self prepareToPlay];
}
#pragma mark - 添加播放回调
- (void)playerLoadingHandle:(mhPlayerVideoLoadingHandle)loadingHandle canPlayHandle:(mhPlayerVideoCanPlayHandle)canPlayHandle playStateHandle:(mhPlayerVideoPlayStateHandle)playStateHandle playToEndHandle:(mhPlayerDidPlayToEndTimeHandle)playToEndHandle
{
    self.loadingHandle = loadingHandle;
    self.canPlayHandle = canPlayHandle;
    self.playStateHandle = playStateHandle;
    self.playToEndHandle = playToEndHandle;
}
#pragma mark - 准备播放
-(void)prepareToPlay
{
    [self clearAllPlayInfo];
    [self configMHPlayer];
}
#pragma mark - 初始化player相关
-(void)configMHPlayer
{
    self.urlAsset = [AVURLAsset assetWithURL:self.videoURL];
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.urlAsset];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.player.volume = 1.0;
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = self.bounds;
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    //添加时间观察者
    [self addTimeObserve];
    //添加通知+kvo
    [self addPlayerNotiAndKVO];
    //播放
    [self play];
}
- (UIButton *)playPauseBtn
{
    if (!_playPauseBtn) {
        _playPauseBtn = [UIButton buttonWithType:0];
        _playPauseBtn.frame = CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.width/2);
        _playPauseBtn.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [_playPauseBtn addTarget:self action:@selector(playPauseBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_playPauseBtn];
    }
    return _playPauseBtn;
}
#pragma mark - 暂停按钮点击
-(void)playPauseBtnClick
{
    if (self.isPlaying) {
        [self pause];
    }else{
        [self play];
    }
}
#pragma mark - 播放
-(void)play
{
    if (self.player) {
        [self.player play];
        self.isPlaying = YES;
        [self.playPauseBtn setImage:nil forState:0];
        if (self.playerItem.status == AVPlayerItemStatusReadyToPlay) {
            if (self.playStateHandle) {
                self.playStateHandle(YES);
            }
        }
    }
}
#pragma mark - 暂停
-(void)pause
{
    if (self.player) {
        [self.player pause];
        self.isPlaying = NO;
        [self.playPauseBtn setImage:[UIImage imageNamed:@"video_play"] forState:0];
        if (self.playStateHandle) {
            self.playStateHandle(NO);
        }
    }
}
#pragma mark - 首页显示-继续播放
-(void)pageShow_startPlay
{
    if (self.isPageUnShowPause) {
        [self play];
        self.isPageUnShowPause = NO;
    }
}
#pragma mark - 首页消失-暂停播放
-(void)pageHiden_stopPlay
{
    if (self.isPlaying) {
        self.isPageUnShowPause = YES;
    }
    [self pause];
}
#pragma mark - 添加播放进度时间观察
-(void)addTimeObserve
{
    __weak typeof(self) weakSelf = self;
    self.timeObserve = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, 1) queue:nil usingBlock:^(CMTime time){
        AVPlayerItem *currentItem = weakSelf.playerItem;
        NSArray *loadedRanges = currentItem.seekableTimeRanges;
        if (loadedRanges.count > 0 && currentItem.duration.timescale != 0) {
            //NSInteger currentTime = (NSInteger)CMTimeGetSeconds([currentItem currentTime]);
            //NSInteger totalTime = (NSInteger)currentItem.duration.value / currentItem.duration.timescale;
            //NSLog(@"player 总时长:%ld   当前时间:%ld",totalTime,currentTime);
        }
    }];
}
#pragma mark - 添加通知和监听
-(void)addPlayerNotiAndKVO
{
    if (self.playerItem) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayground) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
        [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        [self.playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
        [self.playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    }
}
#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object != self.player.currentItem) {
        return;
    }
    if ([keyPath isEqualToString:@"status"]) {
        
        if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
            //可以播放 回调
            if (self.canPlayHandle) {
                self.canPlayHandle();
            }
            if (self.isPlaying) {
                if (self.playStateHandle) {
                    self.playStateHandle(YES);
                }
            }
            
            [self.layer insertSublayer:self.playerLayer atIndex:0];
        } else if (self.player.currentItem.status == AVPlayerItemStatusFailed) {
            NSLog(@"%@",self.playerItem.error);
        }
        
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        //缓冲进度变化
//        NSTimeInterval timeInterval = [self availableDuration];
//        CMTime duration             = self.playerItem.duration;
//        CGFloat totalDuration       = CMTimeGetSeconds(duration);
//        CGFloat value = timeInterval / totalDuration;
        //NSLog(@"player  缓冲进度:%f",value);
        
    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
        //NSLog(@"player  缓冲不够用 需要暂停");
        if (self.loadingHandle) {
            self.loadingHandle();
        }
    } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        //NSLog(@"player  缓冲足够 可以播放");
        if (self.canPlayHandle) {
            self.canPlayHandle();
        }
    }
}
#pragma mark - 计算缓冲进度
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    CMTimeRange timeRange     = [loadedTimeRanges.firstObject CMTimeRangeValue];
    float startSeconds        = CMTimeGetSeconds(timeRange.start);
    float durationSeconds     = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result     = startSeconds + durationSeconds;
    return result;
}
#pragma mark - 通知--当前视频播放完了
- (void)moviePlayDidEnd:(NSNotification *)notification
{
    //NSLog(@"当前视频播放完成");
    [self.player seekToTime:kCMTimeZero];
    [self.player play];
//    [self pause];
//    if (self.playToEndHandle) {
//        self.playToEndHandle();
//    }
}
#pragma mark - 通知--app退出到后台
-(void)appDidEnterBackground
{
    if (self.isPlaying) {
        self.isBackgroundPause = YES;
    }
    [self pause];
}
#pragma mark - 通知--app进入前台
-(void)appDidEnterPlayground
{
    if (self.isBackgroundPause) {
        [self play];
        self.isBackgroundPause = NO;
    }
}
#pragma mark - 清除播放器信息
-(void)clearAllPlayInfo
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    if (self.playerItem) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
        [_playerItem removeObserver:self forKeyPath:@"status"];
        [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [_playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [_playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    }
    self.playerItem = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.timeObserve) {
        [self.player removeTimeObserver:self.timeObserve];
        self.timeObserve = nil;
    }
    if (_player) {
        [_player pause];
    }
    if (self.playerLayer) {
        [self.playerLayer removeFromSuperlayer];
    }
    if (self.player) {
        [self.player replaceCurrentItemWithPlayerItem:nil];
        self.player = nil;
    }
    if (_playPauseBtn) {
        [_playPauseBtn removeFromSuperview];
        _playPauseBtn = nil;
    }
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}
@end
