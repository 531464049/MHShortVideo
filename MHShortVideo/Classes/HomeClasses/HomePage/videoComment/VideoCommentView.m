//
//  VideoCommentView.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/4.
//  Copyright © 2018 mh. All rights reserved.
//

#import "VideoCommentView.h"
#import "CommentModel.h"
#import "VideoCommentCell.h"
#import "CommentTextView.h"

@interface VideoCommentView ()<UITableViewDelegate,UITableViewDataSource,CommentInputVideDelegate>

@property(nonatomic,copy)NSString * videoID;
@property(nonatomic,strong)UIView * contentView;
@property(nonatomic,strong)UILabel * numOfCommentLab;//评论数lab
@property(nonatomic,strong)BaseTableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArr;//数据源

@property(nonatomic,strong)UIControl * inputHidenControl;//输入框弹起时的遮罩 点击收起键盘
@property(nonatomic,strong)CommentTextView * inputView;//输入框

@end

@implementation VideoCommentView

-(instancetype)initWithFrame:(CGRect)frame videoID:(NSString *)videoID
{
    self = [super initWithFrame:frame];
    if (self) {
        self.videoID = videoID;
        [self commit_subViews];
    }
    return self;
}
#pragma mark - 初始化界面
-(void)commit_subViews
{
    //点击退出遮罩
    UIControl * hidenControl = [[UIControl alloc] initWithFrame:self.bounds];
    [hidenControl addTarget:self action:@selector(hidenCommentPage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:hidenControl];
    //整体容器
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, Width(190), self.frame.size.width, self.frame.size.height - Width(190))];
    [self addSubview:self.contentView];
    //毛玻璃
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = self.contentView.bounds;
    [self.contentView addSubview:effectView];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10,10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.contentView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.contentView.layer.mask = maskLayer;
    
    //评论数量
    self.numOfCommentLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(14) aligent:NSTextAlignmentCenter];
    self.numOfCommentLab.frame = CGRectMake(0, 0, self.frame.size.width/2, Width(40));
    self.numOfCommentLab.center = CGPointMake(self.frame.size.width/2, Width(20));
    self.numOfCommentLab.text = @"2222条评论";
    [self.contentView addSubview:self.numOfCommentLab];
    
    //退出按钮
    UIButton * quitBtn = [UIButton buttonWithType:0];
    quitBtn.frame = CGRectMake(self.frame.size.width - Width(40), 0, Width(40), Width(40));
    [quitBtn setImage:[UIImage imageNamed:@"common_close"] forState:0];
    [quitBtn addTarget:self action:@selector(hidenCommentPage) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:quitBtn];
    
    //容器弹出动画
    [self contentAnimationShow:YES];
    
    //初始化列表
    [self commit_tableview];
    //初始化输入框
    [self commit_inputTF];
}
#pragma mark - 初始化列表
-(void)commit_tableview
{
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    
    _tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, Width(40), self.frame.size.width, self.contentView.frame.size.height - Width(40) - Width(50) - k_bottom_margin) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
    [self.contentView addSubview:_tableView];
    
    [self requestCommentData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentModel * model = (CommentModel *)self.dataArr[indexPath.row];
    return model.cellHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellid = @"shipinpinglunliebiancellid";
    VideoCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[VideoCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    CommentModel * model = (CommentModel *)self.dataArr[indexPath.row];
    cell.model = model;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark - 获取评论数据
-(void)requestCommentData
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSArray * arr = [CommentModel test_getModels];
        [self.dataArr addObjectsFromArray:arr];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}
#pragma mark - 初始化输入框
-(void)commit_inputTF
{
    self.inputHidenControl = [[UIControl alloc] initWithFrame:self.bounds];
    self.inputHidenControl.hidden = YES;
    [self.inputHidenControl addTarget:self action:@selector(hidenKeyBord) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.inputHidenControl];
    
    self.inputView = [[CommentTextView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - Width(50)- k_bottom_margin, Screen_WIDTH, Width(50))];
    self.inputView.delegate = self;
    [self addSubview:self.inputView];
}
#pragma mark - 键盘收起
-(void)hidenKeyBord
{
    [self endEditing:YES];
}
#pragma mark - 输入框回调-键盘弹起/收起
-(void)inputVideKeyBordShow:(BOOL)show
{
    if (show) {
        self.inputHidenControl.hidden = NO;
    }else{
        self.inputHidenControl.hidden = YES;
    }
}
#pragma mark - 输入框回调-发送
- (void)inputViewSendText:(NSString *)sendText
{
    CommentModel * model = [CommentModel new];
    model.username = @"三炮";
    model.userimage = @"http://pic32.photophoto.cn/20140819/0008020285038599_b.jpg";
    model.content = sendText;
    model.time = @"刚刚";
    model.zanNum = 0;
    model.beZan = NO;
    [CommentModel layoutCommnet:model];
    
    [self.dataArr insertObject:model atIndex:0];
    [self.tableView reloadData];
}
#pragma mark - 整体容器进入、退出动画
-(void)contentAnimationShow:(BOOL)show
{
    CGRect rect = self.frame;
    if (show) {
        rect.origin.y = 0;
    }else{
        rect.origin.y = self.frame.size.height - Width(190);
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = rect;
    }];
}
#pragma mark - 退出
-(void)hidenCommentPage
{
    [self contentAnimationShow:NO];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
+(void)showWith:(NSString *)videoID
{
    UIWindow * keywindow = [UIApplication sharedApplication].keyWindow;
    if (!keywindow) {
        keywindow = [[UIApplication sharedApplication].windows firstObject];
    }

    VideoCommentView * vvv = [[VideoCommentView alloc] initWithFrame:CGRectMake(0, Screen_HEIGTH-Width(190), Screen_WIDTH, Screen_HEIGTH) videoID:videoID];
    [keywindow addSubview:vvv];
}

@end
