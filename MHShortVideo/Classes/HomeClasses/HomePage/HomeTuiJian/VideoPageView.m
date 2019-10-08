//
//  VideoPageView.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/3.
//  Copyright © 2018 mh. All rights reserved.
//

#import "VideoPageView.h"
#import "HomePageRightBar.h"
#import "VideoCommentView.h"
#import "HomeShareView.h"
#import "OtherUserPageVC.h"

@interface VideoPageView ()<HomePageRightBarDelegate>

@property(nonatomic,strong)UIImageView * videoPreImg;//视频预览
@property(nonatomic,strong)UILabel * videoUserLab;//视频用户名
@property(nonatomic,strong)UILabel * videoTitleLab;//视频标题
@property(nonatomic,strong)UIImageView * bgmIcon;//背景音乐icon
@property(nonatomic,strong)UILabel * videoBgmLab;//背景音乐

@property(nonatomic,strong)UIView * loadingLine;//底部 加载动画线条

@property(nonatomic,strong)HomePageRightBar * rightBar;//右侧功能按钮集合

@end

@implementation VideoPageView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commit_subViews];
    }
    return self;
}
#pragma mark - 初始化
-(void)commit_subViews
{
    //视频预览
    self.videoPreImg = [[UIImageView alloc] initWithFrame:self.bounds];
    self.videoPreImg.contentMode = UIViewContentModeScaleAspectFill;
    self.videoPreImg.clipsToBounds = YES;
    self.videoPreImg.userInteractionEnabled = YES;
    [self addSubview:self.videoPreImg];
    
    //底部加载动画线条
    self.loadingLine = [[UIView alloc] init];
    self.loadingLine.backgroundColor = [UIColor whiteColor];
    self.loadingLine.frame = CGRectMake(self.frame.size.width/2, self.frame.size.height - TabBarHeight - k_bottom_margin - 2, 0, 2);
    [self addSubview:self.loadingLine];

    //背景音乐icon
    self.bgmIcon = [[UIImageView alloc] init];
    self.bgmIcon.frame = CGRectMake(Width(15), self.frame.size.height - k_bottom_margin - TabBarHeight - Width(30), Width(18), Width(18));
    self.bgmIcon.image = [UIImage imageNamed:@"home_bgm_icon"];
    self.bgmIcon.contentMode = UIViewContentModeScaleAspectFit;
    self.bgmIcon.clipsToBounds = YES;
    [self addSubview:self.bgmIcon];
    
    //背景音乐lab
    self.videoBgmLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(14) aligent:NSTextAlignmentLeft];
    self.videoBgmLab.numberOfLines = 1;
    [self addSubview:self.videoBgmLab];
    self.videoBgmLab.sd_layout.leftSpaceToView(self.bgmIcon, 0).centerYEqualToView(self.bgmIcon).heightIs(Width(18)).rightSpaceToView(self, Width(95));
    
    //标题
    self.videoTitleLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(14) aligent:NSTextAlignmentLeft];
    self.videoTitleLab.numberOfLines = 0;
    [self addSubview:self.videoTitleLab];
    self.videoTitleLab.sd_resetLayout.leftSpaceToView(self, Width(15)).bottomSpaceToView(self.bgmIcon, 5).rightSpaceToView(self, Width(95)).autoHeightRatio(0);

    //用户名
    self.videoUserLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(16) aligent:NSTextAlignmentLeft];
    self.videoBgmLab.numberOfLines = 1;
    [self addSubview:self.videoUserLab];
    self.videoUserLab.sd_resetLayout.leftSpaceToView(self, Width(15)).bottomSpaceToView(self.videoTitleLab, 10).rightSpaceToView(self, Width(95)).autoHeightRatio(0);
    
    self.rightBar = [[HomePageRightBar alloc] initWithFrame:CGRectMake(self.frame.size.width - Width(62), self.frame.size.height - Width(360) - k_bottom_margin - TabBarHeight, Width(62), Width(360))];
    self.rightBar.delegate = self;
    [self addSubview:self.rightBar];
}
- (void)setVideoModel:(HomeVideoModel *)videoModel
{
    _videoModel = videoModel;
    
    [self.videoPreImg yy_setImageWithURL:[NSURL URLWithString:videoModel.videoPreImage] placeholder:nil];
    
    NSString * bgmStr = [NSString stringWithFormat:@"原声  @%@创作的原声",videoModel.userName];
    self.videoBgmLab.text = bgmStr;
    
    self.videoTitleLab.text = videoModel.videoTitle;
    self.videoUserLab.text = [NSString stringWithFormat:@"@%@",videoModel.userName];
    
    self.rightBar.videoModel = videoModel;
}
#pragma mark - 右侧功能点击回调
-(void)pageRightBarHandle:(PageRightBarHandleType)handleType
{
    switch (handleType) {
        case PageRightBarHandleTypeComment:
        {
            //评论
            [VideoCommentView showWith:@"12"];
        }
            break;
        case PageRightBarHandleTypeShare:
        {
            //分享
            [HomeShareView showShareWindowWithVideo:self.videoModel];
        }
            break;
        case PageRightBarHandleTypeFocusUser:
        {
            //头像点击
            if (self.curentNav) {
                //NSLog(@"%@",self.curentNav);
                OtherUserPageVC * vc = [[OtherUserPageVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.curentNav pushViewController:vc animated:YES];
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark - 视频-开始加载动画
-(void)startLoading
{
    self.loadingLine.frame = CGRectMake(self.frame.size.width/2, self.frame.size.height - TabBarHeight - k_bottom_margin - 2, 0, 2);
    
    CGRect frame = CGRectMake(self.frame.size.width/4, self.frame.size.height - TabBarHeight - k_bottom_margin - 2, self.frame.size.width/2, 0.1);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3]; // 动画时长
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatCount:MAXFLOAT];
    
    self.loadingLine.frame = frame;
    
    [UIView commitAnimations];
}
#pragma mark - 视频-结束加载动画
-(void)stoploading
{
    [self.loadingLine.layer removeAllAnimations];
    self.loadingLine.frame = CGRectMake(self.frame.size.width/2, self.frame.size.height - TabBarHeight - k_bottom_margin - 2, 0, 2);
}
#pragma mark - 播放结束
-(void)handle_playToEnd
{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(videoPagePlayToEndHandle)]) {
//        [self.delegate videoPagePlayToEndHandle];
//    }
}
#pragma mark - 自动播放
-(void)autoStartPlay
{
    [self startLoading];
    [HomeVideoPlayer.sharedPlayer playVideo:self.videoModel.videoUrl frame:self.videoPreImg.bounds];
    [self.videoPreImg addSubview:HomeVideoPlayer.sharedPlayer];
    
    [HomeVideoPlayer.sharedPlayer playerLoadingHandle:^{
        //DLog(@"-------加载-------");
        [self startLoading];
    } canPlayHandle:^{
        //DLog(@"-------加载结束-------");
        [self stoploading];
    } playStateHandle:^(BOOL isPlaying) {
        if (isPlaying) {
            //DLog(@"-------播放-------");
        }else{
            //DLog(@"-------暂停-------");
        }
    } playToEndHandle:^{
        //DLog(@"-------结束-------");
        [self handle_playToEnd];
    }];
}
#pragma mark - 播放当前页面视频
-(void)startPlay
{
    BOOL hasPlayer = NO;
    for (UIView * subView in self.videoPreImg.subviews) {
        if ([subView isKindOfClass:[HomeVideoPlayer class]]) {
            hasPlayer = YES;
        }
    }
    if (hasPlayer) {
        [HomeVideoPlayer.sharedPlayer pageShow_startPlay];
    }else{
        [self autoStartPlay];
    }
    
}
#pragma mark - 停止播放
-(void)stopPlay
{
    BOOL hasPlayer = NO;
    for (UIView * subView in self.videoPreImg.subviews) {
        if ([subView isKindOfClass:[HomeVideoPlayer class]]) {
            hasPlayer = YES;
        }
    }
    if (hasPlayer) {
        [HomeVideoPlayer.sharedPlayer pageHiden_stopPlay];
    }
}
@end
