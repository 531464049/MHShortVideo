//
//  SRCompositeCell.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/11.
//  Copyright © 2018 mh. All rights reserved.
//

#import "SRCompositeCell.h"
#import "SRCompositeCellBar.h"
#import "VideoCommentCell.h"

@interface SRCompositeCell ()

@property(nonatomic,strong)UIImageView * headerImage;//头像
@property(nonatomic,strong)UILabel * nameLab;//名字
@property(nonatomic,strong)UILabel * titleLab;//视频标题
@property(nonatomic,strong)UIImageView * videoPreImage;//视频预览图
@property(nonatomic,strong)SRCompositeCellBar * videoBottomBar;//视频底部bar
@property(nonatomic,strong)CommentCellContent * commentView;//评论view

@end

@implementation SRCompositeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        SRCompositeLayout * layout = [[SRCompositeLayout alloc] init];
        
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
        
        self.titleLab = [UILabel labTextColor:[UIColor whiteColor] font:layout.titleFont aligent:NSTextAlignmentLeft];
        self.titleLab.numberOfLines = 0;
        [self.contentView addSubview:self.titleLab];
        
        self.videoPreImage = [[UIImageView alloc] init];
        self.videoPreImage.contentMode = UIViewContentModeScaleAspectFill;
        self.videoPreImage.clipsToBounds = YES;
        self.videoPreImage.layer.cornerRadius = 8;
        self.videoPreImage.layer.masksToBounds = YES;
        [self.contentView addSubview:self.videoPreImage];
        
        self.videoBottomBar = [[SRCompositeCellBar alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH, layout.videoBarHeight)];
        [self.contentView addSubview:self.videoBottomBar];
        
        self.commentView = [[CommentCellContent alloc] init];
        [self.contentView addSubview:self.commentView];
    }
    return self;
}
- (void)setModel:(SRCompositeModel *)model
{
    _model = model;
    SRCompositeLayout * layout = [[SRCompositeLayout alloc] init];
    
    [self.headerImage yy_setImageWithURL:[NSURL URLWithString:model.videoModel.userImage] placeholder:nil];
    self.nameLab.text = [NSString stringWithFormat:@"@%@",model.videoModel.userName];
    
    self.titleLab.attributedText = [model.videoModel.videoTitle attributedStr:self.titleLab.font textColor:[UIColor whiteColor] lineSpace:7 keming:0];
    self.titleLab.sd_layout.leftSpaceToView(self.contentView, layout.leftRightMaring).topSpaceToView(self.headerImage, layout.header_title_margin).rightSpaceToView(self.contentView, layout.leftRightMaring).heightIs(model.videoTitleHeight);
    
    [self.videoPreImage yy_setImageWithURL:[NSURL URLWithString:model.videoModel.videoPreImage] placeholder:nil];
    self.videoPreImage.sd_layout.leftSpaceToView(self.contentView, layout.leftRightMaring).topSpaceToView(self.titleLab, layout.title_preImage_margin).widthIs(layout.preImageWidth).heightIs(layout.preImageHeight);
    
    self.videoBottomBar.videoModel = model.videoModel;
    self.videoBottomBar.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.videoPreImage, 0).rightSpaceToView(self.contentView, 0).heightIs(layout.videoBarHeight);
    
    self.commentView.model = model.commentModel;
    self.commentView.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.videoBottomBar, 0).rightSpaceToView(self.contentView, 0).heightIs(model.commentModel.cellHeight);
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
