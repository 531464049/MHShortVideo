//
//  AddLocationCell.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/3.
//  Copyright © 2018 mh. All rights reserved.
//

#import "AddLocationCell.h"

@interface AddLocationCell ()

@property(nonatomic,strong)UILabel * locationNameLab;//位置名称
@property(nonatomic,strong)UILabel * locationDetailLab;//位置详细地址
@property(nonatomic,strong)UILabel * locationDistanceLab;//距离

@end

@implementation AddLocationCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.locationNameLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(16) aligent:NSTextAlignmentLeft];
        self.locationNameLab.numberOfLines = 1;
        [self.contentView addSubview:self.locationNameLab];
        self.locationNameLab.frame = CGRectMake(Width(15), Width(67)/2 - Width(26), Screen_WIDTH - Width(15) - Width(72), Width(26));
        
        self.locationDetailLab = [UILabel labTextColor:[UIColor grayColor] font:FONT(14) aligent:NSTextAlignmentLeft];
        self.locationDetailLab.numberOfLines = 1;
        [self.contentView addSubview:self.locationDetailLab];
        self.locationDetailLab.frame = CGRectMake(Width(15), Width(67)/2, Screen_WIDTH - Width(15) - Width(72), Width(22));
        
        self.locationDistanceLab = [UILabel labTextColor:[UIColor grayColor] font:FONT(14) aligent:NSTextAlignmentRight];
        self.locationDistanceLab.numberOfLines = 1;
        [self.contentView addSubview:self.locationDistanceLab];
        self.locationDistanceLab.frame = CGRectMake(Screen_WIDTH - Width(72), Width(67)/2, Width(72) - Width(15), Width(22));
    }
    return self;
}
- (void)setModel:(LocationModel *)model
{
    _model = model;
    
    self.locationNameLab.text = model.locationNmae;
    self.locationDetailLab.text = model.locationDetail;
    self.locationDistanceLab.text = [NSString stringWithFormat:@"%ldm",model.distance];
    if (model.isUserCity) {
        self.locationNameLab.frame = CGRectMake(Width(15), Width(67)/2 - Width(26)/2, Screen_WIDTH - Width(15) - Width(72), Width(26));

        self.locationDetailLab.hidden = YES;
        self.locationDistanceLab.hidden = YES;
    }else{
        self.locationNameLab.frame = CGRectMake(Width(15), Width(67)/2 - Width(26), Screen_WIDTH - Width(15) - Width(72), Width(26));
        
        self.locationDetailLab.hidden = NO;
        self.locationDistanceLab.hidden = NO;
    }
    if (model.searchKey.length > 0) {
        self.locationNameLab.text = model.locationNmae;
        NSRange range = [model.locationNmae rangeOfString:model.searchKey];
        if (range.location != NSNotFound) {
            
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:model.locationNmae];
            [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:range];
            self.locationNameLab.attributedText = attrStr;
            
        }else{
            self.locationNameLab.text = model.locationNmae;
        }
    }else{
        self.locationNameLab.text = model.locationNmae;
    }
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


@implementation LocationModel




@end
