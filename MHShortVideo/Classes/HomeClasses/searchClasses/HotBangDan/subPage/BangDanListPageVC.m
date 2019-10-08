//
//  BangDanListPageVC.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/11.
//  Copyright © 2018 mh. All rights reserved.
//

#import "BangDanListPageVC.h"
#import "BDHotSearchCell.h"
#import "BDHotVideoCell.h"

@interface BangDanListPageVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,assign)BOOL isFirstTime;
@property(nonatomic,strong)BaseTableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation BangDanListPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)curentViewDidLoad
{
    if (!_isFirstTime) {
        _isFirstTime = YES;
        self.dataArr = [NSMutableArray arrayWithCapacity:0];
        [self buildTableview];
        [self requestData];
    }
}
-(void)buildTableview
{
    _tableView = [[BaseTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.listType == BanDanListTypeHotSearch) {
        return _dataArr.count;
    }
    return 20;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.listType == BanDanListTypeHotSearch) {
        return Width(50);
    }
    return Width(103);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellid = @"bangdanliebiaoremencellida";
    if (self.listType == BanDanListTypeHotSearch) {
        BDHotSearchCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[BDHotSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        BangDanModel * model = (BangDanModel *)self.dataArr[indexPath.row];
        cell.model = model;
        return cell;
    }else{
        BDHotVideoCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[BDHotVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.bdIndex = indexPath.row + 1;
        return cell;
    }
}
-(void)requestData
{
    NSArray * arr = [BangDanModel random_dataWithType:self.listType];
    [self.dataArr addObjectsFromArray:arr];
    [self.tableView reloadData];
}
-(void)setCanScroll:(BOOL)canScroll
{
    _canScroll = canScroll;
    if (!canScroll) {
        _tableView.contentOffset = CGPointZero;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!_canScroll) {
        _tableView.contentOffset = CGPointZero;
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(BangDanListPageDidScroll:)]) {
            [self.delegate BangDanListPageDidScroll:scrollView];
        }
    }
}
@end
