//
//  SystemMsgCell.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/14.
//  Copyright © 2018 mh. All rights reserved.
//

#import "SystemMsgCell.h"

@interface SystemMsgCell ()

@property(nonatomic,strong)UIImageView * leftIcon;//左边图标
@property(nonatomic,strong)UILabel * msgTitleLab;//标题
@property(nonatomic,strong)UILabel * msgDesLab;//详情
@property(nonatomic,strong)UILabel * msgTimeLab;//时间

@property(nonatomic,strong)UIImageView * rightImage;//资讯 右边图片
@property(nonatomic,strong)UIButton * rightBtn;//右边参加按钮


@end

@implementation SystemMsgCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        SystemMsgLayout * layout = [[SystemMsgLayout alloc] init];
        
        self.leftIcon = [[UIImageView alloc] init];
        self.leftIcon.contentMode = UIViewContentModeScaleAspectFill;
        self.leftIcon.clipsToBounds = YES;
        self.leftIcon.layer.cornerRadius = layout.iconWidth/2;
        self.leftIcon.layer.masksToBounds = YES;
        [self.contentView addSubview:self.leftIcon];
        self.leftIcon.sd_layout.leftSpaceToView(self.contentView, layout.iconLeft).topSpaceToView(self.contentView, layout.iconTop).widthIs(layout.iconWidth).heightEqualToWidth();
        
        self.msgTitleLab = [UILabel labTextColor:[UIColor whiteColor] font:layout.titleFont aligent:NSTextAlignmentLeft];
        self.msgTitleLab.numberOfLines = 1;
        [self.contentView addSubview:self.msgTitleLab];
        self.msgTitleLab.sd_layout.leftSpaceToView(self.leftIcon, layout.titleLeft).topSpaceToView(self.contentView, layout.titleTop).rightSpaceToView(self.contentView, layout.titleRight).heightIs(layout.titleHeight);
        
        self.msgTimeLab = [UILabel labTextColor:[UIColor grayColor] font:layout.timeFont aligent:NSTextAlignmentLeft];
        self.msgTimeLab.numberOfLines = 1;
        [self.contentView addSubview:self.msgTimeLab];
        self.msgTimeLab.sd_layout.leftSpaceToView(self.leftIcon, layout.titleLeft).bottomSpaceToView(self.contentView, layout.timeBottom).rightSpaceToView(self.contentView, layout.titleRight).heightIs(layout.timeHeight);
        
        self.msgDesLab = [UILabel labTextColor:[UIColor grayColor] font:layout.desFont aligent:NSTextAlignmentLeft];
        self.msgDesLab.numberOfLines = 0;
        [self.contentView addSubview:self.msgDesLab];
        self.msgDesLab.sd_layout.leftSpaceToView(self.leftIcon, layout.titleLeft).topSpaceToView(self.msgTitleLab, layout.desTop).rightSpaceToView(self.contentView, layout.titleRight).bottomSpaceToView(self.msgTimeLab, layout.time_des_Top);
        
        self.rightImage = [[UIImageView alloc] init];
        self.rightImage.contentMode = UIViewContentModeScaleAspectFill;
        self.rightImage.clipsToBounds = YES;
        self.rightImage.layer.cornerRadius = 5;
        self.rightImage.layer.masksToBounds = YES;
        self.rightImage.hidden = YES;
        [self.contentView addSubview:self.rightImage];
        self.rightImage.sd_layout.rightSpaceToView(self.contentView, layout.rightItemRight).topSpaceToView(self.contentView, layout.iconTop).widthIs(layout.rightItemWidth).heightEqualToWidth();
        
        self.rightBtn = [UIButton buttonWithType:0];
        [self.rightBtn setTitle:@"参与" forState:0];
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:0];
        self.rightBtn.titleLabel.font = FONT(14);
        self.rightBtn.backgroundColor = [UIColor redColor];
        [self.rightBtn addTarget:self action:@selector(canyuItemClcik) forControlEvents:UIControlEventTouchUpInside];
        self.rightBtn.hidden = YES;
        [self.contentView addSubview:self.rightBtn];
        self.rightBtn.sd_layout.rightSpaceToView(self.contentView, layout.rightItemRight).topSpaceToView(self.contentView, layout.iconTop).widthIs(layout.rightItemWidth).heightIs(Width(30));
    }
    return self;
}
-(void)setModel:(SystemMsgModel *)model
{
    _model = model;
    
    self.rightImage.hidden = YES;
    self.rightBtn.hidden = YES;
    
    self.msgTitleLab.text = model.msgTitle;
    self.msgDesLab.attributedText = [model.msgDes attributedStr:self.msgDesLab.font textColor:[UIColor grayColor] lineSpace:7 keming:0];
    self.msgTimeLab.text = model.msgTime;
    
    if (model.messageType == HomeMessageTypeNews) {
        
        [self.leftIcon yy_setImageWithURL:[NSURL URLWithString:model.newsTypeIcon] placeholder:nil];
        self.rightImage.hidden = NO;
        [self.rightImage yy_setImageWithURL:[NSURL URLWithString:model.newsImage] placeholder:nil];
        
    }else if (model.messageType == HomeMessageTypeHelper) {
        
        self.leftIcon.image = [UIImage imageNamed:@"messageHome_zhushou"];
        self.rightBtn.hidden = NO;
        
    }else if (model.messageType == HomeMessageTypeSystem) {
        
        self.leftIcon.image = [UIImage imageNamed:@"messageHome_system"];
        self.rightBtn.hidden = NO;
        
    }
}
#pragma mark - 参与
-(void)canyuItemClcik
{
    
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
