//
//  MHTitleSliderBar.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/11.
//  Copyright © 2018 mh. All rights reserved.
//

#import "MHTitleSliderBar.h"

#define selfWidth       self.bounds.size.width
#define selfHeight       self.bounds.size.height
#define leftMargin      Width(15)
#define itemMargin      Width(15)
#define rightMargin      Width(15)
#define btnItemTag      1900

@interface MHTitleSliderBar ()<UIScrollViewDelegate>

@property(nonatomic,copy)NSArray * titleArr;
@property(nonatomic,strong)UIScrollView * barScrollView;
@property(nonatomic,assign)CGFloat itemWidth;
@property(nonatomic,assign)CGFloat barContentWidth;
@property(nonatomic,strong)UIView * bottomAniLine;
@property(nonatomic,strong)UIView * bottomMarinLine;
@property(nonatomic,strong)UIFont * titleNomalFont;
@property(nonatomic,strong)UIFont * titleSelectedFont;
@property(nonatomic,strong)UIColor * titleNomalColor;
@property(nonatomic,strong)UIColor * titleSelectedColor;
@property(nonatomic,strong)UIColor * bottomLineColor;
@property(nonatomic,assign)NSInteger maxShowItemNum;

@end

@implementation MHTitleSliderBar

-(instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor base_color];
        self.titleArr = titleArr;
        self.titleNomalFont = FONT(17);
        self.titleSelectedFont = FONT(17);
        self.titleNomalColor = [UIColor grayColor];
        self.titleSelectedColor = [UIColor whiteColor];
        self.bottomLineColor = [UIColor base_yellow_color];
        self.maxShowItemNum = 5;
        [self buildBar];
    }
    return self;
}
-(void)buildBar
{
    NSInteger scr_num = self.titleArr.count > self.maxShowItemNum ? self.maxShowItemNum : self.titleArr.count;
    //计算每个item宽度
    self.itemWidth = (selfWidth - (scr_num - 1) * itemMargin - leftMargin - rightMargin) / scr_num;
    //整体容器contentsize width
    self.barContentWidth = leftMargin + self.itemWidth * self.titleArr.count + rightMargin + itemMargin * (self.titleArr.count - 1);
    
    self.barScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, selfWidth, selfHeight)];
    self.barScrollView.showsVerticalScrollIndicator = NO;
    self.barScrollView.showsHorizontalScrollIndicator = NO;
    self.barScrollView.bounces = NO;
    self.barScrollView.pagingEnabled = NO;
    self.barScrollView.contentSize = CGSizeMake(self.barContentWidth, selfHeight);
    [self addSubview:self.barScrollView];
    
    for (int i = 0; i < self.titleArr.count; i ++) {
        UIButton * btnItem = [UIButton buttonWithType:0];
        btnItem.backgroundColor = [UIColor clearColor];
        btnItem.tag = i + btnItemTag;
        [btnItem setTitle:self.titleArr[i] forState:0];
        [btnItem setTitle:self.titleArr[i] forState:UIControlStateHighlighted];
        [btnItem setTitleColor:self.titleNomalColor forState:0];
        btnItem.titleLabel.font = self.titleNomalFont;
        if (i == 0) {
            [btnItem setTitleColor:self.titleSelectedColor forState:0];
            btnItem.titleLabel.font = self.titleSelectedFont;
        }
        [btnItem addTarget:self action:@selector(btnItemSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.barScrollView addSubview:btnItem];
        btnItem.frame = CGRectMake(leftMargin + (self.itemWidth + itemMargin) * i, 0, self.itemWidth, selfHeight);
    }
    //底部线条
    self.bottomMarinLine = [[UIView alloc] initWithFrame:CGRectMake(0, selfHeight-0.5, self.barContentWidth, 0.5)];
    self.bottomMarinLine.backgroundColor = HexRGBAlpha(0xf4f4f4, 1);
    [self.barScrollView addSubview:self.bottomMarinLine];
    
    //底部动画线条
    self.bottomAniLine = [[UIView alloc] initWithFrame:CGRectMake(leftMargin, selfHeight-2, self.itemWidth, 2)];
    self.bottomAniLine.backgroundColor = self.bottomLineColor;
    [self.barScrollView addSubview:self.bottomAniLine];
}
#pragma mark - item点击
-(void)btnItemSelected:(UIButton *)sender
{
    for (int i = 0; i < self.titleArr.count; i ++) {
        UIButton * btn = (UIButton *)[self viewWithTag:i + btnItemTag];
        [btn setTitleColor:self.titleNomalColor forState:0];
        btn.titleLabel.font = self.titleNomalFont;
    }
    [sender setTitleColor:self.titleSelectedColor forState:0];
    sender.titleLabel.font = self.titleSelectedFont;
    CGRect bottomFrame = self.bottomAniLine.frame;
    bottomFrame.origin.x = sender.origin.x;
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomAniLine.frame = bottomFrame;
    }];
    [self adjustScrollViewContentX:sender];
    if (self.delegate && [self.delegate respondsToSelector:@selector(titleSliderBar:selected:)]) {
        [self.delegate titleSliderBar:self selected:sender.tag - btnItemTag];
    }
}
#pragma mark - 调整滚动条ContentX
-(void)adjustScrollViewContentX:(UIButton *)sender
{
    CGFloat senderCenterX = sender.origin.x + self.itemWidth/2;
    if (senderCenterX < Screen_WIDTH/2) {
        [self.barScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        return;
    }
    if (self.barContentWidth - senderCenterX < Screen_WIDTH/2) {
        [self.barScrollView setContentOffset:CGPointMake(self.barContentWidth - selfWidth, 0) animated:YES];
        return;
    }
    CGFloat contentOffSetX = senderCenterX - Screen_WIDTH/2;
    [self.barScrollView setContentOffset:CGPointMake(contentOffSetX, 0) animated:YES];
}
#pragma mark - 当外界滑动时 通知homeListBar实时更新bottomLine位置
-(void)titleSliderBarScrollBottomLine:(CGFloat )cfl
{
    if (cfl <= 0 || cfl >= _titleArr.count - 1) {
        return;
    }
    CGRect bottomFrame = self.bottomAniLine.frame;
    bottomFrame.origin.x = leftMargin + (self.itemWidth + itemMargin)*cfl;
    self.bottomAniLine.frame = bottomFrame;
}
#pragma mark - 当外界滑动结束时 通知homeListBar更新选中项
-(void)titleSliderBarOutSideScrollEnd:(NSInteger)index
{
    UIButton * btn = (UIButton *)[self viewWithTag:btnItemTag + index];
    [self btnItemSelected:btn];
}
@end
