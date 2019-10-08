//
//  SearchCell.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/10.
//  Copyright © 2018 mh. All rights reserved.
//

#import "SearchCell.h"

@interface SearchCell ()

@property(nonatomic,strong)UIImageView * topicIcon;//话题图标
@property(nonatomic,strong)UILabel * topicNameLab;//话题名字
@property(nonatomic,strong)UILabel * topicTypeLab;//话题类型-热门话题

@property(nonatomic,strong)UIView * numView;
@property(nonatomic,strong)UIImageView * numIcon;
@property(nonatomic,strong)UILabel * topicNumLab;//话题重复数量

@property(nonatomic,strong)UIScrollView * contentScroll;//容器

@end

@implementation SearchCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.topicIcon = [[UIImageView alloc] initWithFrame:CGRectMake(Width(15), Width(17.5), Width(35), Width(35))];
        self.topicIcon.image = [UIImage imageNamed:@"search_topicIcon"];
        self.topicIcon.contentMode = UIViewContentModeScaleAspectFill;
        self.topicIcon.clipsToBounds = YES;
        [self.contentView addSubview:self.topicIcon];
        
        self.topicNameLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(15) aligent:NSTextAlignmentLeft];
        self.topicNameLab.numberOfLines = 1;
        [self.contentView addSubview:self.topicNameLab];
        self.topicNameLab.sd_layout.leftSpaceToView(self.topicIcon, 5).topSpaceToView(self.contentView, Width(17.5)).rightSpaceToView(self.contentView, Width(80)).heightIs(Width(17.5));
        
        self.topicTypeLab = [UILabel labTextColor:[UIColor grayColor] font:FONT(14) aligent:NSTextAlignmentLeft];
        self.topicTypeLab.numberOfLines = 1;
        [self.contentView addSubview:self.topicTypeLab];
        self.topicTypeLab.sd_layout.leftSpaceToView(self.topicIcon, 5).topSpaceToView(self.topicNameLab, 0).rightSpaceToView(self.contentView, Width(80)).heightIs(Width(17.5));
        
        self.numView = [[UIView alloc] init];
        self.numView.backgroundColor = [UIColor grayColor];
        self.numView.layer.cornerRadius = 2;
        self.numView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.numView];
        self.numView.sd_layout.rightSpaceToView(self.contentView, Width(15)).centerYEqualToView(self.topicNameLab).heightIs(Width(20));
        
        self.topicNumLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(14) aligent:NSTextAlignmentCenter];
        self.topicNumLab.numberOfLines = 1;
        [self.numView addSubview:self.topicNumLab];
        self.topicNumLab.sd_layout.leftSpaceToView(self.numView, 5).topEqualToView(self.numView).bottomEqualToView(self.numView);
        [self.topicNumLab setSingleLineAutoResizeWithMaxWidth:200];
        
        self.numIcon = [[UIImageView alloc] init];
        self.numIcon.image = [UIImage imageNamed:@"common_next"];
        self.numIcon.contentMode = UIViewContentModeScaleAspectFit;
        self.numIcon.clipsToBounds = YES;
        [self.numView addSubview:self.numIcon];
        self.numIcon.sd_layout.leftSpaceToView(self.topicNumLab, 5).topEqualToView(self.numView).bottomEqualToView(self.numView).widthIs(10);

        [self.numView setupAutoWidthWithRightView:self.numIcon rightMargin:5];
        
        self.contentScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, Width(70), Screen_WIDTH, Width(140))];
        self.contentScroll.showsVerticalScrollIndicator = NO;
        self.contentScroll.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:self.contentScroll];
    }
    return self;
}
-(void)setModel:(SearchModel *)model
{
    _model = model;
    
    self.topicNameLab.text = model.topicName;
    self.topicTypeLab.text = @"热门话题";
    self.topicNumLab.text = model.dataNumStr;
    
    for (UIView * subView in self.contentScroll.subviews) {
        [subView removeFromSuperview];
    }
    CGFloat itemWidth = Width(105);
    CGFloat itemHeight = self.contentScroll.frame.size.height;
    CGFloat itemMargin = 2;
    CGFloat leftMargin = Width(15);
    for (int i = 0; i < model.topicImagesArr.count; i ++) {
        UIImageView * img = [[UIImageView alloc] init];
        img.frame = CGRectMake(leftMargin + (itemWidth + itemMargin)*i, 0, itemWidth, itemHeight);
        [img yy_setImageWithURL:[NSURL URLWithString:model.topicImagesArr[i]] placeholder:nil];
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.clipsToBounds = YES;
        [self.contentScroll addSubview:img];
    }
    [self.contentScroll setContentSize:CGSizeMake(leftMargin*2 + itemWidth * model.topicImagesArr.count + itemMargin * (model.topicImagesArr.count - 1), itemHeight)];
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
