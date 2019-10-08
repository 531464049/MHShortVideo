//
//  BDHotSearchCell.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/11.
//  Copyright © 2018 mh. All rights reserved.
//

#import "BDHotSearchCell.h"

@interface BDHotSearchCell ()

@property(nonatomic,strong)UILabel * indexLab;//排序lab
@property(nonatomic,strong)UILabel * searchKeyLab;//搜索关键词lab
@property(nonatomic,strong)UILabel * searchTimesLab;//搜索次数lab
@property(nonatomic,strong)UIImageView * hotIcon;//热搜标志

@end

@implementation BDHotSearchCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.indexLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(15) aligent:NSTextAlignmentCenter];
        self.indexLab.numberOfLines = 1;
        [self.contentView addSubview:self.indexLab];
        self.indexLab.sd_layout.leftSpaceToView(self.contentView, 0).centerYEqualToView(self.contentView).widthIs(Width(40)).heightIs(20);
        
        self.searchKeyLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(15) aligent:NSTextAlignmentLeft];
        self.searchKeyLab.numberOfLines = 1;
        [self.contentView addSubview:self.searchKeyLab];
        self.searchKeyLab.sd_layout.leftSpaceToView(self.indexLab, 0).centerYEqualToView(self.indexLab).heightIs(20).rightSpaceToView(self.contentView, Width(100));
        
        self.searchTimesLab = [UILabel labTextColor:[UIColor grayColor] font:FONT(14) aligent:NSTextAlignmentRight];
        self.searchTimesLab.numberOfLines = 1;
        [self.contentView addSubview:self.searchTimesLab];
        self.searchTimesLab.sd_layout.rightSpaceToView(self.contentView, Width(15)).centerYEqualToView(self.indexLab).heightIs(20);
        [self.searchTimesLab setSingleLineAutoResizeWithMaxWidth:Width(80)];
        
        self.hotIcon = [[UIImageView alloc] init];
        self.hotIcon.backgroundColor = [UIColor random_Color];
        self.hotIcon.contentMode = UIViewContentModeScaleAspectFit;
        self.hotIcon.clipsToBounds = YES;
        [self.contentView addSubview:self.hotIcon];
        self.hotIcon.sd_layout.rightSpaceToView(self.searchTimesLab, 5).centerYEqualToView(self.indexLab).widthIs(15).heightEqualToWidth();
    }
    return self;
}
- (void)setModel:(BangDanModel *)model
{
    _model = model;
    
    self.indexLab.text = [NSString stringWithFormat:@"%ld.",model.hotIndex];
    if (model.hotIndex > 3) {
        self.indexLab.textColor = [UIColor grayColor];
    }else{
        self.indexLab.textColor = [UIColor base_yellow_color];
    }
    self.searchKeyLab.text = model.hotSearchKey;
    self.searchTimesLab.text = model.searchTimeStr;
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
