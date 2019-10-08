//
//  VideoDetailPageVC.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/21.
//  Copyright © 2018 mh. All rights reserved.
//

#import "VideoDetailPageVC.h"
#import "VideoPageView.h"

@interface VideoDetailPageVC ()<VideoPageDelegate>

@property(nonatomic,strong)VideoPageView * videoPage;//当前显示page
@property(nonatomic,assign)BOOL isFirstTimeShow;//是否是第一次进入页面

@end

@implementation VideoDetailPageVC
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isFirstTimeShow) {
        self.isFirstTimeShow = NO;
        [self.videoPage autoStartPlay];
    }else{
        [self.videoPage startPlay];
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.videoPage stopPlay];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self commit_navBar];
    [self commit_videoView];
    self.isFirstTimeShow = YES;
}
-(void)commit_videoView
{
    self.videoPage = [[VideoPageView alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH, Screen_HEIGTH - k_bottom_margin)];
    self.videoPage.delegate = self;
    if (self.navigationController) {
        self.videoPage.curentNav = self.navigationController;
    }else{
        self.videoPage.curentNav = self.curentNav;
    }
    [self.view addSubview:self.videoPage];
    self.videoPage.videoModel = self.videoModel;
    
    [self.view bringSubviewToFront:self.mhNavBar];
}
-(void)commit_navBar
{
    self.mhNavBar.hidden = NO;
    self.mhNavBar.backgroundColor = [UIColor clearColor];
    [self mh_setNeedBackItem:YES];
    [self mh_setNavBottomlineHiden:YES];
}
-(void)mh_navBackItem_click
{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
