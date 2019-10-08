//
//  MessageHomePageVC.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/30.
//  Copyright © 2018 mh. All rights reserved.
//

#import "MessageHomePageVC.h"
#import "MessageHomeCell.h"
#import "SyatemMsgVC.h"
#import "FourListVC.h"
#import "ContactsListVC.h"
#import "BaseNavController.h"
#import "UserChatVC.h"

@interface MessageHomePageVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)BaseTableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation MessageHomePageVC
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self commit_navBar];
    [self buildTableview];
}
-(void)buildTableview
{
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    
    _tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, NavHeight, Screen_WIDTH, Screen_HEIGTH - NavHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorInset = UIEdgeInsetsMake(0, Width(15), 0, Width(15));
    
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH, TabBarHeight)];
    footerView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footerView;
    
    [_tableView mh_fixIphoneXBottomMargin];
    [self.view addSubview:_tableView];
    
    [self buildTableViewHeaderView];
    
    [self.dataArr addObjectsFromArray:[MessageHomeModel testModels]];
    [self.tableView reloadData];
}
#pragma mark - 表头
-(void)buildTableViewHeaderView
{
    CGFloat width = Screen_WIDTH/4;
    CGFloat height = Width(106);
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH, height)];
    headerView.backgroundColor = [UIColor clearColor];
    
    NSArray * arr = @[@"粉丝",@"赞",@"@我的",@"评论"];
    NSArray * imgarr = @[@"messageHome_fensi",@"messageHome_zan",@"messageHome_atwode",@"messageHome_pinglun"];
    for (int i = 0; i < 4; i ++) {
        UIView * itemView = [[UIView alloc] initWithFrame:CGRectMake(width*i, 0, width, height)];
        [headerView addSubview:itemView];
        
        UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width(40), Width(40))];
        img.center = CGPointMake(width/2, Width(20) + Width(20));
        img.layer.cornerRadius = 6;
        img.layer.masksToBounds = YES;
        img.image = [UIImage imageNamed:imgarr[i]];
        [itemView addSubview:img];
        
        UILabel * lab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(15) aligent:NSTextAlignmentCenter];
        lab.text = arr[i];
        [itemView addSubview:lab];
        lab.frame = CGRectMake(0, CGRectGetMaxY(img.frame), width, Width(30));
        
        UIButton * btn = [UIButton buttonWithType:0];
        btn.frame = itemView.bounds;
        btn.tag = 5000 + i;
        [btn addTarget:self action:@selector(headerItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [itemView addSubview:btn];
    }
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(Width(15), height-0.5, Screen_WIDTH-Width(30), 0.5)];
    line.backgroundColor = [UIColor grayColor];
    [headerView addSubview:line];
    
    _tableView.tableHeaderView = headerView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Width(50) + Width(10)*2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellid = @"xiaoxiliebiuaocellididididi";
    MessageHomeCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[MessageHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.model = (MessageHomeModel *)self.dataArr[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MessageHomeModel * model = (MessageHomeModel *)self.dataArr[indexPath.row];
    if (model.messageType == HomeMessageTypeUserContact) {
        UserChatVC * vc = [[UserChatVC alloc] init];
        vc.chatName = model.userName;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        SyatemMsgVC * vc = [[SyatemMsgVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.messageType = model.messageType;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - 表头四个按钮点击
-(void)headerItemClick:(UIButton *)sender
{
    NSInteger tag = sender.tag - 5000;
    
    FourListVC * vc = [[FourListVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    
    switch (tag) {
        case 0:
        {
            //粉丝
            vc.type = HomeMsgFourTypeFance;
        }
            break;
        case 1:
        {
            //赞
            vc.type = HomeMsgFourTypeZanMe;
        }
            break;
        case 2:
        {
            //@我的
            vc.type = HomeMsgFourTypeAtMe;
        }
            break;
        case 3:
        {
            //评论
            vc.type = HomeMsgFourTypePingLunMe;
        }
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 初始化导航栏
-(void)commit_navBar
{
    self.mhNavBar.hidden = NO;
    [self mh_setTitle:@"消息"];
    [self mh_setNavBottomlineHiden:YES];
    
    UIButton * rightBtn = [UIButton buttonWithType:0];
    rightBtn.frame = CGRectMake(0, 0, Width(85), 40);
    rightBtn.center = CGPointMake(Screen_WIDTH - Width(85)/2, K_StatusHeight + (NavHeight - K_StatusHeight)/2);
    [rightBtn setTitle:@"联系人" forState:0];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:0];
    rightBtn.titleLabel.font = FONT(16);
    [rightBtn addTarget:self action:@selector(mh_navRightItem_click) forControlEvents:UIControlEventTouchUpInside];
    [self.mhNavBar addSubview:rightBtn];
}
#pragma mark - 联系人
-(void)mh_navRightItem_click
{
    ContactsListVC * vc = [[ContactsListVC alloc] init];
    
    BaseNavController * nvc = [[BaseNavController alloc] initWithRootViewController:vc];
    nvc.navigationBar.tintColor = [UIColor whiteColor];
    nvc.navigationBar.translucent = NO;
    nvc.navigationBarHidden = YES;
    
    [self presentViewController:nvc animated:YES completion:nil];
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
