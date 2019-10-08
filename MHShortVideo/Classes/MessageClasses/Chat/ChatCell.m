//
//  ChatCell.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/17.
//  Copyright © 2018 mh. All rights reserved.
//

#import "ChatCell.h"

@interface ChatCell ()

@property(nonatomic,strong)UIImageView * headerImage;//头像
@property(nonatomic,strong)UIView * container;//内容总容器
@property(nonatomic,strong)UIImageView * containerBGImageView;//容器背景图-聊天气泡
@property(nonatomic,strong)YYLabel * msgLab;//文本消息 lab
@property(nonatomic,strong)UIImageView * msgImageView;//图片消息 图片

@end

@implementation ChatCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.headerImage = [[UIImageView alloc] init];
        self.headerImage.contentMode = UIViewContentModeScaleAspectFill;
        self.headerImage.clipsToBounds = YES;
        self.headerImage.layer.cornerRadius = Width(30)/2;
        self.headerImage.layer.masksToBounds = YES;
        [self.contentView addSubview:self.headerImage];
        
        self.container = [[UIView alloc] init];
        [self.contentView addSubview:self.container];
        
        self.containerBGImageView = [[UIImageView alloc] init];
        self.containerBGImageView.userInteractionEnabled = YES;
        [self.container addSubview:self.containerBGImageView];
        self.containerBGImageView.sd_layout.leftEqualToView(self.container).topEqualToView(self.container).rightEqualToView(self.container).bottomEqualToView(self.container);

        
        self.msgLab = [YYLabel new];
        self.msgLab.textVerticalAlignment = YYTextVerticalAlignmentTop;
        self.msgLab.displaysAsynchronously = YES;
        self.msgLab.ignoreCommonProperties = YES;
        self.msgLab.fadeOnAsynchronouslyDisplay = NO;
        self.msgLab.fadeOnHighlight = NO;
        [self.container addSubview:self.msgLab];
        self.msgLab.sd_layout.leftSpaceToView(self.container, Width(15)).topSpaceToView(self.container, Width(15)).rightSpaceToView(self.container, Width(15)).bottomSpaceToView(self.container, Width(15));

        
        self.msgImageView = [[UIImageView alloc] init];
        self.msgImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.msgImageView.clipsToBounds = YES;
        self.msgImageView.layer.cornerRadius = 10;
        self.msgImageView.layer.masksToBounds = YES;
        [self.container addSubview:self.msgImageView];
    }
    return self;
}
-(void)setModel:(ChatModel *)model
{
    _model = model;
    
    [self.headerImage yy_setImageWithURL:[NSURL URLWithString:_model.userIcon] placeholder:nil];

    //根据model消息来源类型 设置cell左右浮动样式
    [self setMessageOrigin];
    //根据消息类型赋值
    if (model.msgType == MHChatMsgTypeText) {
        
        self.msgImageView.hidden = YES;
        self.msgLab.hidden = NO;
        self.containerBGImageView.hidden = NO;
        
        self.msgLab.textLayout = model.msgTextLayout;
        
        typeof(self) weekself = self;
        self.msgLab.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
            [weekself handleLabTap:(YYLabel *)containerView textRange:range];
        };
        
    }else if (model.msgType == MHChatMsgTypeImage) {
        
        self.msgImageView.hidden = NO;
        self.msgLab.hidden = YES;
        self.containerBGImageView.hidden = YES;
        
        self.msgImageView.frame = self.container.bounds;
        [self.msgImageView yy_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholder:nil];
    }
}
#pragma mark - 设置cell左/右浮动样式
- (void)setMessageOrigin
{
    if (_model.fromType == MHChatMsgFromTypeSendToMe) {
        //收到的消息 左浮动
        self.headerImage.frame = CGRectMake(Width(10), Width(15), Width(30), Width(30));
        self.container.frame = CGRectMake(Width(50), Width(15), _model.containerWidth, _model.containerHeight);
        UIImage *image = [UIImage imageNamed:@"ReceiverTextNodeBkg"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 30, 30) resizingMode:UIImageResizingModeStretch];
        self.containerBGImageView.image = image;
        
        
    }else{
        //发出的消息 右浮动
        self.headerImage.frame = CGRectMake(Screen_WIDTH - Width(10) - Width(30), Width(15), Width(30), Width(30));
        self.container.frame = CGRectMake(Screen_WIDTH - Width(50) - _model.containerWidth, Width(15), _model.containerWidth, _model.containerHeight);

        UIImage *image = [UIImage imageNamed:@"SenderTextNodeBkg"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 30, 30) resizingMode:UIImageResizingModeStretch];
        self.containerBGImageView.image = image;
        
    }
}
#pragma mark - lab内容点击
-(void)handleLabTap:(YYLabel *)label textRange:(NSRange)textRange
{
    NSAttributedString *text = label.textLayout.text;
    if (textRange.location >= text.length) return;
    YYTextHighlight *highlight = [text yy_attribute:YYTextHighlightAttributeName atIndex:textRange.location];
    NSDictionary *info = highlight.userInfo;
    if (info.count == 0) return;
    
    if (info[@"url"]) {
        NSString * url = info[@"url"];
        NSLog(@"点击链接 %@",url);
        [MHHUD showTips:url];
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
