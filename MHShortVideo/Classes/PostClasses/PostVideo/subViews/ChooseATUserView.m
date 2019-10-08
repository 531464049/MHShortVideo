//
//  ChooseATUserView.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/6.
//  Copyright © 2018 mh. All rights reserved.
//

#import "ChooseATUserView.h"
#import "ATUserCell.h"

@interface ChooseATUserView ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)chooseATUserCallBack callBack;

@property(nonatomic,strong)UITextField * searchTf;//搜索输入框
@property(nonatomic,strong)BaseTableView * tableView;

@property(nonatomic,assign)BOOL isFriendList;//是否是好友列表(好友列表/搜索列表)

@property(nonatomic,strong)NSMutableArray * friendDataArr;//好友数据源
@property(nonatomic,strong)NSMutableArray * searchDataArr;//搜索结果数据源

@property(nonatomic,copy)NSString * searchKey;//当前搜索关键词

@end

@implementation ChooseATUserView

-(instancetype)initWithFrame:(CGRect)frame callBack:(chooseATUserCallBack)callBack
{
    self = [super initWithFrame:frame];
    if (self) {
        //毛玻璃
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = self.bounds;
        [self addSubview:effectView];
        
        self.isFriendList = YES;
        self.callBack = callBack;
        
        [self commit_navBar];
        [self commit_textField];
        [self commit_tableview];
        [self requestFriendList];
        
        [self view_Show:YES];
    }
    return self;
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
    
    [self addSubview:self.searchTf];
}
#pragma mark - 初始化tableview
-(void)commit_tableview
{
    self.friendDataArr = [NSMutableArray arrayWithCapacity:0];
    self.searchDataArr = [NSMutableArray arrayWithCapacity:0];
    
    _tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchTf.frame) + Width(10), self.frame.size.width, Screen_HEIGTH - (CGRectGetMaxY(self.searchTf.frame) + Width(10))) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorInset = UIEdgeInsetsMake(0, Width(16), 0, Width(16));
    _tableView.tableFooterView = [UIView new];
    [self addSubview:_tableView];
    [_tableView mh_fixIphoneXBottomMargin];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isFriendList) {
        return 2;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isFriendList) {
        NSArray * sectionArr = (NSArray *)self.friendDataArr[section];
        return sectionArr.count;
    }
    return self.searchDataArr.count;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Width(75);
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.isFriendList && section == 1) {
        UILabel * footerlab = [UILabel labTextColor:RGB(118, 118, 121) font:FONT(14) aligent:NSTextAlignmentCenter];
        footerlab.text = @"暂时没有更多了";
        footerlab.frame = CGRectMake(0, 0, Screen_WIDTH, Width(50));
        return footerlab;
    }else{
        UIView * footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0.1)];
        footer.backgroundColor = [UIColor clearColor];
        return footer;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.isFriendList && section == 1) {
        return Width(50);
    }
    return 0.1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.isFriendList) {
        UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, Width(35))];
        header.backgroundColor = [UIColor clearColor];
        
        UILabel * lab = [UILabel labTextColor:RGB(118, 118, 121) font:FONT(14) aligent:NSTextAlignmentLeft];
        lab.frame = CGRectMake(Width(15), 0, 150, Width(35));
        [header addSubview:lab];
        
        if (section == 0) {
            lab.text = @"最近联系人";
        }else{
            lab.text = @"你关注的人";
        }
        
        return header;
    }else{
        UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0.1)];
        header.backgroundColor = [UIColor clearColor];
        return header;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.isFriendList) {
        return Width(35);
    }
    return 0.1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellid = @"xinwenliebiaocelleldldi";
    ATUserCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ATUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    if (self.isFriendList) {
        NSArray * arr = (NSArray *)self.friendDataArr[indexPath.section];
        UserModel * model = (UserModel *)arr[indexPath.row];
        cell.model = model;
    }else{
        UserModel * model = (UserModel *)self.searchDataArr[indexPath.row];
        cell.model = model;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UserModel * selectedModel;
    if (self.isFriendList) {
        NSArray * arr = (NSArray *)self.friendDataArr[indexPath.section];
        selectedModel = (UserModel *)arr[indexPath.row];
    }else{
        selectedModel = (UserModel *)self.searchDataArr[indexPath.row];
    }
    if (self.callBack) {
        self.callBack(selectedModel);
    }
    [self cancleItemClick];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self endEditing:YES];
}
#pragma mark - 获取好友列表
-(void)requestFriendList
{
    //最近联系人
    NSArray * arr1 = @[[UserModel randomeUser]];
    [self.friendDataArr addObject:arr1];
    
    NSMutableArray * arr2 = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 10; i ++) {
        [arr2 addObject:[UserModel randomeUser]];
    }
    [self.friendDataArr addObject:arr2];
    [self.tableView reloadData];
}
-(void)searchUser:(NSString *)searchKey
{
    if ([self.searchKey isEqualToString:searchKey]) {
        return;
    }
    self.searchKey = searchKey;
    DLog(@"搜索 - %@",searchKey);
    NSMutableArray * arrrr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 12; i ++) {
        [arrrr addObject:[UserModel randomeUser]];
    }
    [self.searchDataArr removeAllObjects];
    [self.searchDataArr addObjectsFromArray:arrrr];
    [self.tableView reloadData];
    
    self.tableView.mj_footer = [MHMjFooter footerWithRefreshingTarget:self refreshingAction:@selector(searchFooterRefresh)];
}
#pragma mark - 搜索 上拉加载
-(void)searchFooterRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_footer endRefreshing];
        NSMutableArray * arrrr = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < 12; i ++) {
            [arrrr addObject:[UserModel randomeUser]];
        }
        [self.searchDataArr addObjectsFromArray:arrrr];
        [self.tableView reloadData];
    });
    
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
        self.isFriendList = NO;
        [self searchUser:textfield.text];
    }else{
        //显示好友列表
        self.isFriendList = YES;
        [self.tableView reloadData];
        self.searchKey = @"";
        self.tableView.mj_footer = nil;
    }
}
-(void)view_Show:(BOOL)show
{
    CGRect rect = self.frame;
    if (show) {
        rect.origin.y = 0;
    }else{
        rect.origin.y = self.frame.size.height;
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = rect;
    } completion:^(BOOL finished) {
        if (!show) {
            [self removeFromSuperview];
        }
    }];
}
#pragma mark - 初始化导航栏
-(void)commit_navBar
{
    UIView * NavBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH, NavHeight)];
    [self addSubview:NavBar];

    UILabel * lab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(16) aligent:NSTextAlignmentCenter];
    lab.numberOfLines = 1;
    lab.text = @"召唤好友";
    lab.frame = CGRectMake(0, 0, Screen_WIDTH/2, NavHeight - K_StatusHeight);
    lab.center = CGPointMake(Screen_WIDTH/2, K_StatusHeight + (NavHeight - K_StatusHeight)/2);
    [NavBar addSubview:lab];

    UIButton * btn = [UIButton buttonWithType:0];
    btn.frame = CGRectMake(0, 0, 40, 40);
    btn.center = CGPointMake(40/2, K_StatusHeight + (NavHeight - K_StatusHeight)/2);
    [btn setImage:[UIImage imageNamed:@"common_close"] forState:0];
    [btn addTarget:self action:@selector(cancleItemClick) forControlEvents:UIControlEventTouchUpInside];
    [NavBar addSubview:btn];
}
-(void)cancleItemClick
{
    [self view_Show:NO];
}
+(void)showChooseATUserWithCallBack:(chooseATUserCallBack)callBack
{
    UIWindow * keywindow = [UIApplication sharedApplication].keyWindow;
    if (!keywindow) {
        keywindow = [[UIApplication sharedApplication].windows firstObject];
    }
    
    ChooseATUserView * view = [[ChooseATUserView alloc] initWithFrame:CGRectMake(0, Screen_HEIGTH, Screen_WIDTH, Screen_HEIGTH) callBack:callBack];
    [keywindow addSubview:view];
}

@end
