//
//  ContactsListVC.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/17.
//  Copyright © 2018 mh. All rights reserved.
//

#import "ContactsListVC.h"
#import "ContactCell.h"
#import "UserChatVC.h"

@interface ContactsListVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ContactCellDelegate>

@property(nonatomic,strong)BaseTableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArr;
@property(nonatomic,strong)NSMutableArray * sectionTitleArr;

@property(nonatomic,strong)UITextField * searchTf;//搜索输入框

@end

@implementation ContactsListVC
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self commit_navbar];
    [self commit_tableview];
    [self requestData];
}
#pragma mark - 初始化列表
-(void)commit_tableview
{
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    self.sectionTitleArr = [NSMutableArray arrayWithCapacity:0];
    
    _tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, NavHeight, Screen_WIDTH, Screen_HEIGTH - NavHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorInset = UIEdgeInsetsMake(0, Width(15), 0, Width(15));
    _tableView.tableFooterView = [UIView new];
    _tableView.sectionIndexColor = [UIColor lightGrayColor];
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [_tableView mh_fixIphoneXBottomMargin];
    [self.view addSubview:_tableView];
    
    [self buildSearchBar];
}
-(void)buildSearchBar
{
    UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH, Width(60))];
    header.backgroundColor = [UIColor base_color];
    
    
    self.searchTf = [[UITextField alloc] initWithFrame:CGRectMake(Width(15), Width(10), Screen_WIDTH - Width(30), Width(40))];
    [self.searchTf addTarget:self action:@selector(textfileEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    self.searchTf.borderStyle = UITextBorderStyleNone;
    self.searchTf.backgroundColor = RGB(50, 50, 50);
    self.searchTf.layer.cornerRadius = 4;
    self.searchTf.layer.masksToBounds = YES;
    NSString * plhStr = @"霍建华进货价";
    self.searchTf.attributedPlaceholder = [plhStr attributedStr:FONT(15) textColor:[UIColor grayColor] lineSpace:0 keming:0];
    self.searchTf.textAlignment = NSTextAlignmentLeft;
    self.searchTf.font = FONT(15);
    self.searchTf.textColor = [UIColor whiteColor];
    self.searchTf.delegate = self;
    
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width(30), Width(40))];
    leftView.backgroundColor = [UIColor clearColor];
    UIImageView * left = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width(15), Width(40))];
    left.center = CGPointMake(Width(15), Width(40)/2);
    left.image = [UIImage imageNamed:@"search_gray"];
    left.contentMode = UIViewContentModeScaleAspectFit;
    left.clipsToBounds = YES;
    [leftView addSubview:left];
    self.searchTf.leftView = leftView;
    self.searchTf.leftViewMode = UITextFieldViewModeAlways;
    self.searchTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTf.returnKeyType = UIReturnKeySearch;
    [header addSubview:self.searchTf];
    
    self.tableView.tableHeaderView = header;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * arr = (NSArray *)self.dataArr[section];
    return arr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Width(15) + Width(40) + Width(15);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellid = @"xuanzelianxirenliebiaocellid";
    ContactCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    NSArray * arr = (NSArray *)self.dataArr[indexPath.section];
    ContactModel * model = (ContactModel *)arr[indexPath.row];
    cell.model = model;
    cell.delegate = self;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH, 30)];
    header.backgroundColor = [UIColor base_color];
    
    UILabel * lab = [UILabel labTextColor:[UIColor grayColor] font:FONT(14) aligent:NSTextAlignmentLeft];
    lab.frame = CGRectMake(Width(15), 0, Screen_WIDTH - Width(30), 30);
    lab.numberOfLines = 1;
    [header addSubview:lab];
    if (section == 0) {
        lab.text = @"好友";
    }else if (section == 1) {
        lab.text = @"全部关注";
    }else{
        lab.text = self.sectionTitleArr[section];
    }
    
    return header;
}
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionTitleArr;
}
#pragma mark - 点击键盘上的【搜索按钮】
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField.text length] > 0) {
        //搜索
        
        return YES;
    }
    return NO;
}
#pragma mark - 输入内容变更
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
}
-(void)requestData
{
    NSArray * arr = [ContactModel contactList];
    for (int i = 0; i < arr.count; i ++) {
        NSDictionary * dic = (NSDictionary *)arr[i];
        NSString * title = dic[@"sectionTitle"];
        [self.sectionTitleArr addObject:title];
        [self.dataArr addObject:dic[@"userArr"]];
    }
    [self.tableView reloadData];
}
#pragma mark - 跳转 聊天
-(void)contactCellHandleChat:(ContactModel *)contactModel
{
    UserChatVC * vc = [[UserChatVC alloc] init];
    vc.chatName = contactModel.userName;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 初始化导航栏
-(void)commit_navbar
{
    self.mhNavBar.hidden = NO;
    [self mh_setNeedBackItemWithTitle:@"选择联系人"];
    [self mh_setNavBottomlineHiden:NO];
}
-(void)mh_navBackItem_click
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
