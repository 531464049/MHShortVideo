//
//  BDHotVideoCell.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/11.
//  Copyright © 2018 mh. All rights reserved.
//

#import "BDHotVideoCell.h"

@interface BDHotVideoCell ()

@property(nonatomic,strong)UILabel * indexLab;//排序lab
@property(nonatomic,strong)UIImageView * videoPreIamge;//视频预览图
@property(nonatomic,strong)UILabel * searchKeyLab;//搜索关键词lab
@property(nonatomic,strong)UILabel * userNameLab;//用户名lab
@property(nonatomic,strong)UILabel * searchTimesLab;//搜索次数lab
@property(nonatomic,strong)UIImageView * hotIcon;//热搜标志

@end

@implementation BDHotVideoCell

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
        
        self.videoPreIamge = [[UIImageView alloc] init];
        self.videoPreIamge.contentMode = UIViewContentModeScaleAspectFill;
        self.videoPreIamge.clipsToBounds = YES;
        self.videoPreIamge.layer.cornerRadius = 4;
        self.videoPreIamge.layer.masksToBounds = YES;
        [self.contentView addSubview:self.videoPreIamge];
        self.videoPreIamge.sd_layout.leftSpaceToView(self.indexLab, 0).topSpaceToView(self.contentView, 10).bottomSpaceToView(self.contentView, 10).widthIs(Width(65));
        
        self.searchKeyLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(15) aligent:NSTextAlignmentLeft];
        self.searchKeyLab.numberOfLines = 0;
        [self.contentView addSubview:self.searchKeyLab];
        self.searchKeyLab.sd_layout.leftSpaceToView(self.videoPreIamge, 15).topSpaceToView(self.contentView, 10).rightSpaceToView(self.contentView, Width(30)).heightIs(Width(55));
        
        self.userNameLab = [UILabel labTextColor:[UIColor grayColor] font:FONT(14) aligent:NSTextAlignmentLeft];
        self.userNameLab.numberOfLines = 1;
        [self.contentView addSubview:self.userNameLab];
        self.userNameLab.sd_layout.leftSpaceToView(self.videoPreIamge, 15).topSpaceToView(self.searchKeyLab, 5).rightSpaceToView(self.contentView, Width(100)).heightIs(Width(25));
        
        self.searchTimesLab = [UILabel labTextColor:[UIColor grayColor] font:FONT(14) aligent:NSTextAlignmentRight];
        self.searchTimesLab.numberOfLines = 1;
        [self.contentView addSubview:self.searchTimesLab];
        self.searchTimesLab.sd_layout.rightSpaceToView(self.contentView, Width(15)).centerYEqualToView(self.userNameLab).heightIs(20);
        [self.searchTimesLab setSingleLineAutoResizeWithMaxWidth:Width(80)];
        
        self.hotIcon = [[UIImageView alloc] init];
        self.hotIcon.backgroundColor = [UIColor random_Color];
        self.hotIcon.contentMode = UIViewContentModeScaleAspectFit;
        self.hotIcon.clipsToBounds = YES;
        [self.contentView addSubview:self.hotIcon];
        self.hotIcon.sd_layout.rightSpaceToView(self.searchTimesLab, 5).centerYEqualToView(self.searchTimesLab).widthIs(15).heightEqualToWidth();
    }
    return self;
}
- (void)setBdIndex:(NSInteger)bdIndex
{
    _bdIndex = bdIndex;
    
    self.indexLab.text = [NSString stringWithFormat:@"%ld.",bdIndex];
    if (bdIndex > 3) {
        self.indexLab.textColor = [UIColor grayColor];
    }else{
        self.indexLab.textColor = [UIColor base_yellow_color];
    }
    [self.videoPreIamge yy_setImageWithURL:[NSURL URLWithString:[self t_images:bdIndex%10]] placeholder:nil];
    self.searchKeyLab.text = @"这是谁搞的，说出来我保证不打死你";
    self.userNameLab.text = @"二狗子";
    self.searchTimesLab.text = @"234.5w";
}
-(NSString *)t_images:(NSInteger)index
{
    NSArray * arr = @[
                      @"https://img.xiaohua.com/picture/201811266367884726093581093832945.jpg",
                      @"https://img.xiaohua.com/Picture/0/11/11205_20180526024238883_0.jpg",
                      @"https://img.xiaohua.com/picture/201811296367910506009836023194005.jpg",
                      @"https://img.xiaohua.com/Picture/0/13/13175_20180525214554225_0.jpg",
                      @"https://img.xiaohua.com/Picture/0/15/15854_20180525150149323_0.jpg",
                      @"https://img.xiaohua.com/Picture/0/103/103172_20180520005428048_0.jpg",
                      @"https://img.xiaohua.com/picture/201811306367919210476342532131195.jpeg",
                      @"https://img.xiaohua.com/Picture/0/28/28635_20180524194832739_0.jpg",
                      @"https://img.xiaohua.com/Picture/0/48/48488_20180516144029305_0.jpg",
                      @"https://img.xiaohua.com/Picture/0/16/16199_20180525141023968_0.jpg"];
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
