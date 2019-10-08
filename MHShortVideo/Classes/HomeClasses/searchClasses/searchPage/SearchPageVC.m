//
//  SearchPageVC.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/10.
//  Copyright © 2018 mh. All rights reserved.
//

#import "SearchPageVC.h"
#import "SearchTopBar.h"
#import "SearchCell.h"
#import "SearchHeaderView.h"
#import "HotBangDanContentVC.h"
#import "SearchResultVC.h"
//#import "UIViewController+CWLateralSlide.h"

@interface SearchPageVC ()<SearchTopBarDelegate,UITableViewDelegate,UITableViewDataSource,searchHeaderViewDelegate>

@property(nonatomic,strong)SearchTopBar * searchTopBar;//搜索框

@property(nonatomic,strong)BaseTableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArr;
@property(nonatomic,strong)SearchHeaderModel * headerData;
@property(nonatomic,assign)NSInteger page;

@end

@implementation SearchPageVC
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"搜索 显示了");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self commit_navBar];
    [self commit_tableView];
    self.page = 1;
//    [MHLoading showloading];
    [self requestDataWithPage:self.page];
}
#pragma mark - 初始化tableview
-(void)commit_tableView
{
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    self.headerData = nil;
    
    self.tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, NavHeight, Screen_WIDTH, Screen_HEIGTH-NavHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, Width(16), 0, Width(16));
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    [self.tableView mh_fixIphoneXBottomMargin];
    
    self.tableView.mj_header = [MHMjHeader headerWithRefreshingTarget:self refreshingAction:@selector(header_refresh)];
    self.tableView.mj_footer = [MHMjFooter footerWithRefreshingTarget:self refreshingAction:@selector(footer_refresh)];
    
    [self updateTableViewHeader];
}
#pragma mark - 更新headerview
-(void)updateTableViewHeader
{
    self.tableView.tableHeaderView = nil;
    if (!self.headerData) {
        return;
    }
    
    CGFloat headerHeight = [SearchHeaderView headerHeight];
    
    SearchHeaderView * header = [[SearchHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, headerHeight)];
    header.model = self.headerData;
    header.delegate = self;
    
    self.tableView.tableHeaderView = header;
}
#pragma mark - tableview代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Width(70) + Width(140) + Width(15);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * searchCellId = @"sousuoliebaocellidlklio";
    SearchCell * cell = [tableView dequeueReusableCellWithIdentifier:searchCellId];
    if (!cell) {
        cell = [[SearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchCellId];
    }
    SearchModel * model = (SearchModel *)self.dataArr[indexPath.row];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    SearchResultVC * resultVC = [[SearchResultVC alloc] init];
    resultVC.searchKey = @"你好";
    [self.navigationController pushViewController:resultVC animated:YES];
}
#pragma mark - 根据页面获取数据
-(void)requestDataWithPage:(NSInteger)page
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [MHLoading stopLoading];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        NSArray * arr = [SearchModel randomDataArr];
        
        if (self.page == 1) {
            [self.dataArr removeAllObjects];
            
            SearchHeaderModel * headerModel = [SearchHeaderModel randomHeadeModel];
            self.headerData = headerModel;
            
            [self updateTableViewHeader];
        }
        [self.dataArr addObjectsFromArray:arr];
        
        self.page += 1;
        
        [self.tableView reloadData];
        
    });
}
-(void)header_refresh
{
    self.page = 1;
    [self requestDataWithPage:self.page];
}
-(void)footer_refresh
{
    [self requestDataWithPage:self.page];
}
#pragma mark - 查看更多热搜榜单
-(void)searchHeaderHotBangDanHandle
{
    HotBangDanContentVC * vc = [[HotBangDanContentVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)searchTopBarHandleCheckHotBD
{
    [self searchHeaderHotBangDanHandle];
}
#pragma mark - 搜索
- (void)searchTopBarSearchForKey:(NSString *)searchKey
{
    SearchResultVC * resultVC = [[SearchResultVC alloc] init];
    resultVC.searchKey = @"你好";
    [self.navigationController pushViewController:resultVC animated:YES];
}
#pragma mark - 退出
-(void)searchTopBarQuitHandle
{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - 初始化导航栏
-(void)commit_navBar
{
    self.mhNavBar.hidden = YES;
    
    self.searchTopBar = [[SearchTopBar alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH, NavHeight)];
    self.searchTopBar.delegate = self;
    self.searchTopBar.quitLeft = NO;
    [self.view addSubview:self.searchTopBar];
}

@end
