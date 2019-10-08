//
//  HomeCityPageCell.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/7.
//  Copyright © 2018 mh. All rights reserved.
//

#import "HomeCityPageCell.h"
@interface HomeCityPageCell ()

@property(nonatomic,strong)UIImageView * imgView;//封面
@property(nonatomic,strong)UIImageView * distanceIcon;//距离图标
@property(nonatomic,strong)UILabel * distanceLab;//距离lab
@property(nonatomic,strong)UIImageView * locationIcon;//位置图标
@property(nonatomic,strong)UILabel * locationLab;//位置lab
@property(nonatomic,strong)UILabel * titleLab;//标题lab
@property(nonatomic,strong)UIImageView * userHeaderIcon;//用户头像
@property(nonatomic,strong)UILabel * userNameLab;//用户名字
@property(nonatomic,strong)UIImageView * zanIcon;//点赞图标
@property(nonatomic,strong)UILabel * zanNumLab;//点赞数量
@end

@implementation HomeCityPageCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
//        CGFloat width = CGRectGetWidth(self.frame);
//        CGFloat height = CGRectGetHeight(self.frame);
        //预览图
        self.imgView = [[UIImageView alloc] init];
        self.imgView.contentMode = UIViewContentModeScaleAspectFill;
        self.imgView.clipsToBounds = YES;
        self.imgView.layer.cornerRadius = 4;
        self.imgView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.imgView];
        //距离图标
        self.distanceIcon = [[UIImageView alloc] init];
        self.distanceIcon.contentMode = UIViewContentModeScaleAspectFit;
        self.distanceIcon.clipsToBounds = YES;
        self.distanceIcon.image = [UIImage imageNamed:@"location"];
        [self.imgView addSubview:self.distanceIcon];
        //距离lab
        self.distanceLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(13) aligent:NSTextAlignmentLeft];
        self.distanceLab.numberOfLines = 1;
        [self.imgView addSubview:self.distanceLab];
        //位置图标
        self.locationIcon = [[UIImageView alloc] init];
        self.locationIcon.contentMode = UIViewContentModeScaleAspectFit;
        self.locationIcon.clipsToBounds = YES;
        self.locationIcon.image = [UIImage imageNamed:@"location"];
        [self.contentView addSubview:self.locationIcon];
        //位置lab
        self.locationLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(14) aligent:NSTextAlignmentLeft];
        self.locationLab.numberOfLines = 1;
        [self.contentView addSubview:self.locationLab];
        //标题lab
        self.titleLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(14) aligent:NSTextAlignmentLeft];
        self.titleLab.numberOfLines = 0;
        [self.contentView addSubview:self.titleLab];
        //用户头像
        self.userHeaderIcon = [[UIImageView alloc] init];
        self.userHeaderIcon.contentMode = UIViewContentModeScaleAspectFill;
        self.userHeaderIcon.clipsToBounds = YES;
        self.userHeaderIcon.layer.cornerRadius = Width(15);
        self.userHeaderIcon.layer.masksToBounds = YES;
        [self.contentView addSubview:self.userHeaderIcon];
        //用户名字
        self.userNameLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(14) aligent:NSTextAlignmentLeft];
        self.userNameLab.numberOfLines = 1;
        [self.contentView addSubview:self.userNameLab];
        //点赞图标
        self.zanIcon = [[UIImageView alloc] init];
        self.zanIcon.contentMode = UIViewContentModeScaleAspectFit;
        self.zanIcon.clipsToBounds = YES;
        self.zanIcon.image = [UIImage imageNamed:@"home_likeUnSelected"];
        [self.contentView addSubview:self.zanIcon];
        //点赞数量
        self.zanNumLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(13) aligent:NSTextAlignmentRight];
        self.zanNumLab.numberOfLines = 1;
        [self.contentView addSubview:self.zanNumLab];
    }
    return self;
}
- (void)setModel:(HomeCityCellModel *)model
{
    _model = model;
    [self.imgView yy_setImageWithURL:[NSURL URLWithString:model.preImageUrl] placeholder:nil];
    self.distanceLab.text = [NSString stringWithFormat:@"%.1fkm",model.distance];
    self.locationLab.text = model.location;
    self.titleLab.attributedText = [model.title attributedStr:self.titleLab.font textColor:self.titleLab.textColor lineSpace:7 keming:0 aligent:NSTextAlignmentLeft];
    [self.userHeaderIcon yy_setImageWithURL:[NSURL URLWithString:model.userImage] placeholder:nil];
    self.userNameLab.text = model.userName;
    self.zanNumLab.text = [NSString stringWithFormat:@"%ld",model.zanNum];

    self.imgView.sd_layout.leftEqualToView(self.contentView).topEqualToView(self.contentView).rightEqualToView(self.contentView).heightIs(model.preImageHeight);
    self.distanceIcon.sd_layout.bottomSpaceToView(self.imgView, 5).leftSpaceToView(self.imgView, 10).widthIs(20).heightEqualToWidth();
    self.distanceLab.sd_layout.leftSpaceToView(self.distanceIcon, 5).centerYEqualToView(self.distanceIcon).rightSpaceToView(self.imgView, 20).heightIs(20);
    self.locationIcon.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.imgView, Width(5)).widthIs(Width(20)).heightEqualToWidth();
    self.locationLab.sd_layout.leftSpaceToView(self.locationIcon, 2).centerYEqualToView(self.locationIcon).rightSpaceToView(self.contentView, 5).heightIs(Width(20));
    self.titleLab.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.locationIcon, 5).rightSpaceToView(self.contentView, 0).heightIs(model.titleHeight);
    self.userHeaderIcon.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.titleLab, 0).widthIs(Width(30)).heightEqualToWidth();
    self.userNameLab.sd_layout.leftSpaceToView(self.userHeaderIcon, 3).centerYEqualToView(self.userHeaderIcon).widthIs(self.frame.size.width/2).heightIs(20);
    self.zanNumLab.sd_layout.rightSpaceToView(self.contentView, 10).centerYEqualToView(self.userHeaderIcon).heightIs(20);
    [self.zanNumLab setSingleLineAutoResizeWithMaxWidth:self.frame.size.width/3];
    self.zanIcon.sd_layout.rightSpaceToView(self.zanNumLab, 5).centerYEqualToView(self.userHeaderIcon).widthIs(20).heightEqualToWidth();
}


@end
