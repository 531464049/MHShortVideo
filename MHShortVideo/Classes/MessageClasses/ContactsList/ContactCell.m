//
//  ContactCell.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/17.
//  Copyright © 2018 mh. All rights reserved.
//

#import "ContactCell.h"

@interface ContactCell ()

@property(nonatomic,strong)UIImageView * headerImage;
@property(nonatomic,strong)UILabel * nameLab;

@end

@implementation ContactCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.headerImage = [[UIImageView alloc] init];
        self.headerImage.contentMode = UIViewContentModeScaleAspectFill;
        self.headerImage.clipsToBounds = YES;
        self.headerImage.layer.cornerRadius = Width(40)/2;
        self.headerImage.layer.masksToBounds = YES;
        [self.contentView addSubview:self.headerImage];
        self.headerImage.sd_layout.leftSpaceToView(self.contentView, Width(15)).centerYEqualToView(self.contentView).widthIs(Width(40)).heightEqualToWidth();
        
        UIButton * contactBtn = [UIButton buttonWithType:0];
        [contactBtn setImage:[UIImage imageNamed:@"home_comment"] forState:0];
        [contactBtn addTarget:self action:@selector(contactItemClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:contactBtn];
        contactBtn.sd_layout.rightSpaceToView(self.contentView, Width(30)).centerYEqualToView(self.contentView).widthIs(Width(40)).heightEqualToWidth();
        
        self.nameLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(15) aligent:NSTextAlignmentLeft];
        self.nameLab.numberOfLines = 1;
        [self.contentView addSubview:self.nameLab];
        self.nameLab.sd_layout.leftSpaceToView(self.headerImage, 10).centerYEqualToView(self.contentView).rightSpaceToView(contactBtn, Width(15)).heightIs(20);
    }
    return self;
}
-(void)setModel:(ContactModel *)model
{
    _model = model;
    
    [self.headerImage yy_setImageWithURL:[NSURL URLWithString:model.userImage] placeholder:nil];
    self.nameLab.text = model.userName;
}
-(void)contactItemClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(contactCellHandleChat:)]) {
        [self.delegate contactCellHandleChat:self.model];
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
