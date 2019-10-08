//
//  SetHomePageVC.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/20.
//  Copyright © 2018 mh. All rights reserved.
//

#import "SetHomePageVC.h"
#import "SetHomePageCell.h"
#import "AccountSafeVC.h"

@interface SetHomePageVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)BaseTableView * tableView;
@property(nonatomic,strong)NSArray * dataArr;
@property(nonatomic,strong)NSArray * sectionTitleArr;
@property(nonatomic,strong)NSArray * imageArr;

@end

@implementation SetHomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commit_navBar];
    [self commit_tableView];
}
#pragma mark - 初始化列表
-(void)commit_tableView
{
    self.sectionTitleArr = @[@"账号",@"通用",@"钱包",@"未成年保护",@"关于",@""];
    self.dataArr = @[
                     @[@"账号与安全",@"隐私设置"],
                     @[@"通知设置",@"通用设置"],
                     @[@"免流县看**",@"DOU+订单管理",@"购物助手",@"商品分享功能"],
                     @[@"时间锁",@"青少年模式"],
                     @[@"反馈与帮助",@"社区自律公约",@"用户协议",@"隐私政策",@"关于**",@"网络检测",@"清理缓存"],
                     @[@"退出登录"]
                     ];
    self.imageArr = @[
                     @[@"user_right_icon1",@"user_right_icon1"],
                     @[@"user_right_icon1",@"user_right_icon1"],
                     @[@"user_right_icon1",@"user_right_icon1",@"user_right_icon1",@"user_right_icon1"],
                     @[@"user_right_icon1",@"user_right_icon1"],
                     @[@"user_right_icon1",@"user_right_icon1",@"user_right_icon1",@"user_right_icon1",@"user_right_icon1",@"user_right_icon1",@"user_right_icon1"],
                     @[@"user_right_icon1"]
                     ];
    _tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, NavHeight, Screen_WIDTH, Screen_HEIGTH - NavHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.tableFooterView = [UIView new];
    [_tableView mh_fixIphoneXBottomMargin];
    [self.view addSubview:_tableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionTitleArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * arr = (NSArray *)self.dataArr[section];
    return arr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Width(50);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellid = @"shezhiliebiaocellidsdsdsd";
    SetHomePageCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[SetHomePageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    NSArray * titleArr = (NSArray *)self.dataArr[indexPath.section];
    NSArray * imgArr = (NSArray *)self.imageArr[indexPath.section];
    cell.cellTitleName = titleArr[indexPath.row];
    cell.cellIconName = imgArr[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    self.sectionTitleArr = @[@"账号",@"通用",@"钱包",@"未成年保护",@"关于",@""];
    self.dataArr = @[
                     @[@"账号与安全",@"隐私设置"],
                     @[@"通知设置",@"通用设置"],
                     @[@"免流县看**",@"DOU+订单管理",@"购物助手",@"商品分享功能"],
                     @[@"时间锁",@"青少年模式"],
                     @[@"反馈与帮助",@"社区自律公约",@"用户协议",@"隐私政策",@"关于**",@"网络检测",@"清理缓存"],
                     @[@"退出登录"]
                     ];
     */
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            //通用
            if (indexPath.row == 0) {
                //账号与安全
                AccountSafeVC * vc = [[AccountSafeVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
            break;
            
        default:
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section > 4) {
        return 0.1;
    }
    return Width(40);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat headerHight = Width(40);
    if (section > 4) {
        headerHight = 0.1;
    }
    UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH, headerHight)];
    header.backgroundColor = [UIColor base_color];
    
    if (section <= 4) {
        UILabel * lab = [UILabel labTextColor:[UIColor grayColor] font:FONT(14) aligent:NSTextAlignmentLeft];
        lab.text = self.sectionTitleArr[section];
        lab.frame = CGRectMake(Width(15), 0, Screen_WIDTH - Width(30), headerHight);
        [header addSubview:lab];
    }
    
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section <= 4) {
        return 10;
    }
    return Width(100);
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CGFloat fHeight = 10;
    if (section > 4) {
        fHeight = Width(100);
    }
    UIView * footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH, fHeight)];
    footer.backgroundColor = [UIColor base_color];
    
    if (section <= 4) {
        //分割线
        UIView * sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH - Width(30), 0.5)];
        sepLine.center = CGPointMake(Screen_WIDTH/2, fHeight/2);
        sepLine.backgroundColor = [UIColor grayColor];
        [footer addSubview:sepLine];
    }else{
        //版本号
        UILabel * lab = [UILabel labTextColor:[UIColor grayColor] font:FONT(14) aligent:NSTextAlignmentCenter];
        lab.frame = CGRectMake(0, 0, Screen_WIDTH, Width(20));
        lab.center = CGPointMake(Screen_WIDTH/2, fHeight - Width(25) - Width(10));
        [footer addSubview:lab];
        lab.text = [NSString stringWithFormat:@"** version %@",[MHSystemHelper getAppVersion]];
    }
    
    return footer;
}
#pragma mark - 初始化导航栏
-(void)commit_navBar
{
    self.mhNavBar.hidden = NO;
    [self mh_setNeedBackItemWithTitle:@"设置"];
    [self mh_setNavBottomlineHiden:NO];
}

@end
