//
//  FocusHomePageVC.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/30.
//  Copyright © 2018 mh. All rights reserved.
//

#import "FocusHomePageVC.h"
#import "FocusDynamicCell.h"
#import "FDGuessLikeUser.h"

@interface FocusHomePageVC ()<UITableViewDelegate,UITableViewDataSource,FDGuessLikeDelegate>

@property(nonatomic,strong)BaseTableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArr;

@property(nonatomic,strong)FocusDynamicCell * curentPlayCell;//当前播放的cell

@property(nonatomic,strong)FDGuessLikeUser * guessLikeView;//猜你喜欢view

@end

@implementation FocusHomePageVC
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    FocusDynamicCell * bastCell = [self findScrolEndBastPlayCell];
    if (bastCell) {
        self.curentPlayCell = bastCell;
        [self.curentPlayCell play];
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MHCellAutoPlayer.sharedPlayer clearAllPlayInfo];
    self.curentPlayCell = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self buildTableview];
    [self requestDataWithPage:1];
}
-(void)buildTableview
{
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    
    _tableView = [[BaseTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * arr = (NSArray *)self.dataArr[section];
    return arr.count;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * arr = (NSArray *)self.dataArr[indexPath.section];
    FocusDynamicModel * model = (FocusDynamicModel *)arr[indexPath.row];
    return model.totleHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellid = @"guanzhuliebaocelklid";
    
    FocusDynamicCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[FocusDynamicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    NSArray * arr = (NSArray *)self.dataArr[indexPath.section];
    FocusDynamicModel * model = (FocusDynamicModel *)arr[indexPath.row];
    cell.model = model;
    cell.isSectionLastCell = indexPath.row == arr.count-1;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    }
    return TabBarHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CGFloat footerHeight = 0.1;
    if (section == 0) {
        footerHeight = 0.1;
    }else{
        footerHeight = TabBarHeight;
    }
    UIView * footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH, footerHeight)];
    footer.backgroundColor = [UIColor clearColor];
    return footer;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return K_StatusHeight;
    }
    return Width(245);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH, K_StatusHeight)];
        header.backgroundColor = [UIColor clearColor];
        return header;
    }
    if (!_guessLikeView) {
        _guessLikeView = [[FDGuessLikeUser alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH, Width(245))];
        _guessLikeView.delegate = self;
    }
    return _guessLikeView;
}
#pragma mark - 猜你喜欢-用户点击
-(void)fdGuessLikeUserHandleSelectedUser:(NSString *)userName
{
    
}
#pragma mark - 查看更多
-(void)fdGuessLikeUserHandleCheckMore
{
    
}
-(void)requestDataWithPage:(NSInteger)page
{
    NSArray * arr = [FocusDynamicModel randomModels];
    NSArray * arr1 = [arr subarrayWithRange:NSMakeRange(0, 5)];
    NSArray * arr2 = [arr subarrayWithRange:NSMakeRange(5, arr.count - 5)];
    
    [self.dataArr addObject:arr1];
    [self.dataArr addObject:arr2];
    [self.tableView reloadData];
}
#pragma mark - 处理快速滑动时player
-(void)handleTableViewScroll
{
    if (!self.curentPlayCell) {
        return;
    }
    if (![self curentPlayingCellIsVisiable]) {
        //当前播放cell取消播放
        [MHCellAutoPlayer.sharedPlayer clearAllPlayInfo];
        self.curentPlayCell = nil;
    }
}
#pragma mark - 滑动结束-找出最适合播放的cell
-(void)handleScrollStop
{
    FocusDynamicCell * bastCell = [self findScrolEndBastPlayCell];
    if (self.curentPlayCell.hash != bastCell.hash) {
        self.curentPlayCell = bastCell;
        [self.curentPlayCell play];
    }
}
#pragma mark - 寻找最适合播放的cell
-(FocusDynamicCell *)findScrolEndBastPlayCell
{
    NSArray * visibleRows = [_tableView indexPathsForVisibleRows];
    if (!visibleRows || visibleRows.count == 0) {
        return nil;
    }
    FocusDynamicCell * bastCell = nil;
    //计算所有当前显示cell距屏幕中心点的距离
    NSMutableArray * centerArr = [NSMutableArray arrayWithCapacity:0];
    for (NSIndexPath * indexPath in visibleRows) {
        FocusDynamicCell * cell = (FocusDynamicCell *)[_tableView cellForRowAtIndexPath:indexPath];
        CGFloat margin = [self cellCenterToScreenCenter:cell];
        [centerArr addObject:@(margin)];
    }
    //找出距离屏幕中心 最近的一个
    NSInteger minIndex = 0;
    for (int i = 0; i < centerArr.count; i ++) {
        CGFloat margin = [centerArr[i] floatValue];
        if (i != 0) {
            CGFloat minMargin = [centerArr[minIndex] floatValue];
            if (minMargin > margin) {
                minIndex = i;
            }
        }
    }
    bastCell = (FocusDynamicCell *)[_tableView cellForRowAtIndexPath:visibleRows[minIndex]];
    return bastCell;
}
#pragma mark - 计算cell中线点距屏幕中心点距离
-(CGFloat)cellCenterToScreenCenter:(FocusDynamicCell *)cell
{
    CGPoint cellPoint = cell.frame.origin;
    CGPoint topCoorPoint = [cell.superview convertPoint:cellPoint toView:nil];
    CGFloat centerY = topCoorPoint.y + cell.bounds.size.height/2;
    CGFloat margin = fabs(centerY - (Screen_HEIGTH/2));
    return margin;
}
#pragma mark - 当前播放cell是否还存在屏幕中
-(BOOL)curentPlayingCellIsVisiable
{
    //当前cell中心点 距离屏幕中心点 距离
    CGFloat cellCenter = [self cellCenterToScreenCenter:self.curentPlayCell];
    if (cellCenter < Screen_WIDTH/2) {
        return YES;
    }
    
    CGRect windowRect = [UIScreen mainScreen].bounds;
    CGPoint cellPoint = self.curentPlayCell.frame.origin;
    CGPoint topCoorPoint = [self.curentPlayCell.superview convertPoint:cellPoint toView:nil];
    BOOL topIsContain = CGRectContainsPoint(windowRect, topCoorPoint);
    CGFloat cellDownY = cellPoint.y + self.curentPlayCell.bounds.size.height;
    CGPoint cellBottomPoint = CGPointMake(cellPoint.x, cellDownY);
    CGPoint bottomCoorPoint = [self.curentPlayCell.superview convertPoint:cellBottomPoint toView:nil];
    BOOL bottomIsContain = CGRectContainsPoint(windowRect, bottomCoorPoint);
    if (topIsContain || bottomIsContain) {
        return YES;
    }else{
        return NO;
    }
}
#pragma mark - 视频播放处理
#pragma mark - 松手时已经静止, 只会调用scrollViewDidEndDragging
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate == NO){
        [self handleScrollStop];
    }
}
#pragma mark - 松手时还在运动, 先调用scrollViewDidEndDragging, 再调用scrollViewDidEndDecelerating
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self handleScrollStop];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self handleTableViewScroll];
}
@end
