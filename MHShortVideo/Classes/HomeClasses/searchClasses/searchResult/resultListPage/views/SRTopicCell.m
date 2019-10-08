//
//  SRTopicCell.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/12.
//  Copyright © 2018 mh. All rights reserved.
//

#import "SRTopicCell.h"

@interface SRTopicCell ()

@property(nonatomic,strong)UIImageView * topicIcon;
@property(nonatomic,strong)YYLabel * topicName;//名字
@property(nonatomic,strong)UILabel * useNumLab;

@end

@implementation SRTopicCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.topicIcon = [[UIImageView alloc] init];
        self.topicIcon.image = [UIImage imageNamed:@"search_topicIcon"];
        self.topicIcon.contentMode = UIViewContentModeScaleAspectFill;
        self.topicIcon.clipsToBounds = YES;
        self.topicIcon.layer.cornerRadius = Width(15);
        self.topicIcon.layer.masksToBounds = YES;
        [self.contentView addSubview:self.topicIcon];
        self.topicIcon.sd_layout.leftSpaceToView(self.contentView, Width(15)).centerYEqualToView(self.contentView).widthIs(Width(30)).heightEqualToWidth();
        [self.topicIcon updateLayout];
        
        
        self.topicName = [[YYLabel alloc] init];
        self.topicName.textAlignment = NSTextAlignmentLeft;
        self.topicName.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        self.topicName.numberOfLines = 1;
        [self.contentView addSubview:self.topicName];
        self.topicName.sd_layout.leftSpaceToView(self.topicIcon, 10).centerYEqualToView(self.contentView).rightSpaceToView(self.contentView, Width(115)).heightIs(Width(20));

        self.useNumLab = [UILabel labTextColor:[UIColor grayColor] font:FONT(14) aligent:NSTextAlignmentRight];
        self.useNumLab.numberOfLines = 1;
        [self.contentView addSubview:self.useNumLab];
        self.useNumLab.sd_layout.rightSpaceToView(self.contentView, Width(15)).centerYEqualToView(self.contentView).heightIs(Width(20)).widthIs(100);
    }
    return self;
}
- (void)setCellIndex:(NSInteger)cellIndex
{
    _cellIndex = cellIndex;
    self.useNumLab.text = @"1234次播放";
    
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
    self.topicName.attributedText = attribute;
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
