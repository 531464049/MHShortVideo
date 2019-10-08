//
//  SearchSameCell.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/13.
//  Copyright © 2018 mh. All rights reserved.
//

#import "SearchSameCell.h"

@interface SearchSameCell ()

@property(nonatomic,strong)UIImageView * icon;
@property(nonatomic,strong)YYLabel * searchStr;

@end

@implementation SearchSameCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.icon = [[UIImageView alloc] init];
        self.icon.image = [UIImage imageNamed:@"search_gray"];
        self.icon.contentMode = UIViewContentModeScaleAspectFit;
        self.icon.clipsToBounds = YES;
        [self.contentView addSubview:self.icon];
        self.icon.sd_layout.leftSpaceToView(self.contentView, Width(15)).centerYEqualToView(self.contentView).widthIs(18).heightEqualToWidth();
        
        self.searchStr = [[YYLabel alloc] init];
        self.searchStr.textAlignment = NSTextAlignmentLeft;
        self.searchStr.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        self.searchStr.numberOfLines = 1;
        [self.contentView addSubview:self.searchStr];
        self.searchStr.sd_layout.leftSpaceToView(self.icon, 10).rightSpaceToView(self.contentView, Width(30)).centerYEqualToView(self.contentView).heightIs(Width(20));
        
    }
    return self;
}
- (void)setSearchKey:(NSString *)key sameStr:(NSString *)sameStr
{
    if (key.length == 0) {
        key = @"";
    }
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc] initWithString:sameStr];
    attribute.yy_font = [UIFont systemFontOfSize:16];
    attribute.yy_color = [UIColor whiteColor];
    
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:key options:kNilOptions error:NULL];
    NSArray *atResults = [regex matchesInString:attribute.string options:kNilOptions range:attribute.yy_rangeOfAll];
    for (NSTextCheckingResult *at in atResults) {
        if (at.range.location == NSNotFound && at.range.length <= 1) continue;
        if ([attribute yy_attribute:YYTextHighlightAttributeName atIndex:at.range.location] == nil) {
            [attribute yy_setColor:[UIColor base_yellow_color] range:at.range];
        }
    }
    self.searchStr.attributedText = attribute;
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
