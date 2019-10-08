//
//  UserDynamicPage.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/19.
//  Copyright © 2018 mh. All rights reserved.
//

#import "UserDynamicPage.h"
#import "FocusDynamicCell.h"

@interface UserDynamicPage ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,assign)BOOL isFirstTime;
@property(nonatomic,strong)BaseTableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation UserDynamicPage

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)curentViewDidLoad
{
    if (!_isFirstTime) {
        _isFirstTime = YES;
        self.dataArr = [NSMutableArray arrayWithCapacity:0];
        [self buildTableview];
        [self requestDataWithPage:1];
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
    if (!self.isOtherUser) {
        UIEdgeInsets insets = _tableView.contentInset;
        _tableView.contentInset = UIEdgeInsetsMake(insets.top, insets.left, insets.bottom + TabBarHeight, insets.right);
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FocusDynamicModel * model = (FocusDynamicModel *)self.dataArr[indexPath.row];
    return model.totleHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellid = @"yonghudongtailiebiaocellldkdlskd";
    
    FocusDynamicCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[FocusDynamicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    FocusDynamicModel * model = (FocusDynamicModel *)self.dataArr[indexPath.row];
    cell.model = model;
    cell.isSectionLastCell = NO;
    return cell;
}
-(void)requestDataWithPage:(NSInteger)page
{
    NSArray * arr = [FocusDynamicModel randomModels];
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
        if (self.delegate && [self.delegate respondsToSelector:@selector(childScrollViewDidScroll:)]) {
            [self.delegate childScrollViewDidScroll:scrollView];
        }
    }
}
@end
