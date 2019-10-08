//
//  MHComposeTextParser.m
//  YYTestDemo
//
//  Created by 马浩 on 2018/11/28.
//  Copyright © 2018 mh. All rights reserved.
//

#import "MHComposeTextParser.h"

@interface MHComposeTextParser ()

@property (nonatomic, strong) NSRegularExpression * topicRegex;
@property (nonatomic, strong) NSRegularExpression * atRegex;

@end

@implementation MHComposeTextParser

- (instancetype)init {
    self = [super init];
    self.topicRegex = [NSRegularExpression regularExpressionWithPattern:@"#[^@#]+?\\s+" options:kNilOptions error:NULL];
    self.atRegex = [NSRegularExpression regularExpressionWithPattern:@"@[-_a-zA-Z0-9\u4E00-\u9FA5]+\\s+" options:kNilOptions error:NULL];
    return self;
}
- (BOOL)parseText:(NSMutableAttributedString *)text selectedRange:(NSRangePointer)range {
    
    text.yy_color = [UIColor whiteColor];
    {
        NSArray<NSTextCheckingResult *> *topicResults = [self.topicRegex matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
        for (NSTextCheckingResult *topic in topicResults) {
            if (topic.range.location == NSNotFound && topic.range.length <= 1) continue;
            NSRange range = topic.range;
            
            __block BOOL containsBindingRange = NO;
            [text enumerateAttribute:YYTextBindingAttributeName inRange:range options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id value, NSRange range, BOOL *stop) {
                if (value) {
                    containsBindingRange = YES;
                    *stop = YES;
                }
            }];
            if (containsBindingRange) continue;
            
            NSString *subText = [text.string substringWithRange:range];
            NSLog(@"匹配到#话题  %@",subText);
            [text yy_setTextBinding:[YYTextBinding bindingWithDeleteConfirm:YES] range:range]; /// Text binding
        }
    }
    {
        NSArray<NSTextCheckingResult *> *topicResults = [self.atRegex matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
        for (NSTextCheckingResult * at in topicResults) {
            if (at.range.location == NSNotFound && at.range.length <= 1) continue;
            NSRange range = at.range;
            
            __block BOOL containsBindingRange = NO;
            [text enumerateAttribute:YYTextBindingAttributeName inRange:range options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id value, NSRange range, BOOL *stop) {
                if (value) {
                    containsBindingRange = YES;
                    *stop = YES;
                }
            }];
            if (containsBindingRange) continue;
            
            NSString *subText = [text.string substringWithRange:range];
            NSLog(@"匹配到@好友  %@",subText);
            [text yy_setTextBinding:[YYTextBinding bindingWithDeleteConfirm:YES] range:range]; /// Text binding
        }
    }

    [text enumerateAttribute:YYTextBindingAttributeName inRange:text.yy_rangeOfAll options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id value, NSRange range, BOOL *stop) {
        if (value && range.length > 1) {
            [text yy_setColor:HexRGBAlpha(0xE47C48, 1) range:range];
        }
    }];
    return YES;
}
@end
