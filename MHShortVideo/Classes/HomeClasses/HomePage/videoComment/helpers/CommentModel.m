//
//  CommentModel.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/5.
//  Copyright © 2018 mh. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

+(CommentModel *)test_getAModel
{
    CommentModel * model = [CommentModel new];
    model.username = [self t_username:0];
    model.userimage = @"http://pic32.photophoto.cn/20140819/0008020285038599_b.jpg";
    model.content = [self t_content:0];
    model.time = @"10分钟前";
    
    NSInteger zannum = arc4random() % 5000;
    model.zanNum = zannum;
    model.beZan = NO;
    
    [CommentModel layoutCommnet:model];
    
    return model;
}
+(NSArray *)test_getModels
{
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 10; i ++) {
        CommentModel * model = [CommentModel new];
        model.username = [self t_username:i % 10];
        model.userimage = @"http://pic32.photophoto.cn/20140819/0008020285038599_b.jpg";
        model.content = [self t_content:i % 10];
        model.time = @"10分钟前";
        
        NSInteger zannum = arc4random() % 5000;
        model.zanNum = zannum;
        model.beZan = i % 2 == 1;
        
        [CommentModel layoutCommnet:model];
        
        [arr addObject:model];
    }
    return arr;
}
+(void)layoutCommnet:(CommentModel *)model
{
    CommentLayout * layout = [[CommentLayout alloc] init];
    
    NSMutableAttributedString * attributedContent = [model contentToAttribute:model.content postTime:model.time];
    
    MHLinePositionModifier *modifier = [MHLinePositionModifier new];
    modifier.font = [UIFont fontWithName:@"Heiti SC" size:17];
    modifier.paddingTop = 0;
    modifier.paddingBottom = 10;
    
    //内容宽度
    CGFloat containerWidth = Screen_WIDTH - layout.userHeader_left - layout.userHeader_width - layout.content_header - layout.content_right;
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(containerWidth, MAXFLOAT);
    container.linePositionModifier = modifier;
    
    YYTextLayout * textLayout = [YYTextLayout layoutWithContainer:container text:attributedContent];
    CGFloat textHeight = [modifier heightForLineCount:textLayout.rowCount];
    
    model.contentHeight = textHeight;
    model.contentTextLayout = textLayout;
    
    CGFloat cellHeight = layout.userName_top + layout.userName_height + layout.content_name + model.contentHeight;
    model.cellHeight = cellHeight;
}
-(NSMutableAttributedString *)contentToAttribute:(NSString *)content postTime:(NSString *)postTime
{
    CommentLayout * layout = [[CommentLayout alloc] init];
    // 字体
    UIFont *font = [UIFont systemFontOfSize:layout.content_nomalFontSize];
    UIColor * hightLightColor = layout.content_hightLightColor;
    // 高亮状态的背景
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = hightLightColor;
    
    NSString * realContent = [NSString stringWithFormat:@"%@ %@",content,postTime];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:realContent];
    text.yy_font = font;
    text.yy_color = layout.content_nomalColor;
    
    {
        //内容尾部 时间
        NSRange timeRange = NSMakeRange(content.length + 1, postTime.length);
        [text yy_setFont:[UIFont systemFontOfSize:layout.content_smallFontSize] range:timeRange];
        [text yy_setColor:layout.content_smallColor range:timeRange];
    }
    
    {
        // 匹配 @用户名
        NSArray *atResults = [[CommentHelper atRegex] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
        for (NSTextCheckingResult *at in atResults) {
            if (at.range.location == NSNotFound && at.range.length <= 1) continue;
            if ([text yy_attribute:YYTextHighlightAttributeName atIndex:at.range.location] == nil) {
                [text yy_setColor:hightLightColor range:at.range];
                
                // 高亮状态
                YYTextHighlight *highlight = [YYTextHighlight new];
                [highlight setBackgroundBorder:highlightBorder];
                // 数据信息，用于稍后用户点击
                highlight.userInfo = @{@"at" : [text.string substringWithRange:NSMakeRange(at.range.location + 1, at.range.length - 1)]};
                [text yy_setTextHighlight:highlight range:at.range];
            }
        }
    }
    
    {
        // 匹配 [表情]
        NSArray<NSTextCheckingResult *> *emoticonResults = [[CommentHelper regexEmoticon] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
        NSUInteger emoClipLength = 0;
        for (NSTextCheckingResult *emo in emoticonResults) {
            if (emo.range.location == NSNotFound && emo.range.length <= 1) continue;
            NSRange range = emo.range;
            range.location -= emoClipLength;
            if ([text yy_attribute:YYTextHighlightAttributeName atIndex:range.location]) continue;
            if ([text yy_attribute:YYTextAttachmentAttributeName atIndex:range.location]) continue;
            NSString *emoString = [text.string substringWithRange:range];
            NSString *imagePath = [CommentHelper emoticonDic][emoString];
            UIImage *image = [CommentHelper emotionWithName:imagePath];
            if (!image) continue;
            
            NSAttributedString *emoText = [NSAttributedString yy_attachmentStringWithEmojiImage:image fontSize:17];
            [text replaceCharactersInRange:range withAttributedString:emoText];
            emoClipLength += range.length - 1;
        }
    }
    
    return text;
}
+(NSString *)t_username:(NSInteger)index
{
    NSArray * arr = @[
                      @"xiaoming",
                      @"用户8989",
                      @"你好啊",
                      @"89898989",
                      @"风险管理工具",
                      @"洪磊",
                      @"问题仍然比较突出",
                      @"日益增长的多元化",
                      @"两只国债期货",
                      @"三只股指期货"];
    return arr[index];
}
+(NSString *)t_content:(NSInteger)index
{
    NSArray * arr = @[
                      @"阿拉伯国有@电视台 等媒体[微笑]报道，卡塔尔能源部长[哼][哼][哼]表示，该国将在@2019年 [抓狂]初退出石油输出国组织@欧佩克 [怒]",
                      @"卡塔尔方面表示@shikelang ，退出的时间确定为[绿丝带]2019年1月，当日早间已将此决定告[爱你]知这一组织。[阴险][阴险][阴险]",
                      @"海外网12月3日电",
                      @"《报告》作者不少来[笑cry][笑cry][笑cry]自金融监管部门，其中一篇题为“现代金融体系中的金融市场改革”分报告就由现任中国基金业协会会长洪磊撰写，@发展金融衍生品 的重要性被多次提及，格外引人[疑问]关注。",
                      @"[草泥马]资产管理机构缺少有效风险管理工具",
                      @"洪磊[good][good]上述分报告中提到了@你们健康吗 国内资本市场现状[闭嘴]与问题[闭嘴]",
                      @"@你好啊 避免面对同一冲击产[嘻嘻][嘻嘻][嘻嘻]生强烈的市场共振[右哼哼]。与境外成熟市场相比，我国金融衍生品市场起步晚、发展慢、产品少、发挥不充分等[太阳]问题仍然比较突出，还[下雨]不能",
                      @"还不能完全满足各类机[白眼]构日益增长的多元化风险管理需求。",
                      @"[困]具体来说，产品层面",
                      @"[囧]我国仅有三只股指期货、两只国债期货、一只股票期权，股指期权、外汇期权尚未空白"];
    return arr[index];
}
@end



