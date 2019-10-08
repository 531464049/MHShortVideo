//
//  ATUserCell.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/29.
//  Copyright © 2018 mh. All rights reserved.
//

#import "ATUserCell.h"

@interface ATUserCell ()

@property(nonatomic,strong)UIImageView * headerImage;
@property(nonatomic,strong)UILabel * nameLab;
@property(nonatomic,strong)UILabel * introduceLab;

@end

@implementation ATUserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.headerImage = [[UIImageView alloc] init];
        self.headerImage.frame = CGRectMake(0, 0, Width(50), Width(50));
        self.headerImage.center = CGPointMake(Width(15) + Width(25), Width(75)/2);
        self.headerImage.contentMode = UIViewContentModeScaleAspectFill;
        self.headerImage.clipsToBounds = YES;
        self.headerImage.layer.cornerRadius = Width(25);
        self.headerImage.layer.masksToBounds = YES;
        [self.contentView addSubview:self.headerImage];
        
        self.nameLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(16) aligent:NSTextAlignmentLeft];
        self.nameLab.frame = CGRectMake(CGRectGetMaxX(self.headerImage.frame) + Width(12), CGRectGetMinY(self.headerImage.frame), Screen_WIDTH - (CGRectGetMaxX(self.headerImage.frame) + Width(12)) - Width(15),Width(30));
        [self.contentView addSubview:self.nameLab];
        
        self.introduceLab = [UILabel labTextColor:RGB(118, 118, 121) font:FONT(14) aligent:NSTextAlignmentLeft];
        self.introduceLab.frame = CGRectMake(CGRectGetMaxX(self.headerImage.frame) + Width(12), CGRectGetMaxY(self.nameLab.frame), Screen_WIDTH - (CGRectGetMaxX(self.headerImage.frame) + Width(12)) - Width(15), Width(20));
        [self.contentView addSubview:self.introduceLab];
    }
    return self;
}
- (void)setModel:(UserModel *)model
{
    _model = model;
    
    [self.headerImage yy_setImageWithURL:[NSURL URLWithString:model.userHeaderImage] placeholder:nil];
    
    self.nameLab.text = model.userName;
    self.introduceLab.text = @"这个人很懒，什么都没留下";
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


