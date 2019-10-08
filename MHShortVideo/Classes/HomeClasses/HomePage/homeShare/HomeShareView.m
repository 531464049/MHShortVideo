//
//  HomeShareView.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/7.
//  Copyright © 2018 mh. All rights reserved.
//

#import "HomeShareView.h"

@interface HomeShareView ()
{
    CGFloat _itemWidth;
    CGFloat _itemHeight;
    CGFloat _leftMargin;
}
@property(nonatomic,strong)UIView * contentView;

@end

@implementation HomeShareView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commit_subViews];
    }
    return self;
}
#pragma mark - 初始化界面
-(void)commit_subViews
{
    //点击退出遮罩
    UIControl * hidenControl = [[UIControl alloc] initWithFrame:self.bounds];
    [hidenControl addTarget:self action:@selector(hidenShareWindow) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:hidenControl];
    //105*2 + 50 + 24
    //整体容器
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, Width(284) + k_bottom_margin)];
    [self addSubview:self.contentView];
    //毛玻璃
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = self.contentView.bounds;
    [self.contentView addSubview:effectView];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10,10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.contentView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.contentView.layer.mask = maskLayer;
    
    //标题栏
    UILabel * titleLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(14) aligent:NSTextAlignmentCenter];
    titleLab.frame = CGRectMake(0, 0, 200, Width(16));
    titleLab.center = CGPointMake(self.frame.size.width/2, Width(18));
    titleLab.text = @"分享到";
    [self.contentView addSubview:titleLab];
    
    _leftMargin = Width(10);
    _itemWidth = Width(68);
    _itemHeight = Width(105);
    
    //第一栏
    NSArray * imgArr1 = @[@"sahre_zhuanfa",@"share_zhannei",@"share_pengyouquan",@"sahre_weixinhaoyou",@"share_qqkongjian",@"sahre_qqhaoyou",@"share_weibo",@"share_more"];
    NSArray * titleArr1 = @[@"转发",@"站内好友",@"朋友圈",@"微信好友",@"QQ控件",@"QQ好友",@"微博",@"更多"];
    
    UIScrollView * scroll1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, Width(24), self.frame.size.width, _itemHeight)];
    scroll1.showsVerticalScrollIndicator = NO;
    scroll1.showsHorizontalScrollIndicator = NO;
    scroll1.bounces = NO;
    [self.contentView addSubview:scroll1];
    scroll1.contentSize = CGSizeMake(_leftMargin + _itemWidth*imgArr1.count + _leftMargin, _itemHeight);
    
    for (int i = 0; i < imgArr1.count; i ++) {
        [self buildItemWithImage:imgArr1[i] title:titleArr1[i] scroll:scroll1 rowIndex:i rowSection:0];
    }

    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(_leftMargin, CGRectGetMaxY(scroll1.frame), self.frame.size.width - _leftMargin*2, 0.5)];
    line.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:line];
    
    //第二栏
    NSArray * imgArr2 = @[@"sahre_jubao",@"share_baocun",@"share_shoucang",@"share_unlike",@"sahre_copylink",@"sahre_erweima",@"sahre_suitui"];
    NSArray * titleArr2 = @[@"举报",@"保存至相册",@"收藏",@"不感兴趣",@"复制链接",@"二维码",@"速推"];
    
    UIScrollView * scroll2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(scroll1.frame), self.frame.size.width, _itemHeight)];
    scroll2.showsVerticalScrollIndicator = NO;
    scroll2.showsHorizontalScrollIndicator = NO;
    scroll2.bounces = NO;
    [self.contentView addSubview:scroll2];
    scroll2.contentSize = CGSizeMake(_leftMargin + _itemWidth*imgArr2.count + _leftMargin, _itemHeight);
    
    for (int i = 0; i < imgArr1.count; i ++) {
        [self buildItemWithImage:imgArr2[i] title:titleArr2[i] scroll:scroll2 rowIndex:i rowSection:1];
    }
    
    //底部取消
    UIView * bottom = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(scroll2.frame), self.frame.size.width, self.contentView.frame.size.height - CGRectGetMaxY(scroll2.frame))];
    bottom.backgroundColor = [UIColor base_color];
    [self.contentView addSubview:bottom];
    
    UIButton * cancleBtn = [UIButton buttonWithType:0];
    cancleBtn.frame = CGRectMake(0, 0, self.contentView.frame.size.width, Width(50));
    [cancleBtn setTitle:@"取消" forState:0];
    [cancleBtn setTitleColor:[UIColor grayColor] forState:0];
    cancleBtn.titleLabel.font = FONT(14);
    [cancleBtn addTarget:self action:@selector(hidenShareWindow) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:cancleBtn];
    
    //弹出动画
    [self contentAnitionShow:YES];
}
-(void)buildItemWithImage:(NSString *)imageName title:(NSString *)title scroll:(UIScrollView *)scrollView rowIndex:(NSInteger)index rowSection:(NSInteger)section
{
    UIView * itemView = [[UIView alloc] initWithFrame:CGRectMake(_leftMargin + _itemWidth*index, 20, _itemWidth, _itemHeight)];
    [scrollView addSubview:itemView];
    
    UIImageView * imgView = [[UIImageView alloc] init];
    imgView.frame = CGRectMake(0, 0, Width(50), Width(50));
    imgView.center = CGPointMake(_itemWidth/2, Width(11) + Width(50)/2);
    imgView.image = [UIImage imageNamed:imageName];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds = YES;
    [itemView addSubview:imgView];
    
    UILabel * lab = [UILabel labTextColor:[UIColor grayColor] font:FONT(13) aligent:NSTextAlignmentCenter];
    lab.text = title;
    lab.frame = CGRectMake(0, CGRectGetMaxY(imgView.frame), _itemWidth, Width(25));
    [itemView addSubview:lab];
    
    UIButton * btn = [UIButton buttonWithType:0];
    btn.frame = itemView.bounds;
    btn.tag = 5000 + index + 1000*section;
    [btn addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
    [itemView addSubview:btn];
    
    CGRect rect = CGRectMake(_leftMargin + _itemWidth*index, 0, _itemWidth, _itemHeight);
    CGFloat delay = 0.2 + 0.05 * index;
    
    [UIView animateWithDuration:0.4 delay:delay usingSpringWithDamping:0.3 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        itemView.frame = rect;
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark - item点击
-(void)itemSelected:(UIButton *)sender
{
    NSInteger tag = sender.tag - 5000;
    if (tag < 1000) {
        //第一排
        NSArray * titleArr1 = @[@"转发",@"站内好友",@"朋友圈",@"微信好友",@"QQ控件",@"QQ好友",@"微博",@"更多"];
        DLog(@"%@",titleArr1[tag]);
        [MHHUD showTips:titleArr1[tag]];
    }else{
        tag = tag - 1000;
        //第二排
        NSArray * titleArr2 = @[@"举报",@"保存至相册",@"收藏",@"不感兴趣",@"复制链接",@"二维码",@"速推"];
        DLog(@"%@",titleArr2[tag]);
        [MHHUD showTips:titleArr2[tag]];
    }
    
    [self contentAnitionShow:NO];
}
#pragma mark - 容器弹出/收起动画
-(void)contentAnitionShow:(BOOL)show
{
    if (show) {
        CGRect rect = self.contentView.frame;
        rect.origin.y = self.frame.size.height - rect.size.height;
        [UIView animateWithDuration:0.3 animations:^{
            self.contentView.frame = rect;
        }];
    }else{
        CGRect rect = self.contentView.frame;
        rect.origin.y = self.frame.size.height;
        [UIView animateWithDuration:0.3 animations:^{
            self.contentView.frame = rect;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}
#pragma mark - 退出
-(void)hidenShareWindow
{
    [self contentAnitionShow:NO];
}
+(void)showShareWindowWithVideo:(HomeVideoModel *)model
{
    UIWindow * keyWindow = [MHSystemHelper getKeyWindow];
    HomeShareView * shareView = [[HomeShareView alloc] initWithFrame:keyWindow.bounds];
    [keyWindow addSubview:shareView];
}
@end
