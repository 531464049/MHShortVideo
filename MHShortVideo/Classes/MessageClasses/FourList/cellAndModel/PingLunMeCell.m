//
//  PingLunMeCell.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/14.
//  Copyright © 2018 mh. All rights reserved.
//

#import "PingLunMeCell.h"

@interface PingLunMeCell ()

@property(nonatomic,strong)UIImageView * userImage;
@property(nonatomic,strong)UILabel * userNameLab;
@property(nonatomic,strong)UILabel * timeLab;
@property(nonatomic,strong)UIImageView * preImage;

@property(nonatomic,strong)YYLabel * contentLab;//评论内容

@end

@implementation PingLunMeCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.userImage = [[UIImageView alloc] init];
        self.userImage.contentMode = UIViewContentModeScaleAspectFill;
        self.userImage.clipsToBounds = YES;
        self.userImage.layer.cornerRadius = Width(25);
        self.userImage.layer.masksToBounds = YES;
        [self.contentView addSubview:self.userImage];
        self.userImage.sd_layout.leftSpaceToView(self.contentView, Width(15)).topSpaceToView(self.contentView, Width(10)).widthIs(Width(50)).heightEqualToWidth();
        
        self.userNameLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(15) aligent:NSTextAlignmentLeft];
        self.userNameLab.numberOfLines = 1;
        [self.contentView addSubview:self.userNameLab];
        self.userNameLab.sd_layout.leftSpaceToView(self.userImage, 10).topSpaceToView(self.contentView, Width(10)).rightSpaceToView(self.contentView, Width(110)).heightIs(Width(25));
        

        self.timeLab = [UILabel labTextColor:[UIColor grayColor] font:FONT(13) aligent:NSTextAlignmentLeft];
        self.timeLab.numberOfLines = 1;
        [self.contentView addSubview:self.timeLab];
        self.timeLab.sd_layout.leftSpaceToView(self.userImage, 10).bottomSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, Width(15)).heightIs(Width(30));
        
        self.preImage = [[UIImageView alloc] init];
        self.preImage.contentMode = UIViewContentModeScaleAspectFill;
        self.preImage.clipsToBounds = YES;
        self.preImage.layer.cornerRadius = 4;
        self.preImage.layer.masksToBounds = YES;
        [self.contentView addSubview:self.preImage];
        self.preImage.sd_layout.rightSpaceToView(self.contentView, Width(15)).topSpaceToView(self.contentView, Width(10)).widthIs(Width(65)).heightEqualToWidth();
        
        self.contentLab = [YYLabel new];
        self.contentLab.textVerticalAlignment = YYTextVerticalAlignmentTop;
        self.contentLab.displaysAsynchronously = YES;
        self.contentLab.ignoreCommonProperties = YES;
        self.contentLab.fadeOnAsynchronouslyDisplay = NO;
        self.contentLab.fadeOnHighlight = NO;
        [self.contentView addSubview:self.contentLab];
        self.contentLab.sd_layout.leftSpaceToView(self.userImage, 10).topSpaceToView(self.userNameLab, 0).rightSpaceToView(self.contentView, Width(110)).bottomSpaceToView(self.timeLab, 0);
    }
    return self;
}
-(void)setModel:(PingLunMeModel *)model
{
    _model = model;
    
    [self.userImage yy_setImageWithURL:[NSURL URLWithString:model.userHeaderImage] placeholder:nil];
    self.userNameLab.text = [NSString stringWithFormat:@"@%@",model.userName];
    self.timeLab.text = [NSString stringWithFormat:@"评论了你的作品 %@",model.timeStr];
    [self.preImage yy_setImageWithURL:[NSURL URLWithString:model.videoPreImage] placeholder:nil];
    
    self.contentLab.textLayout = model.contentTextLayout;
    self.contentLab.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        
    };
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
