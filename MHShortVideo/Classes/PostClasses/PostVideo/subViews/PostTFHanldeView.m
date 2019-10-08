//
//  PostTFHanldeView.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/29.
//  Copyright © 2018 mh. All rights reserved.
//

#import "PostTFHanldeView.h"

@interface PostTFHanldeView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * topiclistTable;
@property(nonatomic,strong)NSArray * topicArr;

@end

@implementation PostTFHanldeView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //毛玻璃
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = self.bounds;
        [self addSubview:effectView];
        
        UIControl * handleControl = [[UIControl alloc] initWithFrame:self.bounds];
        [handleControl addTarget:self action:@selector(handleControlHandle) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:handleControl];
    }
    return self;
}
#pragma mark - 响应点击
-(void)handleControlHandle
{
    self.topiclistTable.hidden = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(tfHanldeViewHanldeKeyBordDown)]) {
        [self.delegate tfHanldeViewHanldeKeyBordDown];
    }
}
#pragma mark - 切换到话题列表
-(void)updateToTopicList
{
    if (self.topiclistTable.isHidden) {
        //获取键盘高度
        CGRect rect = YYTextKeyboardManager.defaultManager.keyboardFrame;
        DLog(@"键盘高度    %f",rect.size.height);
        CGRect topicTabFrame = self.topiclistTable.frame;
        topicTabFrame.size.height = self.frame.size.height - rect.size.height;
        self.topiclistTable.frame = topicTabFrame;
        self.topiclistTable.hidden = NO;
        
        self.topicArr = @[@"话题啊啊啊",@"话题你看你们",@"话题护眼",@"和举案说法顾得上",@"你看嘛hiu",@"阿飞如",@"uawtfbn"];
        [self.topiclistTable reloadData];
    }else{
        [self handleHidenTopicList];
    }

}
#pragma mark - 隐藏话题列表
-(void)handleHidenTopicList
{
    self.topiclistTable.hidden = YES;
}
- (UITableView *)topiclistTable
{
    if (!_topiclistTable) {
        _topiclistTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0) style:UITableViewStylePlain];
        _topiclistTable.backgroundColor = [UIColor clearColor];
        _topiclistTable.separatorColor = [UIColor clearColor];
        _topiclistTable.showsVerticalScrollIndicator = NO;
        _topiclistTable.showsHorizontalScrollIndicator = NO;
        _topiclistTable.delegate = self;
        _topiclistTable.dataSource = self;
        _topiclistTable.tableFooterView = [UIView new];
        _topiclistTable.hidden = YES;
        [self addSubview:_topiclistTable];
    }
    return _topiclistTable;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topicArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Width(50);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostTopicListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"handeltopiccellidklkl"];
    if (!cell) {
        cell = [[PostTopicListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"handeltopiccellidklkl"];
    }
    cell.topic = self.topicArr[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * topic = self.topicArr[indexPath.row];
    DLog(@"话题：%@",topic);
    [self handleHidenTopicList];
    if (self.delegate && [self.delegate respondsToSelector:@selector(historyTopicListSelectedTopic:)]) {
        [self.delegate historyTopicListSelectedTopic:topic];
    }
}
@end


@interface PostTopicListCell ()

@property(nonatomic,strong)UILabel * topicLab;
@property(nonatomic,strong)UIImageView * historyIcon;

@end
@implementation PostTopicListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.topicLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(15) aligent:NSTextAlignmentLeft];
        [self.contentView addSubview:self.topicLab];
        
        self.historyIcon = [[UIImageView alloc] init];
        self.historyIcon.contentMode = UIViewContentModeScaleAspectFit;
        self.historyIcon.clipsToBounds = YES;
        self.historyIcon.image = [UIImage imageNamed:@"qqqqqqqqq"];
        [self.contentView addSubview:self.historyIcon];
    }
    return self;
}
- (void)setTopic:(NSString *)topic
{
    _topic = topic;
    NSString * ttt = [NSString stringWithFormat:@"#%@",topic];
    CGFloat width = [ttt textForLabWidthWithTextHeight:20 font:self.topicLab.font];
    if (width > Screen_WIDTH - 80) {
        width = Screen_WIDTH - 80;
    }
    self.topicLab.text = ttt;
    self.topicLab.frame = CGRectMake(Width(15), 0, width, Width(50));
    self.historyIcon.frame = CGRectMake(CGRectGetMaxX(self.topicLab.frame), Width(15), Width(20), Width(20));
}
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
