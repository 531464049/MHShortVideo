//
//  UserProductionCell.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/19.
//  Copyright © 2018 mh. All rights reserved.
//

#import "UserProductionCell.h"

@interface UserProductionCell ()

@property(nonatomic,strong)UIImageView * videopreImage;
@property(nonatomic,strong)UIImageView * likeIcon;
@property(nonatomic,strong)UILabel * likeNumLab;

@end

@implementation UserProductionCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        CGFloat width = CGRectGetWidth(self.frame);
        CGFloat height = CGRectGetHeight(self.frame);
        
        self.videopreImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        self.videopreImage.contentMode = UIViewContentModeScaleAspectFill;
        self.videopreImage.clipsToBounds = YES;
        [self.contentView addSubview:self.videopreImage];
        
        self.likeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(Width(10), height - Width(10) - Width(20), Width(20), Width(20))];
        self.likeIcon.contentMode = UIViewContentModeScaleAspectFit;
        self.likeIcon.clipsToBounds = YES;
        self.likeIcon.image = [UIImage imageNamed:@"home_likeUnSelected"];
        [self.contentView addSubview:self.likeIcon];
        
        self.likeNumLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(14) aligent:NSTextAlignmentLeft];
        self.likeNumLab.frame = CGRectMake(Width(35), height - Width(10) - Width(20), width-Width(30) - Width(10), Width(20));
        [self.contentView addSubview:self.likeNumLab];
    }
    return self;
}
-(void)setModel:(UserProductionModel *)model
{
    _model = model;
    
    [self.videopreImage yy_setImageWithURL:[NSURL URLWithString:model.preImage] placeholder:nil];
    self.likeNumLab.text = model.likedNumStr;
}
@end
