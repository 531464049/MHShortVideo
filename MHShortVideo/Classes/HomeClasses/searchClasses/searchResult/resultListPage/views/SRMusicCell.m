//
//  SRMusicCell.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/12.
//  Copyright © 2018 mh. All rights reserved.
//

#import "SRMusicCell.h"

@interface SRMusicCell ()

@property(nonatomic,strong)UIImageView * musicImage;
@property(nonatomic,strong)YYLabel * nameLab;//名字
@property(nonatomic,strong)UILabel * desLab;
@property(nonatomic,strong)UILabel * useNumLab;

@end

@implementation SRMusicCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.musicImage = [[UIImageView alloc] init];
        self.musicImage.contentMode = UIViewContentModeScaleAspectFill;
        self.musicImage.clipsToBounds = YES;
        self.musicImage.layer.cornerRadius = 8;
        self.musicImage.layer.masksToBounds = YES;
        [self.contentView addSubview:self.musicImage];
        self.musicImage.sd_layout.leftSpaceToView(self.contentView, Width(15)).topSpaceToView(self.contentView, Width(10)).bottomSpaceToView(self.contentView, Width(10)).widthEqualToHeight();
        [self.musicImage updateLayout];
        
        
        self.nameLab = [[YYLabel alloc] init];
        self.nameLab.textAlignment = NSTextAlignmentLeft;
        self.nameLab.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        self.nameLab.numberOfLines = 1;
        [self.contentView addSubview:self.nameLab];
        self.nameLab.sd_layout.leftSpaceToView(self.musicImage, 10).topSpaceToView(self.contentView, Width(12)).rightSpaceToView(self.contentView, Width(15)).heightIs(Width(24));
        
        self.desLab = [UILabel labTextColor:[UIColor grayColor] font:FONT(14) aligent:NSTextAlignmentLeft];
        self.desLab.numberOfLines = 1;
        [self.contentView addSubview:self.desLab];
        self.desLab.sd_layout.leftSpaceToView(self.musicImage, 10).topSpaceToView(self.nameLab, 0).heightIs(Width(20));
        [self.desLab setSingleLineAutoResizeWithMaxWidth:Width(175)];
        
        self.useNumLab = [UILabel labTextColor:[UIColor grayColor] font:FONT(14) aligent:NSTextAlignmentRight];
        self.useNumLab.numberOfLines = 1;
        [self.contentView addSubview:self.useNumLab];
        self.useNumLab.sd_layout.rightSpaceToView(self.contentView, Width(15)).centerYEqualToView(self.desLab).heightIs(Width(20));
        [self.useNumLab setSingleLineAutoResizeWithMaxWidth:Width(120)];
    }
    return self;
}
- (void)setCellIndex:(NSInteger)cellIndex
{
    _cellIndex = cellIndex;
    
    [self.musicImage yy_setImageWithURL:[NSURL URLWithString:@"http://pic32.photophoto.cn/20140819/0008020285038599_b.jpg"] placeholder:nil];
    self.desLab.text = @"二狗子的心路历程";
    self.useNumLab.text = @"23.4w人使用";
    
    NSString * titleStr = [NSString stringWithFormat:@"@%@",[self t_title:cellIndex%10]];
    NSString * key = @"二狗子";
    
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc] initWithString:titleStr];
    attribute.yy_font = [UIFont systemFontOfSize:16];
    attribute.yy_color = [UIColor whiteColor];
    
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:key options:kNilOptions error:NULL];
    NSArray *atResults = [regex matchesInString:attribute.string options:kNilOptions range:attribute.yy_rangeOfAll];
    for (NSTextCheckingResult *at in atResults) {
        if (at.range.location == NSNotFound && at.range.length <= 1) continue;
        if ([attribute yy_attribute:YYTextHighlightAttributeName atIndex:at.range.location] == nil) {
            [attribute yy_setColor:[UIColor base_yellow_color] range:at.range];
        }
    }
    self.nameLab.attributedText = attribute;
}
-(NSString *)t_title:(NSInteger)index
{
    NSArray * arr = @[@"我不是二狗子",@"我是二狗子",@"二狗子不是我",@"我猜是二狗子真真的",@"二狗子的老舅",@"二狗子",@"他说他是二狗子他舅",@"二狗子的大姨妈",@"我们二狗子来了",@"二狗子的大伯"];
    return arr[index];
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
