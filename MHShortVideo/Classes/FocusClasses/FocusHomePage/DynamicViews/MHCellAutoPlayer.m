//
//  MHCellAutoPlayer.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/13.
//  Copyright © 2018 mh. All rights reserved.
//

#import "MHCellAutoPlayer.h"
@interface MHCellAutoPlayer ()

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

@property(nonatomic,strong)UIControl * fullScrenControl;//全屏点击
@property(nonatomic,strong)UIButton * playPauseBtn;//播放-暂停按钮

@property(nonatomic,assign)BOOL isFullScren;//是否是全屏播放状态
@property(nonatomic,assign) BOOL firstTimeFullSrc;//是否是第一次进入全屏 第一次时保存fatherView
@property(nonatomic,strong) UIView * fatherView;//非全屏时的父view
@property(nonatomic,assign) CGRect oldRect;//非全屏时 在父view上的frame

@end

@implementation MHCellAutoPlayer

+ (instancetype)sharedPlayer {
    static MHCellAutoPlayer *playerView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playerView = [[MHCellAutoPlayer alloc] init];
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
    self.isFullScren = NO;
    self.firstTimeFullSrc = YES;
    
    self.frame = frame;
    NSURL * url = [NSURL URLWithString:videoUrl];
    self.videoURL = url;
    
    [self prepareToPlay];
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
    //添加播放控制
    [self addPlayControl];
    //添加时间观察者
    [self addTimeObserve];
    //添加通知+kvo
    [self addPlayerNotiAndKVO];
    //播放
    [self play];
}
#pragma mark - 添加播放控制
-(void)addPlayControl
{
    self.fullScrenControl = [[UIControl alloc] initWithFrame:self.bounds];
    self.fullScrenControl.backgroundColor = [UIColor clearColor];
    [self.fullScrenControl addTarget:self action:@selector(fullScrenControlClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.fullScrenControl];
    
    self.playPauseBtn = [UIButton buttonWithType:0];
    self.playPauseBtn.frame = CGRectMake(0, 0, 60, 60);
    self.playPauseBtn.center = CGPointMake(self.frame.size.width-30, self.frame.size.height-30);
    [self.playPauseBtn setImage:[UIImage imageNamed:@"auto_player_pause"] forState:0];
    [self.playPauseBtn addTarget:self action:@selector(playPauseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.playPauseBtn];
}
#pragma mark - 重置子控件frame
-(void)reSetFrames
{
    self.playerLayer.frame = self.bounds;
    self.fullScrenControl.frame = self.bounds;
    self.playPauseBtn.frame = CGRectMake(0, 0, 60, 60);
    self.playPauseBtn.center = CGPointMake(self.frame.size.width-30, self.frame.size.height-30);
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
#pragma mark - 全屏控制点击
-(void)fullScrenControlClick
{
    if (self.firstTimeFullSrc) {
        self.fatherView = self.superview;
        self.oldRect = self.frame;
        self.firstTimeFullSrc = NO;
    }
    if (self.isFullScren) {
        //退出全屏
        self.playPauseBtn.hidden = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            [self.fatherView addSubview:self];
            self.frame = self.oldRect;
            self.playPauseBtn.hidden = NO;
            [self reSetFrames];
        }];
    }else{
        //进入全屏
        self.playPauseBtn.hidden = YES;
        UIWindow * keyWindow = [MHSystemHelper getKeyWindow];
        CGRect startRact = [self convertRect:self.bounds toView:keyWindow];
        [self removeFromSuperview];
        [keyWindow addSubview:self];
        self.frame = startRact;
        CGFloat transScale = Screen_WIDTH / self.frame.size.width;
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(transScale, transScale);
        CGAffineTransform offYTransform = CGAffineTransformMakeTranslation(Screen_WIDTH/2 - self.center.x, Screen_HEIGTH/2 - self.center.y);
        CGAffineTransform transform = CGAffineTransformConcat(scaleTransform, offYTransform);
        [UIView animateWithDuration:0.3 animations:^{
            self.transform = transform;
        } completion:^(BOOL finished) {
            self.playPauseBtn.hidden = NO;
        }];
    }
    self.isFullScren = !self.isFullScren;
}
#pragma mark - 播放
-(void)play
{
    if (self.player) {
        [self.player play];
        self.isPlaying = YES;
        [self.playPauseBtn setImage:[UIImage imageNamed:@"auto_player_pause"] forState:0];
    }
}
#pragma mark - 暂停
-(void)pause
{
    if (self.player) {
        [self.player pause];
        self.isPlaying = NO;
        [self.playPauseBtn setImage:[UIImage imageNamed:@"auto_player_play"] forState:0];
    }
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
            //可以播放
            [self.layer insertSublayer:self.playerLayer atIndex:0];
        } else if (self.player.currentItem.status == AVPlayerItemStatusFailed) {
            NSLog(@"%@",self.playerItem.error);
        }
        
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        //缓冲进度变化
        NSTimeInterval timeInterval = [self availableDuration];
        CMTime duration             = self.playerItem.duration;
        CGFloat totalDuration       = CMTimeGetSeconds(duration);
        CGFloat value = timeInterval / totalDuration;
        //NSLog(@"player  缓冲进度:%f",value);
        
    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
        //NSLog(@"player  缓冲不够用 需要暂停");

    } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        //NSLog(@"player  缓冲足够 可以播放");
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
    if (_fullScrenControl) {
        [_fullScrenControl removeFromSuperview];
        _fullScrenControl = nil;
    }
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}
@end
