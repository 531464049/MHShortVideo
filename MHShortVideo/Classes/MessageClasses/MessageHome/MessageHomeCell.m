//
//  MessageHomeCell.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/14.
//  Copyright © 2018 mh. All rights reserved.
//

#import "MessageHomeCell.h"

@interface MessageHomeCell ()

@property(nonatomic,strong)UIImageView * headerImage;
@property(nonatomic,strong)UILabel * msgTitleLab;
@property(nonatomic,strong)UILabel * msgDesLab;
@property(nonatomic,strong)UILabel * msgTimeLab;

@end

@implementation MessageHomeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.headerImage = [[UIImageView alloc] init];
        self.headerImage.contentMode = UIViewContentModeScaleAspectFill;
        self.headerImage.clipsToBounds = YES;
        self.headerImage.layer.cornerRadius = Width(50)/2;
        self.headerImage.layer.masksToBounds = YES;
        [self.contentView addSubview:self.headerImage];
        self.headerImage.sd_layout.leftSpaceToView(self.contentView, Width(15)).centerYEqualToView(self.contentView).widthIs(Width(50)).heightEqualToWidth();
        
        self.msgTitleLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(16) aligent:NSTextAlignmentLeft];
        self.msgTitleLab.numberOfLines = 1;
        [self.contentView addSubview:self.msgTitleLab];
        self.msgTitleLab.sd_layout.leftSpaceToView(self.headerImage, 10).topSpaceToView(self.contentView, Width(10)).rightSpaceToView(self.contentView, Width(15)).heightIs(Width(25));
        
        self.msgDesLab = [UILabel labTextColor:[UIColor grayColor] font:FONT(14) aligent:NSTextAlignmentLeft];
        self.msgDesLab.numberOfLines = 1;
        [self.contentView addSubview:self.msgDesLab];
        self.msgDesLab.sd_layout.leftSpaceToView(self.headerImage, 10).bottomSpaceToView(self.contentView, Width(10)).rightSpaceToView(self.contentView, Width(15)).heightIs(Width(25));
        
        self.msgTimeLab = [UILabel labTextColor:[UIColor grayColor] font:FONT(14) aligent:NSTextAlignmentRight];
        self.msgTimeLab.numberOfLines = 1;
        [self.contentView addSubview:self.msgTimeLab];
        self.msgTimeLab.sd_layout.rightSpaceToView(self.contentView, Width(15)).centerYEqualToView(self.contentView).heightIs(20);
        [self.msgTimeLab setSingleLineAutoResizeWithMaxWidth:100];
    }
    return self;
}
-(void)setModel:(MessageHomeModel *)model
{
    _model = model;
    
    switch (model.messageType) {
        case HomeMessageTypeNews:
        {
            self.headerImage.image = [UIImage imageNamed:@"messageHome_news"];
            self.msgTitleLab.text = @"资讯助手";
        }
            break;
        case HomeMessageTypeHelper:
        {
            self.headerImage.image = [UIImage imageNamed:@"messageHome_zhushou"];
            self.msgTitleLab.text = @"**小助手";
        }
            break;
        case HomeMessageTypeSystem:
        {
            self.headerImage.image = [UIImage imageNamed:@"messageHome_system"];
            self.msgTitleLab.text = @"系统通知";
        }
            break;
        case HomeMessageTypeUserContact:
        {
            self.msgTitleLab.text = model.userName;
            [self.headerImage yy_setImageWithURL:[NSURL URLWithString:model.userHeaderImage] placeholder:nil];
        }
            break;
        default:
            break;
    }
    self.msgDesLab.text = model.msgStr;
    self.msgTimeLab.text = model.msgTimeStr;
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
