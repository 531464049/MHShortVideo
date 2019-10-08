//
//  SRUserCell.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/12.
//  Copyright © 2018 mh. All rights reserved.
//

#import "SRUserCell.h"

@interface SRUserCell ()

@property(nonatomic,strong)UIImageView * headerImage;//头像
@property(nonatomic,strong)YYLabel * nameLab;//名字
@property(nonatomic,strong)UILabel * centerLab;
@property(nonatomic,strong)UILabel * desLab;
@property(nonatomic,strong)UIButton * focusBtn;

@end

@implementation SRUserCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.headerImage = [[UIImageView alloc] init];
        self.headerImage.contentMode = UIViewContentModeScaleAspectFill;
        self.headerImage.clipsToBounds = YES;
        self.headerImage.layer.cornerRadius = Width(55)/2;
        self.headerImage.layer.masksToBounds = YES;
        [self.contentView addSubview:self.headerImage];
        self.headerImage.sd_layout.leftSpaceToView(self.contentView, Width(15)).topSpaceToView(self.contentView, Width(15)).bottomSpaceToView(self.contentView, Width(15)).widthEqualToHeight();
        [self.headerImage updateLayout];
        

        self.centerLab = [UILabel labTextColor:[UIColor grayColor] font:FONT(14) aligent:NSTextAlignmentLeft];
        self.centerLab.numberOfLines = 1;
        [self.contentView addSubview:self.centerLab];
        self.centerLab.sd_layout.leftSpaceToView(self.headerImage, 10).centerYEqualToView(self.headerImage).rightSpaceToView(self.contentView, Width(110)).heightIs(Width(20));
        
        self.nameLab = [[YYLabel alloc] init];
        self.nameLab.textAlignment = NSTextAlignmentLeft;
        self.nameLab.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        self.nameLab.numberOfLines = 1;
        [self.contentView addSubview:self.nameLab];
        self.nameLab.sd_layout.leftSpaceToView(self.headerImage, 10).bottomSpaceToView(self.centerLab, 0).rightSpaceToView(self.contentView, Width(110)).heightIs(Width(20));
        
        self.desLab = [UILabel labTextColor:[UIColor grayColor] font:FONT(14) aligent:NSTextAlignmentLeft];
        self.desLab.numberOfLines = 1;
        [self.contentView addSubview:self.desLab];
        self.desLab.sd_layout.leftSpaceToView(self.headerImage, 10).topSpaceToView(self.centerLab, 0).rightSpaceToView(self.contentView, Width(110)).heightIs(Width(20));
        
        self.focusBtn = [UIButton buttonWithType:0];
        self.focusBtn.backgroundColor = [UIColor redColor];
        [self.focusBtn setTitle:@"关注" forState:0];
        [self.focusBtn setTitleColor:[UIColor whiteColor] forState:0];
        self.focusBtn.titleLabel.font = FONT(14);
        self.focusBtn.layer.cornerRadius = 4;
        self.focusBtn.layer.masksToBounds = YES;
        [self.contentView addSubview:self.focusBtn];
        self.focusBtn.sd_layout.rightSpaceToView(self.contentView, Width(15)).centerYEqualToView(self.headerImage).widthIs(Width(80)).heightIs(Width(28));
    }
    return self;
}
- (void)setCellIndex:(NSInteger)cellIndex
{
    _cellIndex = cellIndex;
    
    [self.headerImage yy_setImageWithURL:[NSURL URLWithString:@"http://pic32.photophoto.cn/20140819/0008020285038599_b.jpg"] placeholder:nil];
    self.centerLab.text = @"痘印好:123124423 粉丝:2345";
    self.desLab.text = @"二狗子的心路历程";
    
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
