//
//  PostWCSVC.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/3.
//  Copyright © 2018 mh. All rights reserved.
//

#import "PostWCSVC.h"

@interface PostWCSVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation PostWCSVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commit_navBar];
    
    BaseTableView * tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, NavHeight, self.view.frame.size.width, Screen_HEIGTH - NavHeight) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorInset = UIEdgeInsetsMake(0, Width(16), 0, Width(16));
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    [tableView mh_fixIphoneXBottomMargin];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Width(68);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellid = @"shukeyiikancellid";
    WhoCSCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[WhoCSCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.a_index = indexPath.row;
    BOOL isSelected = NO;
    if ((self.openType == MHPostVideoOpenTypeOpen && indexPath.row == 0) || (self.openType == MHPostVideoOpenTypeOnlyFriend && indexPath.row == 1) || (self.openType == MHPostVideoOpenTypeUnOpen && indexPath.row == 2)) {
        isSelected = YES;
    }
    cell.a_isSelected = isSelected;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.callBack) {
        MHPostVideoOpenType openType = MHPostVideoOpenTypeOpen;
        if (indexPath.row == 1) {
            openType = MHPostVideoOpenTypeOnlyFriend;
        }else if (indexPath.row == 2) {
            openType = MHPostVideoOpenTypeUnOpen;
        }
        self.callBack(openType);
    }
    [self cancleItemClick];
}
#pragma mark - 初始化导航栏
-(void)commit_navBar
{
    self.mhNavBar.hidden = NO;
    [self mh_setTitle:@"谁可以看"];
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

@end


@interface WhoCSCell ()

@property(nonatomic,strong)UILabel * lab1;
@property(nonatomic,strong)UILabel * lab2;

@end

@implementation WhoCSCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.lab1 = [UILabel labTextColor:[UIColor whiteColor] font:FONT(16) aligent:NSTextAlignmentLeft];
        [self.contentView addSubview:self.lab1];
        
        self.lab2 = [UILabel labTextColor:[UIColor grayColor] font:FONT(14) aligent:NSTextAlignmentLeft];
        [self.contentView addSubview:self.lab2];
        
        self.lab1.sd_layout.leftSpaceToView(self.contentView, Width(15)).bottomSpaceToView(self.contentView, Width(34)).rightSpaceToView(self.contentView, Width(15)).heightIs(Width(26));
        self.lab2.sd_layout.leftSpaceToView(self.contentView, Width(15)).topSpaceToView(self.contentView, Width(34)).rightSpaceToView(self.contentView, Width(15)).heightIs(Width(22));
    }
    return self;
}
- (void)setA_index:(NSInteger)a_index
{
    _a_index = a_index;
    if (a_index == 0) {
        self.lab1.text = @"公开";
        self.lab2.text = @"谁都可以看";
    }else if (a_index == 1) {
        self.lab1.text = @"好友可见";
        self.lab2.text = @"仅限好友可见";
    }else{
        self.lab1.text = @"不公开";
        self.lab2.text = @"除自己，谁都不可见";
    }
}
-(void)setA_isSelected:(BOOL)a_isSelected
{
    _a_isSelected = a_isSelected;
    if (a_isSelected) {
        self.lab1.textColor = [UIColor base_yellow_color];
    }else{
        self.lab1.textColor = [UIColor whiteColor];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
