//
//  FourListVC.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/14.
//  Copyright © 2018 mh. All rights reserved.
//

#import "FourListVC.h"
#import "MyFanceCell.h"
#import "ZanMeCell.h"
#import "AtMeCell.h"
#import "PingLunMeCell.h"

@interface FourListVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)BaseTableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation FourListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commit_navBar];
    [self buildTableview];
    [self requestData];
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
    switch (self.type) {
        case HomeMsgFourTypeFance:
        {
            return Width(10) + Width(50) + Width(30);
        }
            break;
        case HomeMsgFourTypeZanMe:
        {
            return Width(10) + Width(50) + Width(30);
        }
            break;
        case HomeMsgFourTypePingLunMe:
        {
            PingLunMeModel * model = (PingLunMeModel *)self.dataArr[indexPath.row];
            return model.cellHeight;
        }
            break;
        default:
            return 0.1;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.type) {
        case HomeMsgFourTypeFance:
        {
            //粉丝
            static NSString * cellid = @"sigeliebaofensi";
            MyFanceCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[MyFanceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            cell.model = (MyFanceModel *)self.dataArr[indexPath.row];
            return cell;
        }
            break;
        case HomeMsgFourTypeZanMe:
        {
            //赞
            static NSString * cellid = @"sigeliebiao_zancellid";
            ZanMeCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[ZanMeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            cell.model = (ZanMeModel *)self.dataArr[indexPath.row];
            return cell;
        }
            break;
        case HomeMsgFourTypePingLunMe:
        {
            //评论
            static NSString * cellid = @"sigeliebiaopingluncellid";
            PingLunMeCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[PingLunMeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            cell.model = (PingLunMeModel *)self.dataArr[indexPath.row];
            return cell;
        }
            break;
        default:
            break;
    }
    static NSString * cellid = @"sigeliebiaoyecellidsa";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
-(void)requestData
{
    NSArray * arr = [FoutListModel testModels:self.type];
    [self.dataArr addObjectsFromArray:arr];
    [self.tableView reloadData];
}
#pragma mark - 初始化导航栏
-(void)commit_navBar
{
    NSArray * titleArr = @[@"粉丝",@"赞",@"@我的",@"评论"];

    self.mhNavBar.hidden = NO;
    [self mh_setNeedBackItemWithTitle:titleArr[self.type]];
    [self mh_setNavBottomlineHiden:NO];
}

@end
