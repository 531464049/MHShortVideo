//
//  MyFanceCell.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/14.
//  Copyright © 2018 mh. All rights reserved.
//

#import "MyFanceCell.h"

@interface MyFanceCell ()

@property(nonatomic,strong)UIImageView * userImage;
@property(nonatomic,strong)UILabel * userNameLab;
@property(nonatomic,strong)UILabel * desLab;
@property(nonatomic,strong)UILabel * timeLab;
@property(nonatomic,strong)UIButton * foucsBtn;

@end

@implementation MyFanceCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.userImage = [[UIImageView alloc] init];
        self.userImage.contentMode = UIViewContentModeScaleAspectFill;
        self.userImage.clipsToBounds = YES;
        self.userImage.layer.cornerRadius = Width(25);
        self.userImage.layer.masksToBounds = YES;
        [self.contentView addSubview:self.userImage];
        self.userImage.sd_layout.leftSpaceToView(self.contentView, Width(15)).topSpaceToView(self.contentView, Width(10)).widthIs(Width(50)).heightEqualToWidth();
        
        self.userNameLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(15) aligent:NSTextAlignmentLeft];
        self.userNameLab.numberOfLines = 1;
        [self.contentView addSubview:self.userNameLab];
        self.userNameLab.sd_layout.leftSpaceToView(self.userImage, 10).topSpaceToView(self.contentView, Width(10)).rightSpaceToView(self.contentView, Width(110)).heightIs(Width(25));
        
        self.desLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(15) aligent:NSTextAlignmentLeft];
        self.desLab.numberOfLines = 1;
        [self.contentView addSubview:self.desLab];
        self.desLab.sd_layout.leftSpaceToView(self.userImage, 10).topSpaceToView(self.userNameLab, 0).rightSpaceToView(self.contentView, Width(110)).heightIs(Width(25));
        
        self.timeLab = [UILabel labTextColor:[UIColor grayColor] font:FONT(13) aligent:NSTextAlignmentLeft];
        self.timeLab.numberOfLines = 1;
        [self.contentView addSubview:self.timeLab];
        self.timeLab.sd_layout.leftSpaceToView(self.userImage, 10).topSpaceToView(self.desLab, 0).rightSpaceToView(self.contentView, Width(15)).heightIs(Width(30));
        
        self.foucsBtn = [UIButton buttonWithType:0];
        self.foucsBtn.backgroundColor = [UIColor grayColor];
        [self.foucsBtn setTitle:@"互相关注" forState:0];
        [self.foucsBtn setTitleColor:[UIColor whiteColor] forState:0];
        self.foucsBtn.titleLabel.font = FONT(14);
        self.foucsBtn.layer.cornerRadius = 4;
        self.foucsBtn.layer.masksToBounds = YES;
        [self.foucsBtn addTarget:self action:@selector(focusItemClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.foucsBtn];
        self.foucsBtn.sd_layout.rightSpaceToView(self.contentView, Width(15)).centerYEqualToView(self.userImage).widthIs(Width(80)).heightIs(Width(30));
    }
    return self;
}
#pragma mark - 关注按钮点击
-(void)focusItemClick
{
    
}
-(void)setModel:(MyFanceModel *)model
{
    _model = model;
    
    [self.userImage yy_setImageWithURL:[NSURL URLWithString:model.userHeaderImage] placeholder:nil];
    self.userNameLab.text = model.userName;
    self.desLab.text = @"关注了你";
    self.timeLab.text = model.timeStr;
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
