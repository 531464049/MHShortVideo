//
//  SyatemMsgVC.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/14.
//  Copyright © 2018 mh. All rights reserved.
//

#import "SyatemMsgVC.h"
#import "SystemMsgCell.h"

@interface SyatemMsgVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)BaseTableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation SyatemMsgVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commit_navBar];
    [self buildTableview];
    [self requestMessageData];
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
    _tableView.tableFooterView = [UIView new];
    [_tableView mh_fixIphoneXBottomMargin];
    [self.view addSubview:_tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SystemMsgModel * model = (SystemMsgModel *)self.dataArr[indexPath.row];
    return model.cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellid = @"xitongxiaoxideliebiaocellid";
    SystemMsgCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[SystemMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.model = (SystemMsgModel *)self.dataArr[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
-(void)requestMessageData
{
    [self.dataArr addObjectsFromArray:[SystemMsgModel test_someModels:self.messageType]];
    [self.tableView reloadData];
}
#pragma mark - 初始化导航栏
-(void)commit_navBar
{
    NSString * title = @"资讯助手";
    if (self.messageType == HomeMessageTypeHelper) {
        title = @"**助手";
    }else if (self.messageType == HomeMessageTypeSystem) {
        title = @"系统消息";
    }
    self.mhNavBar.hidden = NO;
    [self mh_setNeedBackItemWithTitle:title];
    [self mh_setNavBottomlineHiden:NO];
}


@end
