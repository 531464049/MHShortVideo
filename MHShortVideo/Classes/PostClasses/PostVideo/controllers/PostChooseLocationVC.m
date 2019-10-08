//
//  PostChooseLocationVC.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/3.
//  Copyright © 2018 mh. All rights reserved.
//

#import "PostChooseLocationVC.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

#import "AddLocationCell.h"

@interface PostChooseLocationVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,AMapSearchDelegate>

@property(nonatomic,strong)UITextField * searchTf;//搜索输入框
@property(nonatomic,strong)BaseTableView * tableView;

@property(nonatomic,assign)BOOL isSearchList;//是否是搜索列表(默认位置列表/搜索列表)

@property(nonatomic,strong)NSMutableArray * locationDataArr;//位置数据源
@property(nonatomic,strong)NSMutableArray * searchDataArr;//搜索结果数据源

@property(nonatomic,copy)NSString * searchKey;//当前搜索关键词
@property(nonatomic,assign)NSInteger nommalPage;//普通-页码
@property(nonatomic,assign)NSInteger searchPage;//搜索-页码

@property(nonatomic,strong)AMapSearchAPI * search;
@property(nonatomic,strong)AMapPOIAroundSearchRequest * request;

@end

@implementation PostChooseLocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isSearchList = NO;
    self.searchKey = @"";
    self.nommalPage = 1;
    self.searchPage = 1;
    
    [self commit_navBar];
    [self commit_textField];
    [self commit_tableview];
    [self requestLocationListKeyWord:nil page:1];
}
#pragma mark - 初始化搜索框
-(void)commit_textField
{
    self.searchTf = [[UITextField alloc] init];
    self.searchTf.frame = CGRectMake(Width(15), NavHeight + Width(5), Screen_WIDTH - Width(30), Width(38));
    [self.searchTf addTarget:self action:@selector(textfileEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    self.searchTf.borderStyle = UITextBorderStyleNone;
    self.searchTf.backgroundColor = RGB(50, 50, 50);
    self.searchTf.layer.cornerRadius = 4;
    self.searchTf.layer.masksToBounds = YES;
    NSString * plhStr = @"输入要@的好友昵称";
    self.searchTf.attributedPlaceholder = [plhStr attributedStr:FONT(15) textColor:[UIColor grayColor] lineSpace:0 keming:0];
    self.searchTf.textAlignment = NSTextAlignmentLeft;
    self.searchTf.font = FONT(15);
    self.searchTf.textColor = [UIColor whiteColor];
    self.searchTf.delegate = self;
    
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width(30), Width(38))];
    leftView.backgroundColor = [UIColor clearColor];
    UIImageView * left = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width(30), Width(38))];
    left.center = CGPointMake(Width(15), Width(38)/2);
    left.image = [UIImage imageNamed:@"search_gray"];
    left.contentMode = UIViewContentModeScaleAspectFit;
    left.clipsToBounds = YES;
    [leftView addSubview:left];
    self.searchTf.leftView = leftView;
    self.searchTf.leftViewMode = UITextFieldViewModeAlways;
    self.searchTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTf.returnKeyType = UIReturnKeySearch;
    
    [self.view addSubview:self.searchTf];
}
-(void)commit_tableview
{
    self.locationDataArr = [NSMutableArray arrayWithCapacity:0];
    if (AppInfo.sharedInstance.userCity.length > 0) {
        LocationModel * model = [LocationModel new];
        model.isUserCity = YES;
        model.locationNmae = AppInfo.sharedInstance.userCity;
        [self.locationDataArr addObject:model];
    }
    self.searchDataArr = [NSMutableArray arrayWithCapacity:0];
    
    _tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchTf.frame) + Width(10), self.view.frame.size.width, Screen_HEIGTH - (CGRectGetMaxY(self.searchTf.frame) + Width(10))) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorInset = UIEdgeInsetsMake(0, Width(16), 0, Width(16));
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    [_tableView mh_fixIphoneXBottomMargin];
    
    self.tableView.mj_footer = [MHMjFooter footerWithRefreshingTarget:self refreshingAction:@selector(footer_refresh)];
    
    [self buildTableViewHeader];
}
-(void)buildTableViewHeader
{
    self.tableView.tableHeaderView = nil;
    if (self.isSearchList) {
        return;
    }
    UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH, Width(35))];
    header.backgroundColor = [UIColor clearColor];
    
    UILabel * lab = [UILabel labTextColor:RGB(118, 118, 121) font:FONT(14) aligent:NSTextAlignmentLeft];
    lab.frame = CGRectMake(Width(15), 0, 150, Width(35));
    lab.text = @"不显示我的位置";
    [header addSubview:lab];
    
    UIButton * headerBtn = [UIButton buttonWithType:0];
    headerBtn.frame = header.bounds;
    [headerBtn addTarget:self action:@selector(notShowWyLocation) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:headerBtn];
    
    self.tableView.tableHeaderView = header;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isSearchList) {
        return self.searchDataArr.count;
    }
    return self.locationDataArr.count;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Width(67);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellid = @"tianjiaweizhiliebiaocellid";
    AddLocationCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[AddLocationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    if (self.isSearchList) {
        LocationModel * model = (LocationModel *)self.searchDataArr[indexPath.row];
        cell.model = model;
    }else{
        LocationModel * model = (LocationModel *)self.locationDataArr[indexPath.row];
        cell.model = model;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString * locationName = @"";
    if (self.isSearchList) {
        LocationModel * model = (LocationModel *)self.searchDataArr[indexPath.row];
        locationName = model.locationNmae;
    }else{
        LocationModel * model = (LocationModel *)self.locationDataArr[indexPath.row];
        locationName = model.locationNmae;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(postChooseLocationCallBack:)]) {
        [self.delegate postChooseLocationCallBack:locationName];
    }
    
    [self cancleItemClick];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
#pragma mark - 刷新
-(void)footer_refresh
{
    if (self.isSearchList) {
        [self requestLocationListKeyWord:self.searchKey page:self.searchPage];
    }else{
        [self requestLocationListKeyWord:nil page:self.nommalPage];
    }
}
#pragma mark - 请求数据
-(void)requestLocationListKeyWord:(NSString *)keyWord page:(NSInteger)page
{
    if (!self.search) {
        self.search = [[AMapSearchAPI alloc] init];
        self.search.delegate = self;
    }
    if (!self.request) {
        self.request = [[AMapPOIAroundSearchRequest alloc] init];
        self.request.location = [AMapGeoPoint locationWithLatitude:AppInfo.sharedInstance.userLatitude longitude:AppInfo.sharedInstance.userLongitude];
        self.request.sortrule = 0;//按照距离排序
        self.request.requireExtension = YES;
        self.request.offset = 10;
    }
    if (keyWord && keyWord.length > 0) {
        self.request.keywords = keyWord;
    }else{
        self.request.keywords = @"";
    }
    self.request.page = page;

    [self.search AMapPOIAroundSearch:self.request];
}
#pragma mark - POI 搜索回调
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0) {
        return;
    }
    NSMutableArray * mArr = [NSMutableArray arrayWithCapacity:0];
    for (AMapPOI * poi in response.pois) {
        LocationModel * model = [LocationModel new];
        model.locationNmae = poi.name;
        model.locationDetail = poi.address;
        model.distance = poi.distance;
        
        if (self.isSearchList) {
            model.searchKey = self.searchKey;
        }else{
            model.searchKey = nil;
        }
        
        [mArr addObject:model];
    }
    [self.tableView.mj_footer endRefreshing];
    if (self.isSearchList) {
        if (self.searchPage == 1) {
            [self.searchDataArr removeAllObjects];
        }
        self.searchPage += 1;
        [self.searchDataArr addObjectsFromArray:mArr];
        [self.tableView reloadData];
    }else{
        self.nommalPage += 1;
        [self.locationDataArr addObjectsFromArray:mArr];
        [self.tableView reloadData];
    }
}
#pragma mark - 关键字搜索
-(void)searchLocation:(NSString *)searhKey
{
    if ([self.searchKey isEqualToString:searhKey]) {
        return;
    }
    self.searchKey = searhKey;
    self.searchPage = 1;
    [self requestLocationListKeyWord:searhKey page:1];
}
#pragma mark - 点击键盘上的【搜索按钮】
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField.text length] > 0) {
        return YES;
    }
    return NO;
}
-(void)textfileEditingChanged:(UITextField *)textfield
{
    UITextRange *selectedRange = [textfield markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textfield positionFromPosition:selectedRange.start offset:0];
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    textfield.rightView.hidden = !textfield.hasText;
    if (textfield.hasText) {
        self.isSearchList = YES;
        [self buildTableViewHeader];
        [self searchLocation:textfield.text];
    }else{
        //显示默认位置列表
        self.isSearchList = NO;
        [self buildTableViewHeader];
        [self.tableView reloadData];
        self.searchKey = @"";
        self.searchPage = 1;
        [self.searchDataArr removeAllObjects];
    }
}
#pragma mark - 不显示我的位置
-(void)notShowWyLocation
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(postChooseLocationCallBack:)]) {
        [self.delegate postChooseLocationCallBack:nil];
    }
    [self cancleItemClick];
}
#pragma mark - 初始化导航栏
-(void)commit_navBar
{
    self.mhNavBar.hidden = NO;
    [self mh_setTitle:@"添加位置"];
    [self mh_setNavBottomlineHiden:YES];
    
    UIButton * btn = [UIButton buttonWithType:0];
    btn.frame = CGRectMake(0, 0, 40, 40);
    btn.center = CGPointMake(40/2, K_StatusHeight + (NavHeight - K_StatusHeight)/2);
    [btn setImage:[UIImage imageNamed:@"common_close"] forState:0];
    [btn addTarget:self action:@selector(cancleItemClick) forControlEvents:UIControlEventTouchUpInside];
    [self.mhNavBar addSubview:btn];
}
-(void)cancleItemClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
