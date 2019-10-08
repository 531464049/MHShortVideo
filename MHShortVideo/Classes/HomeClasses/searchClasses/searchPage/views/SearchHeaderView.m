//
//  SearchHeaderView.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/10.
//  Copyright © 2018 mh. All rights reserved.
//

#import "SearchHeaderView.h"
#import "MHCarouselView.h"

@interface SearchHeaderView ()<MHCarouselViewDelegate>



@end

@implementation SearchHeaderView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
#pragma mark - 赋值
- (void)setModel:(SearchHeaderModel *)model
{
    if (!model) {
        return;
    }
    _model = model;
    
    //热搜
    UIImageView * hotIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width(18), Width(18))];
    hotIcon.center = CGPointMake(Width(15) + Width(9), Width(20));
    hotIcon.image = [UIImage imageNamed:@"home_bgm_icon"];
    hotIcon.contentMode = UIViewContentModeScaleAspectFit;
    hotIcon.clipsToBounds = YES;
    [self addSubview:hotIcon];
    
    UILabel * lab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(14) aligent:NSTextAlignmentLeft];
    lab.text = @"热搜";
    lab.frame = CGRectMake(CGRectGetMaxX(hotIcon.frame) + 10, 0, 200, Width(40));
    [self addSubview:lab];
    
    CGFloat oriY = Width(40);
    //热搜九宫格
    CGFloat leftMargin = Width(15);
    CGFloat itemMargin = 2;
    CGFloat itemWidth = (Screen_WIDTH - leftMargin*2 - itemMargin*2)/3;
    for (int i = 0; i < model.hotSearchModels.count; i ++) {
        HotSearchModel * hot = (HotSearchModel *)model.hotSearchModels[i];
        
        NSInteger hang = i /3;
        NSInteger lie = i % 3;
        UIView * item = [[UIView alloc] init];
        item.frame = CGRectMake(leftMargin + (itemWidth+itemMargin)*lie, oriY + (itemWidth+itemMargin) * hang, itemWidth, itemWidth);
        [self addSubview:item];
        
        UIImageView * img = [[UIImageView alloc] initWithFrame:item.bounds];
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.clipsToBounds = YES;
        [item addSubview:img];
        [img yy_setImageWithURL:[NSURL URLWithString:hot.imgUrl] placeholder:nil];
        
        YYLabel * lab = [[YYLabel alloc] init];
        lab.frame = CGRectMake(0, 0, itemWidth-Width(40), itemWidth-Width(40));
        lab.center = CGPointMake(itemWidth/2, itemWidth/2);
        lab.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        lab.numberOfLines = 0;
        
        NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc] initWithString:hot.title];
        attribute.yy_font = [UIFont boldSystemFontOfSize:16];
        attribute.yy_color = [UIColor whiteColor];
        if (hot.hotType == 0) {
            NSAttributedString *emoText = [NSAttributedString yy_attachmentStringWithEmojiImage:[UIImage imageNamed:@"common_like"] fontSize:17];
            [attribute replaceCharactersInRange:NSMakeRange(0, 0) withAttributedString:emoText];
        }else if (hot.hotType == 2) {
            NSAttributedString *emoText = [NSAttributedString yy_attachmentStringWithEmojiImage:[UIImage imageNamed:@"home_focusAdd"] fontSize:17];
            [attribute replaceCharactersInRange:NSMakeRange(0, 0) withAttributedString:emoText];
        }
        lab.attributedText = attribute;
        [item addSubview:lab];
    }
    
    oriY = oriY + itemWidth + itemMargin + itemWidth;
    
    {
        //查看更多热搜帮单
        UIView * moreView = [[UIView alloc] initWithFrame:CGRectMake(0, oriY, Screen_WIDTH, Width(55))];
        [self addSubview:moreView];
        
        UILabel * checkMoreLab = [UILabel labTextColor:[UIColor base_yellow_color] font:FONT(16) aligent:NSTextAlignmentLeft];
        checkMoreLab.text = @"查看更多热搜榜单";
        checkMoreLab.frame = CGRectMake(Width(15), 0, 300, Width(55));
        [moreView addSubview:checkMoreLab];
        
        UIImageView * moreIcon = [[UIImageView alloc] initWithFrame:CGRectMake(Screen_WIDTH - Width(15) - Width(30), 0, Width(30), Width(55))];
        moreIcon.image = [UIImage imageNamed:@"common_next"];
        moreIcon.contentMode = UIViewContentModeScaleAspectFit;
        moreIcon.clipsToBounds = YES;
        [moreView addSubview:moreIcon];
        
        UIButton * moreBtn = [UIButton buttonWithType:0];
        moreBtn.frame = moreView.bounds;
        [moreBtn addTarget:self action:@selector(checkMoreHot) forControlEvents:UIControlEventTouchUpInside];
        [moreView addSubview:moreBtn];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(Width(15), Width(55)-0.5, Screen_WIDTH - Width(30), 0.5)];
        line.backgroundColor = [UIColor grayColor];
        [moreView addSubview:line];
    }

    oriY = oriY + Width(55) + Width(15);
    //轮播图
    MHCarouselView * carouselView = [[MHCarouselView alloc]initWithFrame:CGRectMake(Width(15), oriY, Screen_WIDTH - Width(30), Width(165))];
    carouselView.delegate = self;
    carouselView.time = 4;
    carouselView.imageArray = model.adArr;
    [self addSubview:carouselView];
}
#pragma mark - 查看更多热搜榜单
-(void)checkMoreHot
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchHeaderHotBangDanHandle)]) {
        [self.delegate searchHeaderHotBangDanHandle];
    }
}
#pragma mark - 轮播图点击
- (void)carouselView:(MHCarouselView *)carouselView clickImageAtIndex:(NSInteger)index
{
    DLog(@"轮播图点击   %ld",index);
}
+(CGFloat)headerHeight
{
    CGFloat totleHeight = Width(40);//热搜标题
    
    CGFloat itemWidth = (Screen_WIDTH - Width(15)*2 - 2*2)/3;
    totleHeight = totleHeight + itemWidth + 2 + itemWidth;
    
    totleHeight = totleHeight + Width(55);
    
    totleHeight = totleHeight + Width(15) + Width(165) + Width(15);
    
    return totleHeight;
}

@end
