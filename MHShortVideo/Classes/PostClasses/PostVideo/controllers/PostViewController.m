//
//  PostViewController.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/28.
//  Copyright © 2018 mh. All rights reserved.
//

#import "PostViewController.h"
#import "PostTitleContentView.h"
#import "PostTFHanldeView.h"//键盘弹出时的遮罩层
#import "PostAddLocation.h"//添加位置
#import "PostWhoCanSeeView.h"//谁可以看
#import "PostChooseLocationVC.h"//选择位置
#import "PostWCSVC.h"//谁可以看 vc
#import "PostBottomBar.h"
#import "ChooseATUserView.h"

@interface PostViewController ()<PostTitleContentDelegate,PostTFHanldeDelegate,PostAddLocationDelegate,ChooseLocationDelegate,PostWhoCanSeeDelgate,PostBottomBarDelegate>

@property(nonatomic,strong)UIScrollView * contentScrollView;//整体容器，不包含底部【草稿-发布】

@property(nonatomic,strong)PostTitleContentView * titleContent;//标题-封面 #话题 @好友
@property(nonatomic,strong)PostAddLocation * addLocation;//添加位置
@property(nonatomic,strong)PostWhoCanSeeView * whoCanSee;//谁可以看

@property(nonatomic,strong)PostTFHanldeView * tfHanldeview;//键盘弹出时页面的遮罩-点击收起键盘 同时响应话题列表显示

@property(nonatomic,strong)PostBottomBar * bottomBar;//底部-草稿/发布/保存本地

@end

@implementation PostViewController
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [MHStatusBarHelper updateStatuesBarHiden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.mhNavBar.hidden = NO;
    [self mh_setNeedBackItemWithTitle:@"发布"];
    [self commit_subViews];
}
#pragma mark - 初始化页面
-(void)commit_subViews
{
    //底部-草稿 发布 保存本地 总高度
    CGFloat bottomBarHeight = Width(120);
    
    //初始化主容器
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavHeight, Screen_WIDTH, Screen_HEIGTH - NavHeight - bottomBarHeight - k_bottom_margin)];
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.contentScrollView];
    self.contentScrollView.contentSize = CGSizeMake(Screen_WIDTH, self.contentScrollView.frame.size.height + 1);
    
    //标题封面区域
    self.titleContent = [[PostTitleContentView alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH, Width(145))];
    self.titleContent.delegate = self;
    self.titleContent.videoModel = self.videoModel;
    [self.contentScrollView addSubview:self.titleContent];
    
    //添加位置
    self.addLocation = [[PostAddLocation alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleContent.frame), Screen_WIDTH, Width(110))];
    self.addLocation.delegate = self;
    [self.contentScrollView addSubview:self.addLocation];
    
    //谁可以看
    self.whoCanSee = [[PostWhoCanSeeView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.addLocation.frame), Screen_WIDTH, Width(50))];
    self.whoCanSee.delegate = self;
    [self.contentScrollView addSubview:self.whoCanSee];
    
    //初始化底部bar
    self.bottomBar = [[PostBottomBar alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.contentScrollView.frame), Screen_WIDTH, bottomBarHeight)];
    self.bottomBar.delegate = self;
    [self.view addSubview:self.bottomBar];
}
#pragma mark - 话题 点击回调
-(void)titleContentTopicItemHandle
{
    //遮罩层 切换到话题列表
    [self.tfHanldeview updateToTopicList];
}
#pragma mark - @好友 点击回调
-(void)titleContentATUserItemHandle
{
    [self.view endEditing:YES];
    //跳转到 @好友列表
    [ChooseATUserView showChooseATUserWithCallBack:^(UserModel *user) {
        if (user) {
            [self.titleContent textViewAddATUser:user.userName];
        }
    }];
}
#pragma mark - 历史话题列表点击回调
- (void)historyTopicListSelectedTopic:(NSString *)topic
{
    [self.titleContent textViewAddTopic:topic];
}
-(void)postAddLocationChoosedLocation:(NSString *)locationName
{
    self.videoModel.postLocation = locationName;
}
#pragma mark - 位置选择回调
-(void)postChooseLocationCallBack:(NSString *)locationName
{
    self.videoModel.postLocation = locationName;
}
#pragma mark - 添加位置 更多点击
-(void)postAddLocationMoreItemHandle
{
    DLog(@"跳转  更多位置选择列表");
    PostChooseLocationVC * vc = [[PostChooseLocationVC alloc] init];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark - 跳转 选择可以看的权限
-(void)whoCanSeeJumpToChoose
{
    PostWCSVC * vc = [[PostWCSVC alloc] init];
    vc.openType = self.videoModel.postOpenType;
    vc.callBack = ^(MHPostVideoOpenType openType) {
        self.videoModel.postOpenType = openType;
        [self.whoCanSee updateOpenType:openType];
    };
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark - 输入框是否在编辑状态
-(void)titleContentTextViewIsEidting:(BOOL)isEidting
{
    if (isEidting) {
        self.tfHanldeview.hidden = NO;
    }else{
        self.tfHanldeview.hidden = YES;
    }
}
#pragma mark - 键盘遮罩响应 收起键盘
- (void)tfHanldeViewHanldeKeyBordDown
{
    [self.view endEditing:YES];
    self.tfHanldeview.hidden = YES;
}
#pragma mark - 存草稿
-(void)postBottomHandleClickSaveCaoGao
{
    [MHLoading showloading];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MHLoading stopLoading];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    });
}
#pragma mark - 发布
-(void)postBottomHandleClickPost
{
    [MHLoading showloading];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MHLoading stopLoading];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    });
}
- (PostTFHanldeView *)tfHanldeview
{
    if (!_tfHanldeview) {
        _tfHanldeview = [[PostTFHanldeView alloc] initWithFrame:CGRectMake(0, NavHeight + CGRectGetHeight(self.titleContent.frame), Screen_WIDTH, Screen_HEIGTH - (NavHeight + CGRectGetHeight(self.titleContent.frame)))];
        _tfHanldeview.delegate = self;
        [self.view addSubview:_tfHanldeview];
        [self.view bringSubviewToFront:_tfHanldeview];
    }
    return _tfHanldeview;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
