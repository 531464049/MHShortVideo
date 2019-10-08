//
//  SearchTopBar.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/10.
//  Copyright © 2018 mh. All rights reserved.
//

#import "SearchTopBar.h"
#import "SearchSameCell.h"
#import "SearchRecodeCell.h"

@interface SearchTopBar ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,SearchRecodeCellDelegate>
{
    BOOL _firstTimeLayout;//是否是第一次约束
}
@property(nonatomic,strong)UITextField * searchTf;//搜索输入框
@property(nonatomic,strong)UIButton * searchTapBtn;//输入框点击遮罩
@property(nonatomic,strong)UIButton * quitBtn;//退出按钮
@property(nonatomic,strong)UIButton * cancleBtn;//取消输入按钮

@property(nonatomic,strong)BaseTableView * tableView;
@property(nonatomic,strong)NSMutableArray * recodeArr;//历史记录数据
@property(nonatomic,strong)NSMutableArray * searchDataArr;//相似搜索数据
@property(nonatomic,assign)BOOL isShowAllRecode;//是否显示全部搜索记录

@end

@implementation SearchTopBar

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor base_color];
        _firstTimeLayout = YES;
        [self commit_subviews];
    }
    return self;
}
-(void)commit_subviews
{
    self.quitBtn = [UIButton buttonWithType:0];
    [self.quitBtn addTarget:self action:@selector(quitItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.quitBtn.alpha = 1.0;
    [self addSubview:self.quitBtn];
    
    CGFloat searchheight = self.frame.size.height - K_StatusHeight - Width(3)*2;
    self.searchTf = [[UITextField alloc] init];
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
    
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width(30), searchheight)];
    leftView.backgroundColor = [UIColor clearColor];
    UIImageView * left = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width(15), searchheight)];
    left.center = CGPointMake(Width(15), searchheight/2);
    left.image = [UIImage imageNamed:@"search_gray"];
    left.contentMode = UIViewContentModeScaleAspectFit;
    left.clipsToBounds = YES;
    [leftView addSubview:left];
    self.searchTf.leftView = leftView;
    self.searchTf.leftViewMode = UITextFieldViewModeAlways;
    self.searchTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTf.returnKeyType = UIReturnKeySearch;
    [self addSubview:self.searchTf];
    
    self.searchTapBtn = [UIButton buttonWithType:0];
    [self.searchTapBtn addTarget:self action:@selector(tapToSearch) forControlEvents:UIControlEventTouchUpInside];
    [self.searchTf addSubview:self.searchTapBtn];
    
    self.cancleBtn = [UIButton buttonWithType:0];
    [self.cancleBtn setTitle:@"取消" forState:0];
    [self.cancleBtn setTitleColor:[UIColor base_yellow_color] forState:0];
    self.cancleBtn.titleLabel.font = FONT(14);
    self.cancleBtn.alpha = 0.0;
    [self.cancleBtn addTarget:self action:@selector(cancleInput) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancleBtn];
    
    [self bringSubviewToFront:self.searchTf];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!_firstTimeLayout) {
        return;
    }
    _firstTimeLayout = NO;
    
    CGFloat searchheight = self.frame.size.height - K_StatusHeight - Width(3)*2;
    if (self.quitLeft) {
        self.quitBtn.frame = CGRectMake(0, K_StatusHeight, Width(45), self.frame.size.height - K_StatusHeight);
        [self.quitBtn setImage:[UIImage imageNamed:@"common_back"] forState:0];
        self.searchTf.frame = CGRectMake(Width(45), K_StatusHeight + Width(3), Screen_WIDTH - Width(45) - Width(15), searchheight);
        self.searchTapBtn.frame = self.searchTf.bounds;
    }else{
        self.searchTf.frame = CGRectMake(Width(15), K_StatusHeight + Width(3), Screen_WIDTH - Width(45) - Width(15), searchheight);
        self.searchTapBtn.frame = self.searchTf.bounds;
        self.quitBtn.frame = CGRectMake(Screen_WIDTH - Width(45), K_StatusHeight, Width(45), self.frame.size.height - K_StatusHeight);
        [self.quitBtn setImage:[UIImage imageNamed:@"common_next"] forState:0];
    }
    
    self.cancleBtn.frame = CGRectMake(Screen_WIDTH - Width(60), K_StatusHeight, Width(60), self.frame.size.height - K_StatusHeight);
    
    if (self.searchKey.length > 0) {
        self.searchTf.text = self.searchKey;
    }
}
#pragma mark - 输入框动画 开始/结束输入
-(void)searchTFHidenAnimation
{
    CGRect tfRect = self.searchTf.frame;
    tfRect.origin.x = self.quitLeft ? Width(45) : Width(15);
    tfRect.size.width = Screen_WIDTH - Width(45) - Width(15);
    [UIView animateWithDuration:0.3 animations:^{
        self.searchTf.frame = tfRect;
        self.quitBtn.alpha = 1.0;
        self.cancleBtn.alpha = 0.0;
    } completion:^(BOOL finished) {
    }];
}
-(void)searchTFShowAnimation
{
    CGRect tfRect = self.searchTf.frame;
    tfRect.origin.x = Width(15);
    tfRect.size.width = Screen_WIDTH - Width(15) - Width(60);
    [UIView animateWithDuration:0.3 animations:^{
        self.searchTf.frame = tfRect;
        self.quitBtn.alpha = 0.0;
        self.cancleBtn.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
}
#pragma mark - 点击键盘上的【搜索按钮】
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField.text length] > 0) {
        self.searchKey = textField.text;
        //回调 搜索
        [self handleSeach:textField.text];
        return YES;
    }
    return NO;
}
-(void)handleSeach:(NSString *)searchKey
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchTopBarSearchForKey:)]) {
        [self.delegate searchTopBarSearchForKey:searchKey];
    }
    [self cancleInput];
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
    self.searchKey = textfield.text;
    if (self.searchKey.length > 0) {
        [self searchSameData];
    }else{
        [self.tableView reloadData];
    }
}
#pragma mark - 搜索相似数据
-(void)searchSameData
{
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 20; i ++) {
        NSString * str = [NSString stringWithFormat:@"%@%d%d",self.searchKey,i,i];
        [arr addObject:str];
    }
    [self.searchDataArr removeAllObjects];
    [self.searchDataArr addObjectsFromArray:arr];
    [self.tableView reloadData];
}
#pragma mark - 取消按钮点击
-(void)cancleInput
{
    self.searchTapBtn.hidden = NO;
    [self.searchTf resignFirstResponder];
    //输入框动画
    [self searchTFHidenAnimation];
    self.frame = CGRectMake(0, 0, Screen_WIDTH, NavHeight);
    self.tableView.hidden = YES;
    [self.tableView reloadData];
}
#pragma mark - 输入框点击
-(void)tapToSearch
{
    self.searchTapBtn.hidden = YES;
    [self.searchTf becomeFirstResponder];
    //输入框动画
    [self searchTFShowAnimation];
    self.frame = CGRectMake(0, 0, Screen_WIDTH, Screen_HEIGTH);
    [self.superview bringSubviewToFront:self];
    self.tableView.hidden = NO;
    [self.tableView reloadData];
}
#pragma mark - 退出按钮点击
-(void)quitItemClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchTopBarQuitHandle)]) {
        [self.delegate searchTopBarQuitHandle];
    }
}
- (BaseTableView *)tableView
{
    if (!_tableView) {
        self.searchDataArr = [NSMutableArray arrayWithCapacity:0];
        [self updateRecodeData];
        
        _tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, NavHeight, Screen_WIDTH, Screen_HEIGTH - NavHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.tableFooterView = [UIView new];
        [_tableView mh_fixIphoneXBottomMargin];
        [self addSubview:_tableView];
    }
    return _tableView;
}
-(void)updateRecodeData
{
    self.recodeArr = [NSMutableArray arrayWithCapacity:0];
    [self.recodeArr addObjectsFromArray:@[@"王二狗",@"能打开没试过角度看",@"单身公害",@"are个人",@"就好是按时发育GIF㔿",@"没考虑好不能不管发给",@"看见你",@"办好重复的日程",@"坡口机那个背锅",@"欧赔地方"]];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchKey.length > 0) {
        return self.searchDataArr.count;
    }
    if (self.isShowAllRecode) {
        return self.recodeArr.count;
    }
    if (self.recodeArr.count > 2) {
        return 2;
    }
    return self.recodeArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Width(55);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchKey.length > 0) {
        static NSString * cellid = @"searchkeyliebaocellid";
        SearchSameCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[SearchSameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        [cell setSearchKey:self.searchKey sameStr:self.searchDataArr[indexPath.row]];
        return cell;
    }else{
        static NSString * cellid = @"searchkeyliebaocellidssssss";
        SearchRecodeCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[SearchRecodeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.recodeStr = self.recodeArr[indexPath.row];
        cell.cellIndex = indexPath.row;
        cell.delegate = self;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString * searchKey = @"";
    if (self.searchKey.length > 0) {
        searchKey = self.searchDataArr[indexPath.row];
    }else{
        searchKey = self.recodeArr[indexPath.row];
    }
    [self handleSeach:searchKey];
}
#pragma mark - 历史记录 删除
- (void)searchRecodeCellDelete:(NSInteger)cellIndex
{
    [self.recodeArr removeObjectAtIndex:cellIndex];
    [self.tableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.searchKey.length > 0) {
        return 0.1;
    }
    if (self.recodeArr.count > 2) {
        return Width(50) + Width(45) + Width(35)*3 + Width(10)*3 + Width(35);
    }
    return Width(45) + Width(35)*3 + Width(10)*3 + Width(35);
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.searchKey.length > 0) {
        UIView * footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH, 0.1)];
        footer.backgroundColor = [UIColor clearColor];
        return footer;
    }
    CGFloat footerHeight = Width(45) + Width(35)*3 + Width(10)*3 + Width(35);
    if (self.recodeArr.count > 2) {
        footerHeight = Width(50) + Width(45) + Width(35)*3 + Width(10)*3 + Width(35);
    }
    UIView * footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH, footerHeight)];
    footer.backgroundColor = [UIColor clearColor];
    
    CGFloat oriy = 0;
    if (self.recodeArr.count > 2) {
        oriy = Width(50);
        //显示全部 删除全部
        UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH, Width(50))];
        topView.backgroundColor = [UIColor clearColor];
        [footer addSubview:topView];
        
        UIButton * showDelAllBtn = [UIButton buttonWithType:0];
        showDelAllBtn.frame = topView.bounds;
        [showDelAllBtn setTitle:self.isShowAllRecode ? @"删除全部" : @"全部搜索记录" forState:0];
        [showDelAllBtn setTitleColor:[UIColor grayColor] forState:0];
        showDelAllBtn.titleLabel.font = FONT(16);
        [showDelAllBtn addTarget:self action:@selector(showDelAllRecodeClick) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:showDelAllBtn];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(Width(15), Width(50)-0.5, Screen_WIDTH - Width(15)*2, 0.5)];
        line.backgroundColor = [UIColor grayColor];
        [topView addSubview:line];
    }
    //热搜
    UILabel * lab = [UILabel labTextColor:[UIColor grayColor] font:FONT(14) aligent:NSTextAlignmentLeft];
    lab.text = @"**热搜";
    [footer addSubview:lab];
    lab.frame = CGRectMake(Width(15), oriy, Width(120), Width(45));
    
    UIView * hotView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lab.frame), Screen_WIDTH, Width(35)*3 + Width(10)*3)];
    [footer addSubview:hotView];
    CGFloat itemWidth = (Screen_WIDTH - Width(15)*3)/2;
    for (int i = 0; i < 6; i ++) {
        NSInteger hang = i / 2;
        NSInteger lie = i % 2;
        
        UIView * hotItem = [[UIView alloc] initWithFrame:CGRectMake(Width(15) + (itemWidth + Width(15)) * lie, (Width(35) + Width(10)) * hang, itemWidth, Width(35))];
        hotItem.backgroundColor = [UIColor grayColor];
        hotItem.layer.cornerRadius = 4;
        hotItem.layer.masksToBounds = YES;
        [hotView addSubview:hotItem];
        
        UILabel * lab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(15) aligent:NSTextAlignmentCenter];
        lab.text = @"热搜热搜热搜热搜热搜热搜热搜热搜";
        lab.numberOfLines = 1;
        [hotItem addSubview:lab];
        lab.frame = CGRectMake(Width(10), 0, itemWidth - Width(20), Width(35));
        
        UIButton * hotbtn = [UIButton buttonWithType:0];
        hotbtn.frame = hotItem.bounds;
        [hotbtn addTarget:self action:@selector(hotItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [hotItem addSubview:hotbtn];
    }
    
    //查看热搜榜
    UIButton * checkHotBtn = [UIButton buttonWithType:0];
    checkHotBtn.frame = CGRectMake(Width(60), CGRectGetMaxY(hotView.frame), Screen_WIDTH - Width(120), Width(35));
    [checkHotBtn setTitle:@"查看热搜榜 >" forState:0];
    [checkHotBtn setTitleColor:[UIColor base_yellow_color] forState:0];
    checkHotBtn.titleLabel.font = FONT(14);
    [checkHotBtn addTarget:self action:@selector(checkHotBangDanClick) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:checkHotBtn];
    
    return footer;
}
#pragma mark - 显示/删除 全部搜索记录
-(void)showDelAllRecodeClick
{
    if (self.isShowAllRecode) {
        //删除全部
        [self.recodeArr removeAllObjects];
    }
    self.isShowAllRecode = !self.isShowAllRecode;
    [self.tableView reloadData];
}
#pragma mark - 热搜点击
-(void)hotItemClick:(UIButton *)sender
{
    [self handleSeach:@"二狗子"];
}
#pragma mark - 查看热搜榜
-(void)checkHotBangDanClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchTopBarHandleCheckHotBD)]) {
        [self.delegate searchTopBarHandleCheckHotBD];
    }
    [self cancleInput];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH, 0.1)];
    header.backgroundColor = [UIColor clearColor];
    return header;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self endEditing:YES];
}
@end
