//
//  ChatModel.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/17.
//  Copyright © 2018 mh. All rights reserved.
//

#import "ChatModel.h"
#import "CommentHelper.h"
#import "MHChatTextParser.h"
#import "MHLinePositionModifier.h"

#define kMaxChatImageViewWidth 200.f
#define kMaxChatImageViewHeight 300.f

@implementation ChatModel

+(NSArray *)testChatModels
{
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    
    NSInteger imageIndex = 0;
    
    for (int i = 0; i < 30; i ++) {
        ChatModel * model = [[ChatModel alloc] init];
        model.fromType = i % 2 == 0 ? MHChatMsgFromTypeMeSend : MHChatMsgFromTypeSendToMe;
        model.msgType = i % 5 == 3 ? MHChatMsgTypeImage : MHChatMsgTypeText;
        if (model.fromType == MHChatMsgFromTypeMeSend) {
            model.userIcon = @"http://tx.haiqq.com/uploads/allimg/150323/15134Qb0-0.jpg";
            model.userName = @"二狗子他二舅爷";
        }else{
            model.userIcon = @"http://img1.touxiang.cn/uploads/20131119/19-082840_334.jpg";
            model.userName = @"二狗子";
        }
        
        if (model.msgType == MHChatMsgTypeText) {
            model.msgText = [self chatMsg:i];
        }else if (model.msgType == MHChatMsgTypeImage) {
            model.imageUrl = [MHVideoTool t_videoPreImage:imageIndex];
            model.imageWidth = [self t_preWidth];
            model.imageHeight = [self t_preHieght];
            imageIndex += 1;
        }
        
        [model chatModelLayout];
        
        [arr addObject:model];
    }
    
    return [NSArray arrayWithArray:arr];
}
+(void)test200Models:(void (^)(NSArray *))callBack
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
        
        NSInteger imageIndex = 0;
        
        for (int i = 0; i < 200; i ++) {
            ChatModel * model = [[ChatModel alloc] init];
            model.fromType = i % 2 == 0 ? MHChatMsgFromTypeMeSend : MHChatMsgFromTypeSendToMe;
            model.msgType = i % 5 == 3 ? MHChatMsgTypeImage : MHChatMsgTypeText;
            if (model.fromType == MHChatMsgFromTypeMeSend) {
                model.userIcon = @"http://tx.haiqq.com/uploads/allimg/150323/15134Qb0-0.jpg";
                model.userName = @"二狗子他二舅爷";
            }else{
                model.userIcon = @"http://img1.touxiang.cn/uploads/20131119/19-082840_334.jpg";
                model.userName = @"二狗子";
            }
            
            if (model.msgType == MHChatMsgTypeText) {
                model.msgText = [self chatMsg:i];
            }else if (model.msgType == MHChatMsgTypeImage) {
                model.imageUrl = [MHVideoTool t_videoPreImage:imageIndex];
                model.imageWidth = [self t_preWidth];
                model.imageHeight = [self t_preHieght];
                imageIndex += 1;
            }
            
            [model chatModelLayout];
            
            [arr addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            callBack([NSArray arrayWithArray:arr]);
        });
    });
}
-(void)chatModelLayout
{
    if (self.msgType == MHChatMsgTypeText) {
        //文字最大宽度
        CGFloat textWidth = Screen_WIDTH - Width(80) - (Width(10)*2 + Width(30)) - Width(30);
        NSMutableAttributedString * attributedMsg = [self msgToAttribute];
        
        MHLinePositionModifier *modifier = [MHLinePositionModifier new];
        modifier.font = [UIFont fontWithName:@"Heiti SC" size:16];
        modifier.paddingTop = 0;
        modifier.paddingBottom = 0;
        
        YYTextContainer *container = [YYTextContainer new];
        container.size = CGSizeMake(textWidth, MAXFLOAT);
        container.linePositionModifier = modifier;
        
        YYTextLayout * textLayout = [YYTextLayout layoutWithContainer:container text:attributedMsg];
        CGFloat textHeight = [modifier heightForLineCount:textLayout.rowCount];
        //只有一行内容
        if (textLayout.rowCount == 1) {
            //计算一行文字 宽度
            YYTextLine * line = textLayout.lines[0];
            CGFloat textWidth = line.width;
            YYTextContainer *container = [YYTextContainer new];
            container.size = CGSizeMake(textWidth, MAXFLOAT);
            container.linePositionModifier = modifier;
            YYTextLayout * textLayout = [YYTextLayout layoutWithContainer:container text:attributedMsg];
            CGFloat textHeight = [modifier heightForLineCount:textLayout.rowCount];

            self.msgTextLayout = textLayout;
            self.containerWidth = textWidth + Width(30);
            self.containerHeight = textHeight + Width(30);
            self.cellHeight = Width(15) + self.containerHeight + Width(15);
        }else {
            self.msgTextLayout = textLayout;
            self.containerWidth = textWidth + Width(30);
            self.containerHeight = textHeight + Width(30);
            self.cellHeight = Width(15) + self.containerHeight + Width(15);
        }

        
    }else if (self.msgType == MHChatMsgTypeImage) {
        
        // 根据图片的宽高尺寸设置图片约束
        CGFloat standardWidthHeightRatio = kMaxChatImageViewWidth / kMaxChatImageViewHeight;
        CGFloat widthHeightRatio = 0;
        
        self.imageCellHeight = self.imageHeight;
        self.imageCellWidth = self.imageWidth;
        
        if (self.imageCellWidth > kMaxChatImageViewWidth || self.imageCellWidth > kMaxChatImageViewHeight) {
            
            widthHeightRatio = self.imageCellWidth / self.imageCellHeight;
            
            if (widthHeightRatio > standardWidthHeightRatio) {
                self.imageCellWidth = kMaxChatImageViewWidth;
                self.imageCellHeight = self.imageCellWidth * (self.imageHeight / self.imageWidth);
            } else {
                self.imageCellHeight = kMaxChatImageViewHeight;
                self.imageCellWidth = self.imageCellHeight * widthHeightRatio;
            }
        }
        self.containerWidth = self.imageCellWidth;
        self.containerHeight = self.imageCellHeight + Width(30);
        self.cellHeight = Width(15) + self.containerHeight + Width(15);
        
    }
}
-(NSMutableAttributedString *)msgToAttribute
{
    // 字体
    UIFont *font = [UIFont systemFontOfSize:16];
    //UIColor * hightLightColor = [UIColor base_yellow_color];
    // 高亮状态的背景
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = [UIColor grayColor];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:self.msgText];
    text.yy_font = font;
    text.yy_color = [UIColor blackColor];
    {
        NSString * urlRegex = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
        NSRegularExpression * reges = [NSRegularExpression regularExpressionWithPattern:urlRegex options:kNilOptions error:NULL];
        NSArray<NSTextCheckingResult *> *urlResults = [reges matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
        for (NSTextCheckingResult * url in urlResults) {
            if (url.range.location == NSNotFound && url.range.length <= 1) continue;
            if ([text yy_attribute:YYTextHighlightAttributeName atIndex:url.range.location] == nil) {
                [text yy_setColor:[UIColor blueColor] range:url.range];
                
                // 高亮状态
                YYTextHighlight *highlight = [YYTextHighlight new];
                [highlight setBackgroundBorder:highlightBorder];
                // 数据信息，用于稍后用户点击
                highlight.userInfo = @{@"url" : [text.string substringWithRange:NSMakeRange(url.range.location, url.range.length)]};
                [text yy_setTextHighlight:highlight range:url.range];
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
+(CGFloat)t_preWidth
{
    NSArray * arr = @[@(380.f),@(200.f),@(240.f),@(280.f),@(420.f),@(460.f),@(550.f),@(340.f),@(300.f),@(120.f)];
    int a = arc4random() % arr.count;
    return [arr[a] floatValue];
}
+(CGFloat)t_preHieght
{
    NSArray * arr = @[@(480.f),@(400.f),@(240.f),@(450.f),@(520.f),@(260.f),@(350.f),@(540.f),@(500.f),@(420.f)];
    int a = arc4random() % arr.count;
    return [arr[a] floatValue];
}
+(NSString *)chatMsg:(NSInteger)index
{
    NSArray * messagesArray = @[
                                @"[囧][囧][囧]你说啥，我咋一句都听不懂名啊[囧][囧][囧]",
                                @"[微风][太阳][下雨]老师讲上学不能带手机，违者重处[喜][弱][握手]",
                                @"[微风][微风][微风]老师讲上学不能带手机，违者重处",
                                @"我偏不信这个邪[太阳]https://www.jianshu.com/p/5c1a473f91ba",
                                @"把手机上缴后，[握手]我百思不得其解，藏得那么隐秘，[握手]也能轻易暴露？",
                                @"[下雨]下决心开始写读书笔记的原因有很多，[下雨]首先，去年看的十几本书虽然不多，但居然这么快就不记得内容了，更别谈什么收获",
                                @"其次，[喜]深入思考需要有素材，如果没有记录便https://www.jianshu.com/p/46e0a0979933无从深入。于是，我开始怀疑这种读书方式，没有记录的读书方式是低效率的。",
                                @"先思考清楚为什么要做读书笔记",
                                @"好记性不如烂[喜]笔头，不要对自己的记忆力和脑容量太过自信。我就是一个记忆不好的人，没办法啊！",
                                @"思考的过程需要呈现出来",
                                @"原文是最好的营养来源。做笔记时记得把你觉得好到爆的原文摘录下来，等你回顾的时候多看几遍，这些智慧就成你自己的啦。",
                                @"我开始去B站搜索那[喜]些笔记大神，得[微风]到的笔记方式千奇百怪。[微风]有的人读书笔记写的工工整整，还把书的封面打印出来贴在笔记上，仪式感爆棚。好看是好看，https://www.jianshu.com/p/46e0a0979933但我马上清醒过来了，这种事就像我高中时做课堂笔记，以美观为目的，可能中看不中用。我怕写[下雨]错一个字就影响美观了，怎么还敢放手[下雨][下雨][下雨][下雨]随性发挥呢？写读书笔记的目的就[微风]是要及时把脑海中的想法快速记录下来。不能有太多的局限，这是我个人的体会。",
                                @"后面还观看了各种大神的[喜]笔记本分享，在此不做[下雨]过多描述了。终于，最后看[微风]到一个小姐姐的霸气分享，让我决定了，这种方式适合我。结合我自己的笔记本格式，出炉了自己的一套笔记术",
                                @"定期回顾笔记，催[喜]生[微风]新的思考",
                                @"参考",
                                @"读书笔记",
                                @"摆脱了文盲状态",
                                @"弗兰西斯*培根曾[喜]经说过：“有些书可以浅尝辄止，有些书是要生吞活剥[微风]，只有少数的书是要咀嚼消化的。”分析阅读就是要咀嚼消化一本书。https://www.jianshu.com/p/46e0a0979933",
                                @"为什么我读了很多[喜]书，却仍然[微风]过不好这一生？"
                                ];
    
    return messagesArray[index%messagesArray.count];
}

@end
