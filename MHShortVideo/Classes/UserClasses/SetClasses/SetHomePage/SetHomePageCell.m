//
//  SetHomePageCell.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/21.
//  Copyright © 2018 mh. All rights reserved.
//

#import "SetHomePageCell.h"

@interface SetHomePageCell ()

@property(nonatomic,strong)UIImageView * iconImage;
@property(nonatomic,strong)UILabel * nameLab;
@property(nonatomic,strong)UIImageView * rightIcon;
@property(nonatomic,strong)UILabel * rightDesLab;

@end

@implementation SetHomePageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(Width(10), 0, Width(20), Width(50))];
        self.iconImage.contentMode = UIViewContentModeScaleAspectFit;
        self.iconImage.clipsToBounds = YES;
        [self.contentView addSubview:self.iconImage];
        
        self.nameLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(15) aligent:NSTextAlignmentLeft];
        [self.contentView addSubview:self.nameLab];
        self.nameLab.sd_layout.leftSpaceToView(self.iconImage, Width(10)).topSpaceToView(self.contentView, Width(5)).bottomSpaceToView(self.contentView, Width(5)).rightSpaceToView(self.contentView, Screen_WIDTH/2);
        
        self.rightIcon = [[UIImageView alloc] init];
        self.rightIcon.contentMode = UIViewContentModeScaleAspectFit;
        self.rightIcon.clipsToBounds = YES;
        self.rightIcon.image = [UIImage imageNamed:@"common_next"];
        [self.contentView addSubview:self.rightIcon];
        self.rightIcon.sd_layout.rightSpaceToView(self.contentView, Width(15)).centerYEqualToView(self.contentView).widthIs(Width(15)).heightEqualToWidth();
        
        self.rightDesLab = [UILabel labTextColor:[UIColor grayColor] font:FONT(14) aligent:NSTextAlignmentRight];
        [self.contentView addSubview:self.rightDesLab];
        self.rightDesLab.sd_layout.rightSpaceToView(self.rightIcon, Width(10)).centerYEqualToView(self.contentView).heightIs(Width(20)).leftSpaceToView(self.nameLab, 10);
    }
    return self;
}
-(void)setCellIconName:(NSString *)cellIconName
{
    _cellIconName = cellIconName;
    self.iconImage.image = [UIImage imageNamed:cellIconName];
}
-(void)setCellTitleName:(NSString *)cellTitleName
{
    _cellTitleName = cellTitleName;
    self.nameLab.text = cellTitleName;
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
