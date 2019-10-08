//
//  FocusDynamicModel.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/13.
//  Copyright © 2018 mh. All rights reserved.
//

#import "FocusDynamicModel.h"

@implementation FocusDynamicModel

+ (NSArray *)randomModels
{
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < 10; i ++) {
        FocusDynamicModel * model = [[FocusDynamicModel alloc] init];
        
        HomeVideoModel * videoModel = [[HomeVideoModel alloc] init];
        videoModel.videoUrl = [MHVideoTool test_getAVideoUrl:i % 10];
        videoModel.videoTitle = [self t_videotitle:i%10];
        videoModel.videoPreImage = [self test_getImages:i%10];
        videoModel.userName = @"二狗";
        videoModel.userImage = @"http://pic32.photophoto.cn/20140819/0008020285038599_b.jpg";
        int x = arc4random() % 2000000;
        videoModel.zanNum = x;
        int y = arc4random() % 2000000;
        videoModel.commentNum = y;
        int z = arc4random() % 2000000;
        videoModel.shareNum = z;
        videoModel.isLiked = NO;
        
        model.videoModel = videoModel;
        
        CommentModel * commentModel = [CommentModel test_getAModel];
        model.commentModel = commentModel;
        
        
        
        FocusDynamicLayout * layout = [[FocusDynamicLayout alloc] init];
        
        NSMutableAttributedString * videoTitlebutedContent  =[model videoContentTextAttribute];
        
        MHLinePositionModifier *modifier = [MHLinePositionModifier new];
        modifier.font = [UIFont fontWithName:@"Heiti SC" size:17];
        modifier.paddingTop = 0;
        modifier.paddingBottom = 10;
        
        //视频标题宽度
        CGFloat containerWidth = Screen_WIDTH - layout.leftRightMaring * 2;
        YYTextContainer *container = [YYTextContainer new];
        container.size = CGSizeMake(containerWidth, MAXFLOAT);
        container.linePositionModifier = modifier;
        container.maximumNumberOfRows = 2;
        
        YYTextLayout * textLayout = [YYTextLayout layoutWithContainer:container text:videoTitlebutedContent];
        CGFloat textHeight = [modifier heightForLineCount:textLayout.rowCount];

        model.videoTitleHeight = textHeight;
        model.videoTitleTextLayout = textLayout;
        
        //计算整体高度
        CGFloat totleHeight = layout.headerTop + layout.headerImageWidth + layout.header_title_margin + textHeight + layout.title_preImage_margin + layout.preImageHeight + layout.videoBarHeight + commentModel.cellHeight;
        model.totleHeight = totleHeight;
        
        [arr addObject:model];
        
    }
    
    return [NSArray arrayWithArray:arr];
}
-(NSMutableAttributedString *)videoContentTextAttribute
{
    FocusDynamicLayout * layout = [[FocusDynamicLayout alloc] init];
    // 字体
    UIFont *font = [UIFont systemFontOfSize:layout.titleFont.pointSize];
    UIColor * hightLightColor = [UIColor base_yellow_color];
    // 高亮状态的背景
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = hightLightColor;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:self.videoModel.videoTitle];
    text.yy_font = font;
    text.yy_color = [UIColor whiteColor];
    
    {
        // 匹配 话题
        NSArray *topicResults = [[CommentHelper topicRegex] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
        for (NSTextCheckingResult *topic in topicResults) {
            if (topic.range.location == NSNotFound && topic.range.length <= 1) continue;
            if ([text yy_attribute:YYTextHighlightAttributeName atIndex:topic.range.location] == nil) {
                [text yy_setColor:hightLightColor range:topic.range];
                
                // 高亮状态
                YYTextHighlight *highlight = [YYTextHighlight new];
                [highlight setBackgroundBorder:highlightBorder];
                // 数据信息，用于稍后用户点击
                highlight.userInfo = @{@"###" : [text.string substringWithRange:NSMakeRange(topic.range.location + 1, topic.range.length - 1)]};
                [text yy_setTextHighlight:highlight range:topic.range];
            }
        }
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
+(NSString *)t_videotitle:(NSInteger)index
{
    NSArray * arr = @[
                      @"@阿拉伯 国有电视台等#媒体报道 ，[哼][哼][哼]卡塔尔@能源部长 表示，该国将在2019年初退出石油输出国组织欧佩克",
                      @"[笑cry]卡塔尔方面表示，退出的时间确定为#2019年1月 ，当日早间已将此决定告知这一组织。",
                      @"@海外网 12月3日电",
                      @"《报告》作者[嘻嘻]不少来自金融监管部[困][困]门，其中一篇题为“现代金融体系中的金融市场改革”分报告就由现任中国基金业协会会长洪磊撰写，发展金融衍生品的重要性被多次提及，格外引人关注。",
                      @"[困]@资产管理机构 缺少有效风险管理工具",
                      @"[囧]洪磊上述#分报告 中提到了国内资本市场现状与问题",
                      @"避免面对@同一冲击 产生强烈的[囧][囧]市场共振。与境外成熟市场相比，我国金融衍生品市场起步晚、发展慢、产品少、发挥不充分等问题仍然比较突出，还不能",
                      @"还不能完全满足各类机构日益增长的多元化风险管理需求。",
                      @"[闭嘴]具体@来说 ，产品层面",
                      @"我国仅有#三只股指 [闭嘴][闭嘴]期货、两只国债期货、一只股票期权，股指期权、外汇期权尚未空白"];
    return arr[index];
}
+(NSString *)test_getImages:(NSInteger)index
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
@end


@implementation FocusDynamicLayout

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.leftRightMaring = Width(15);
        self.headerTop = Width(20);
        self.headerImageWidth = Width(35);
        self.header_title_margin = Width(10);
        self.titleFont = FONT(16);
        self.title_preImage_margin = Width(10);
        self.preImageWidth = Width(250);
        self.preImageHeight = Width(250) * Screen_HEIGTH / Screen_WIDTH;
        self.videoBarHeight = Width(40);
    }
    return self;
}

@end
