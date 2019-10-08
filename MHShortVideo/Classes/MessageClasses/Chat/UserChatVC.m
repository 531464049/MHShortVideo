//
//  UserChatVC.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/17.
//  Copyright © 2018 mh. All rights reserved.
//

#import "UserChatVC.h"
#import "ChatInputView.h"
#import "ChatCell.h"

@interface UserChatVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)BaseTableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArr;

@property(nonatomic,strong)ChatInputView * inputView;//输入框

@end

@implementation UserChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commit_navBar];
    [self buildTableview];
    [self requestData];
}
-(void)buildTableview
{
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    
    _tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, NavHeight, Screen_WIDTH, Screen_HEIGTH - NavHeight - Width(50) - k_bottom_margin) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
    [_tableView mh_fixIphoneXBottomMargin];
    [self.view addSubview:_tableView];
    
    self.inputView = [[ChatInputView alloc] initWithFrame:CGRectMake(0, Screen_HEIGTH - Width(50)- k_bottom_margin, Screen_WIDTH, Width(50))];
    [self.view addSubview:self.inputView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatModel * model = (ChatModel *)self.dataArr[indexPath.row];
    return model.cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellid = @"liaotianliaotianlea8nizhidaobu";
    ChatCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    ChatModel * model = (ChatModel *)self.dataArr[indexPath.row];
    cell.model = model;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
-(void)scrollToTableViewBottom:(BOOL)animated
{
    NSInteger s = [self.tableView numberOfSections];  //有多少组
    if (s<1) return;  //无数据时不执行 要不会crash
    NSInteger r = [self.tableView numberOfRowsInSection:s-1]; //最后一组有多少行
    if (r<1) return;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];  //取最后一行数据
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated]; //滚动到最后一行
}
-(void)requestData
{
    [ChatModel test200Models:^(NSArray *models) {
        
        [self.dataArr addObjectsFromArray:models];
        [self.tableView reloadData];
        
        [self scrollToTableViewBottom:NO];
    }];
}
#pragma mark - 初始化导航栏
-(void)commit_navBar
{
    self.mhNavBar.hidden = NO;
    [self mh_setNeedBackItemWithTitle:self.chatName];
    [self mh_setNavBottomlineHiden:NO];
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
