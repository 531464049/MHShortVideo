//
//  SRCompositeListVC.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/11.
//  Copyright © 2018 mh. All rights reserved.
//

#import "SRCompositeListVC.h"
#import "SRCompositeCell.h"
@interface SRCompositeListVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)BaseTableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation SRCompositeListVC
-(void)curentViewDidLoad
{
    if (!self.isFirstTimeShow) {
        self.isFirstTimeShow = YES;
        [self buildTableview];
        [self requestDataWithPage:1];
    }
}
-(void)buildTableview
{
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    
    _tableView = [[BaseTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorInset = UIEdgeInsetsMake(0, Width(15), 0, Width(15));
    _tableView.tableFooterView = [UIView new];
    [_tableView mh_fixIphoneXBottomMargin];
    [self.view addSubview:_tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SRCompositeModel * model = (SRCompositeModel *)self.dataArr[indexPath.row];
    return model.totleHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellid = @"sousuojieguououououoiu";

    SRCompositeCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[SRCompositeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    SRCompositeModel * model = (SRCompositeModel *)self.dataArr[indexPath.row];
    cell.model = model;
    return cell;
}
-(void)requestDataWithPage:(NSInteger)page
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray * arr = [SRCompositeModel randomModels];
        [self.dataArr addObjectsFromArray:arr];
        [self.tableView reloadData];
    });
}
- (void)viewDidLoad {
    [super viewDidLoad];
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
