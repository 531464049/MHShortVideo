//
//  SearchRecodeCell.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/13.
//  Copyright © 2018 mh. All rights reserved.
//

#import "SearchRecodeCell.h"

@interface SearchRecodeCell ()

@property(nonatomic,strong)UILabel * searchStrLab;

@end

@implementation SearchRecodeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView * img = [[UIImageView alloc] init];
        img.backgroundColor = [UIColor grayColor];
        img.clipsToBounds = YES;
        img.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:img];
        img.sd_layout.leftSpaceToView(self.contentView, Width(15)).centerYEqualToView(self.contentView).widthIs(20).heightEqualToWidth();
        
        UIButton * delBtn = [UIButton buttonWithType:0];
        [delBtn setImage:[UIImage imageNamed:@"common_close"] forState:0];
        [delBtn addTarget:self action:@selector(delItemCLick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:delBtn];
        delBtn.sd_layout.rightSpaceToView(self.contentView, Width(5)).centerYEqualToView(self.contentView).widthIs(Width(40)).heightEqualToWidth();
        
        self.searchStrLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(15) aligent:NSTextAlignmentLeft];
        self.searchStrLab.numberOfLines = 1;
        [self.contentView addSubview:self.searchStrLab];
        self.searchStrLab.sd_layout.leftSpaceToView(img, 10).rightSpaceToView(delBtn, 10).centerYEqualToView(self.contentView).heightIs(20);
    }
    return self;
}
- (void)setRecodeStr:(NSString *)recodeStr
{
    _recodeStr = recodeStr;
    self.searchStrLab.text = recodeStr;
}
#pragma mark - 删除
-(void)delItemCLick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchRecodeCellDelete:)]) {
        [self.delegate searchRecodeCellDelete:self.cellIndex];
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
