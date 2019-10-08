//
//  FocusDynamicCell.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/13.
//  Copyright © 2018 mh. All rights reserved.
//

#import "FocusDynamicCell.h"
#import "VideoCommentCell.h"
#import "DynamicVideoBottomBar.h"

@interface FocusDynamicCell ()

@property(nonatomic,strong)UIImageView * headerImage;//头像
@property(nonatomic,strong)UILabel * nameLab;//名字
@property(nonatomic,strong)YYLabel * titleLab;//视频标题
@property(nonatomic,strong)UIImageView * videoPreImage;//视频预览图
@property(nonatomic,strong)DynamicVideoBottomBar * videoBottomBar;//视频底部bar
@property(nonatomic,strong)CommentCellContent * commentView;//评论view

@property(nonatomic,strong)UIView * bottomline;//底部分割线
@end

@implementation FocusDynamicCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        FocusDynamicLayout * layout = [[FocusDynamicLayout alloc] init];
        
        self.headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(layout.leftRightMaring, layout.headerTop, layout.headerImageWidth, layout.headerImageWidth)];
        self.headerImage.contentMode = UIViewContentModeScaleAspectFill;
        self.headerImage.clipsToBounds = YES;
        self.headerImage.layer.cornerRadius = layout.headerImageWidth/2;
        self.headerImage.layer.masksToBounds = YES;
        [self.contentView addSubview:self.headerImage];
        
        self.nameLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(14) aligent:NSTextAlignmentLeft];
        self.nameLab.numberOfLines = 1;
        [self.contentView addSubview:self.nameLab];
        self.nameLab.sd_layout.leftSpaceToView(self.headerImage, 5).centerYEqualToView(self.headerImage).rightSpaceToView(self.contentView, Width(15)).heightIs(20);
        
        self.titleLab = [YYLabel new];
        self.titleLab.textVerticalAlignment = YYTextVerticalAlignmentTop;
        self.titleLab.displaysAsynchronously = YES;
        self.titleLab.ignoreCommonProperties = YES;
        self.titleLab.fadeOnAsynchronouslyDisplay = NO;
        self.titleLab.fadeOnHighlight = NO;
        self.titleLab.numberOfLines = 2;
        [self.contentView addSubview:self.titleLab];
        
        self.videoPreImage = [[UIImageView alloc] init];
        self.videoPreImage.contentMode = UIViewContentModeScaleAspectFill;
        self.videoPreImage.clipsToBounds = YES;
        self.videoPreImage.layer.cornerRadius = 8;
        self.videoPreImage.layer.masksToBounds = YES;
        self.videoPreImage.userInteractionEnabled = YES;
        [self.contentView addSubview:self.videoPreImage];
        
        self.videoBottomBar = [[DynamicVideoBottomBar alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH, layout.videoBarHeight)];
        [self.contentView addSubview:self.videoBottomBar];
        
        self.commentView = [[CommentCellContent alloc] init];
        [self.contentView addSubview:self.commentView];
        
        self.bottomline = [[UIView alloc] init];
        self.bottomline.backgroundColor = [UIColor grayColor];
        self.bottomline.hidden = YES;
        [self.contentView addSubview:self.bottomline];
        self.bottomline.sd_layout.leftSpaceToView(self.contentView, Width(15)).bottomEqualToView(self.contentView).rightSpaceToView(self.contentView, Width(15)).heightIs(0.5);
    }
    return self;
}
- (void)setModel:(FocusDynamicModel *)model
{
    _model = model;
    
    FocusDynamicLayout * layout = [[FocusDynamicLayout alloc] init];
    
    [self.headerImage yy_setImageWithURL:[NSURL URLWithString:model.videoModel.userImage] placeholder:nil];
    self.nameLab.text = [NSString stringWithFormat:@"@%@",model.videoModel.userName];
    
    
    self.titleLab.textLayout = model.videoTitleTextLayout;
    self.titleLab.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        
    };
    self.titleLab.sd_layout.leftSpaceToView(self.contentView, layout.leftRightMaring).topSpaceToView(self.headerImage, layout.header_title_margin).rightSpaceToView(self.contentView, layout.leftRightMaring).heightIs(model.videoTitleHeight);
    
    [self.videoPreImage yy_setImageWithURL:[NSURL URLWithString:model.videoModel.videoPreImage] placeholder:nil];
    self.videoPreImage.sd_layout.leftSpaceToView(self.contentView, layout.leftRightMaring).topSpaceToView(self.titleLab, layout.title_preImage_margin).widthIs(layout.preImageWidth).heightIs(layout.preImageHeight);
    
    self.videoBottomBar.videoModel = model.videoModel;
    self.videoBottomBar.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.videoPreImage, 0).rightSpaceToView(self.contentView, 0).heightIs(layout.videoBarHeight);
    
    self.commentView.model = model.commentModel;
    self.commentView.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.videoBottomBar, 0).rightSpaceToView(self.contentView, 0).heightIs(model.commentModel.cellHeight);
}
- (void)setIsSectionLastCell:(BOOL)isSectionLastCell
{
    _isSectionLastCell = isSectionLastCell;
    self.bottomline.hidden = isSectionLastCell;
}
- (void)play
{
    [MHCellAutoPlayer.sharedPlayer playVideo:self.model.videoModel.videoUrl frame:self.videoPreImage.bounds];
    [self.videoPreImage addSubview:MHCellAutoPlayer.sharedPlayer];
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
