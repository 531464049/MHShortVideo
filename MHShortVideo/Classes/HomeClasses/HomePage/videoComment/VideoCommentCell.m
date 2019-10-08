//
//  VideoCommentCell.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/5.
//  Copyright © 2018 mh. All rights reserved.
//

#import "VideoCommentCell.h"

@interface VideoCommentCell ()

@property(nonatomic,strong)CommentCellContent * cellContent;

//@property(nonatomic,strong)UIImageView * headerImage;//头像
//@property(nonatomic,strong)UILabel * nameLab;//名字
//@property(nonatomic,strong)YYLabel * contentLab;//评论内容
//
//@property(nonatomic,strong)UIImageView * likeImage;//点赞图标
//@property(nonatomic,strong)UILabel * likeNumLab;//点赞数量

@end

@implementation VideoCommentCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.cellContent = [[CommentCellContent alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:self.cellContent];
        self.cellContent.sd_layout.leftEqualToView(self.contentView).topEqualToView(self.contentView).rightEqualToView(self.contentView).bottomEqualToView(self.contentView);
    }
    return self;
}
- (void)setModel:(CommentModel *)model
{
    _model = model;
    self.cellContent.model = model;
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



@interface CommentCellContent ()

@property(nonatomic,strong)UIImageView * headerImage;//头像
@property(nonatomic,strong)UILabel * nameLab;//名字
@property(nonatomic,strong)YYLabel * contentLab;//评论内容

@property(nonatomic,strong)UIImageView * likeImage;//点赞图标
@property(nonatomic,strong)UILabel * likeNumLab;//点赞数量

@end

@implementation CommentCellContent


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CommentLayout * layout = [[CommentLayout alloc] init];
        
        self.headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(layout.userHeader_left, layout.userHeader_top, layout.userHeader_width, layout.userHeader_width)];
        self.headerImage.contentMode = UIViewContentModeScaleAspectFill;
        self.headerImage.clipsToBounds = YES;
        self.headerImage.layer.cornerRadius = layout.userHeader_width/2;
        self.headerImage.layer.masksToBounds = YES;
        [self addSubview:self.headerImage];
        
        self.nameLab = [UILabel labTextColor:layout.userName_color font:[UIFont systemFontOfSize:layout.userName_fontSize] aligent:NSTextAlignmentLeft];
        self.nameLab.numberOfLines = 1;
        [self addSubview:self.nameLab];
        self.nameLab.sd_layout.leftSpaceToView(self.headerImage, layout.userName_header).topSpaceToView(self, layout.userName_top).rightSpaceToView(self, layout.userName_right).heightIs(layout.userName_height);
        
        self.contentLab = [YYLabel new];
        self.contentLab.frame = CGRectMake(CGRectGetMaxX(self.headerImage.frame) + layout.content_header, layout.userName_top + layout.userName_height + layout.content_name, Screen_WIDTH - layout.userHeader_left - layout.userHeader_width - layout.content_header - layout.content_right , 0);
        self.contentLab.textVerticalAlignment = YYTextVerticalAlignmentTop;
        self.contentLab.displaysAsynchronously = YES;
        self.contentLab.ignoreCommonProperties = YES;
        self.contentLab.fadeOnAsynchronouslyDisplay = NO;
        self.contentLab.fadeOnHighlight = NO;
        [self addSubview:self.contentLab];
        
        self.likeImage = [[UIImageView alloc] init];
        self.likeImage.contentMode = UIViewContentModeScaleAspectFit;
        self.likeImage.clipsToBounds = YES;
        [self addSubview:self.likeImage];
        self.likeImage.sd_layout.rightSpaceToView(self, Width(15)).topSpaceToView(self, Width(20)).widthIs(Width(20)).heightEqualToWidth();
        
        self.likeNumLab = [UILabel labTextColor:[UIColor grayColor] font:FONT(13) aligent:NSTextAlignmentCenter];
        self.likeNumLab.numberOfLines = 1;
        [self addSubview:self.likeNumLab];
        self.likeNumLab.sd_layout.rightSpaceToView(self, 0).topSpaceToView(self.likeImage, 0).widthIs(Width(50)).heightIs(Width(18));
    }
    return self;
}
-(void)setModel:(CommentModel *)model
{
    _model = model;
    
    [self.headerImage yy_setImageWithURL:[NSURL URLWithString:model.userimage] placeholder:nil];
    self.nameLab.text = [NSString stringWithFormat:@"@%@",model.username];
    
    CGRect contentRect = self.contentLab.frame;
    contentRect.size.height = model.contentHeight;
    self.contentLab.frame = contentRect;
    self.contentLab.textLayout = model.contentTextLayout;
    self.contentLab.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        
    };
    
    if (model.beZan) {
        self.likeImage.image = [UIImage imageNamed:@"home_lineSelected"];
    }else{
        self.likeImage.image = [UIImage imageNamed:@"home_likeUnSelected"];
    }
    self.likeNumLab.text = [NSString stringWithFormat:@"%ld",model.zanNum];
}
@end
