//
//  SRUserListVC.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/11.
//  Copyright © 2018 mh. All rights reserved.
//

#import "SRUserListVC.h"
#import "SRUserCell.h"

@interface SRUserListVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)BaseTableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArr;


@end

@implementation SRUserListVC
-(void)curentViewDidLoad
{
    if (!self.isFirstTimeShow) {
        self.isFirstTimeShow = YES;
        [self buildTableview];
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
    return 20;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Width(85);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellid = @"SRUserCellSRUserCellSRUserCellSRUserCell";
    
    SRUserCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[SRUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.cellIndex = indexPath.row;
    return cell;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
