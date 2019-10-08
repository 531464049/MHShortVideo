//
//  HomePageRightBar.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/4.
//  Copyright © 2018 mh. All rights reserved.
//

#import "HomePageRightBar.h"

@interface HomePageRightBar ()

@property(nonatomic,strong)UIImageView * headerImage;//头像
@property(nonatomic,strong)UIImageView * focusIcon;//关注icon

@property(nonatomic,strong)UIButton * likeItem;//喜欢
@property(nonatomic,strong)UIButton * commentItem;//评论
@property(nonatomic,strong)UIButton * shareItem;//分享

@property(nonatomic,strong)UIImageView * bgmImage;//bgm图标

@end

@implementation HomePageRightBar

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commit_subViews];
    }
    return self;
}
#pragma mark - 初始化
-(void)commit_subViews
{
    //头像
    self.headerImage = [[UIImageView alloc] init];
    self.headerImage.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImage.clipsToBounds = YES;
    self.headerImage.layer.cornerRadius = Width(50)/2;
    self.headerImage.layer.masksToBounds = YES;
    [self addSubview:self.headerImage];
    self.headerImage.sd_layout.topSpaceToView(self, 0).centerXEqualToView(self).widthIs(Width(50)).heightEqualToWidth();
    //头像-关注
    self.focusIcon = [[UIImageView alloc] init];
    self.focusIcon.contentMode = UIViewContentModeScaleAspectFill;
    self.focusIcon.clipsToBounds = YES;
    self.focusIcon.image = [UIImage imageNamed:@"home_focusAdd"];
    self.focusIcon.layer.cornerRadius = Width(20)/2;
    self.focusIcon.layer.masksToBounds = YES;
    [self addSubview:self.focusIcon];
    self.focusIcon.sd_layout.centerXEqualToView(self).centerYIs(Width(50)).widthIs(Width(20)).heightEqualToWidth();
    //头像-整体点击区域
    UIButton * headerTap = [UIButton buttonWithType:0];
    [headerTap addTarget:self action:@selector(headerClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:headerTap];
    headerTap.sd_layout.leftEqualToView(self).topEqualToView(self).rightEqualToView(self).heightIs(Width(60));
    
    //喜欢
    self.likeItem = [UIButton buttonWithType:0];
    [self.likeItem setImage:[UIImage imageNamed:@"home_likeUnSelected"] forState:0];
    [self.likeItem setTitle:@"0" forState:0];
    [self.likeItem setTitleColor:[UIColor whiteColor] forState:0];
    self.likeItem.titleLabel.font = FONT(13);
    [self.likeItem addTarget:self action:@selector(likeItemClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.likeItem];
    self.likeItem.sd_layout.leftSpaceToView(self, 0).topSpaceToView(headerTap, Width(10)).rightSpaceToView(self, 0).heightIs(Width(60));
    [self.likeItem updateLayout];
    [self mh_fixBtnImageTop:self.likeItem];
    
    //评论
    self.commentItem = [UIButton buttonWithType:0];
    [self.commentItem setImage:[UIImage imageNamed:@"home_comment"] forState:0];
    [self.commentItem setTitle:@"0" forState:0];
    [self.commentItem setTitleColor:[UIColor whiteColor] forState:0];
    self.commentItem.titleLabel.font = FONT(13);
    [self.commentItem addTarget:self action:@selector(commentItemClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.commentItem];
    self.commentItem.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self.likeItem, Width(10)).rightSpaceToView(self, 0).heightIs(Width(60));
    [self.commentItem updateLayout];
    [self mh_fixBtnImageTop:self.commentItem];
    
    //分享
    self.shareItem = [UIButton buttonWithType:0];
    [self.shareItem setImage:[UIImage imageNamed:@"home_share"] forState:0];
    [self.shareItem setTitle:@"0" forState:0];
    [self.shareItem setTitleColor:[UIColor whiteColor] forState:0];
    self.shareItem.titleLabel.font = FONT(13);
    [self.shareItem addTarget:self action:@selector(shareItemClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.shareItem];
    self.shareItem.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self.commentItem, Width(10)).rightSpaceToView(self, 0).heightIs(Width(60));
    [self.shareItem updateLayout];
    [self mh_fixBtnImageTop:self.shareItem];
    
    //bgm图标
    self.bgmImage = [[UIImageView alloc] init];
    self.bgmImage.contentMode = UIViewContentModeScaleAspectFill;
    self.bgmImage.clipsToBounds = YES;
    self.bgmImage.layer.cornerRadius = Width(50)/2;
    self.bgmImage.layer.masksToBounds = YES;
    self.bgmImage.layer.borderColor = RGB(22, 22, 22).CGColor;
    self.bgmImage.layer.borderWidth = Width(10);
    [self addSubview:self.bgmImage];
    self.bgmImage.sd_layout.bottomSpaceToView(self, Width(10)).centerXEqualToView(self).widthIs(Width(50)).heightEqualToWidth();
}
- (void)mh_fixBtnImageTop:(UIButton *)btn
{
    CGFloat labHeight = 20;
    UIImage *image = btn.imageView.image;
    if (!image) {
        return;
    }
    //设置后的图片高度
    CGFloat imageHeight = btn.frame.size.height - labHeight;
    if (imageHeight > image.size.height) {
        imageHeight = image.size.height;
    }
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, (btn.frame.size.width - imageHeight) / 2, labHeight + 5, (btn.frame.size.width - imageHeight) / 2);
    btn.titleEdgeInsets = UIEdgeInsetsMake(imageHeight + 5, -image.size.width, 0, 0);
}
- (void)setVideoModel:(HomeVideoModel *)videoModel
{
    _videoModel = videoModel;
    [self.headerImage yy_setImageWithURL:[NSURL URLWithString:videoModel.userImage] placeholder:nil];
    if (videoModel.isLiked) {
        [self.likeItem setImage:[UIImage imageNamed:@"home_lineSelected"] forState:0];
    }else{
        [self.likeItem setImage:[UIImage imageNamed:@"home_likeUnSelected"] forState:0];
    }
    [self.likeItem setTitle:[NSObject numToStr:videoModel.zanNum] forState:0];
    [self.commentItem setTitle:[NSObject numToStr:videoModel.commentNum] forState:0];
    [self.shareItem setTitle:[NSObject numToStr:videoModel.shareNum] forState:0];
    
    [self.bgmImage yy_setImageWithURL:[NSURL URLWithString:videoModel.userImage] placeholder:nil];
}
-(void)headerClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageRightBarHandle:)]) {
        [self.delegate pageRightBarHandle:PageRightBarHandleTypeFocusUser];
    }
}
-(void)likeItemClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageRightBarHandle:)]) {
        [self.delegate pageRightBarHandle:PageRightBarHandleTypeLike];
    }
}
-(void)commentItemClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageRightBarHandle:)]) {
        [self.delegate pageRightBarHandle:PageRightBarHandleTypeComment];
    }
}
-(void)shareItemClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageRightBarHandle:)]) {
        [self.delegate pageRightBarHandle:PageRightBarHandleTypeShare];
    }
}
@end
