//
//  MHCommentTextParser.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/5.
//  Copyright © 2018 mh. All rights reserved.
//

#import "MHCommentTextParser.h"

@interface MHCommentTextParser ()



@end

@implementation MHCommentTextParser

- (instancetype)init {
    self = [super init];
    
    _font = [UIFont systemFontOfSize:15];
    _textColor = [UIColor whiteColor];
    _highlightTextColor = [UIColor base_yellow_color];
    
    return self;
}
- (BOOL)parseText:(NSMutableAttributedString *)text selectedRange:(NSRangePointer)selectedRange {
    
    text.yy_color = _textColor;
    {
        //匹配@好友
        NSArray<NSTextCheckingResult *> *atResults = [[CommentHelper atRegex] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
        for (NSTextCheckingResult * at in atResults) {
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
            [text yy_setTextBinding:[YYTextBinding bindingWithDeleteConfirm:YES] range:range]; /// Text binding
        }
    }
    
    {
        //匹配表情
        NSArray<NSTextCheckingResult *> *emoticonResults = [[CommentHelper regexEmoticon] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
        NSUInteger clipLength = 0;
        for (NSTextCheckingResult *emo in emoticonResults) {
            if (emo.range.location == NSNotFound && emo.range.length <= 1) continue;
            NSRange range = emo.range;
            range.location -= clipLength;
            if ([text yy_attribute:YYTextAttachmentAttributeName atIndex:range.location]) continue;
            NSString *emoString = [text.string substringWithRange:range];
            NSString *imagePath = [CommentHelper emoticonDic][emoString];
            UIImage *image = [CommentHelper emotionWithName:imagePath];
            if (!image) continue;
            
            __block BOOL containsBindingRange = NO;
            [text enumerateAttribute:YYTextBindingAttributeName inRange:range options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id value, NSRange range, BOOL *stop) {
                if (value) {
                    containsBindingRange = YES;
                    *stop = YES;
                }
            }];
            if (containsBindingRange) continue;
            
            
            YYTextBackedString *backed = [YYTextBackedString stringWithString:emoString];
            NSMutableAttributedString *emoText = [NSAttributedString yy_attachmentStringWithEmojiImage:image fontSize:_font.pointSize].mutableCopy;
            // original text, used for text copy
            [emoText yy_setTextBackedString:backed range:NSMakeRange(0, emoText.length)];
            [emoText yy_setTextBinding:[YYTextBinding bindingWithDeleteConfirm:NO] range:NSMakeRange(0, emoText.length)];
            
            [text replaceCharactersInRange:range withAttributedString:emoText];
            
            if (selectedRange) {
                *selectedRange = [self _replaceTextInRange:range withLength:emoText.length selectedRange:*selectedRange];
            }
            clipLength += range.length - emoText.length;
        }
    }
    
    [text enumerateAttribute:YYTextBindingAttributeName inRange:text.yy_rangeOfAll options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id value, NSRange range, BOOL *stop) {
        if (value && range.length > 1) {
            [text yy_setColor:self->_highlightTextColor range:range];
        }
    }];
    text.yy_font = _font;
    return YES;
}
// correct the selected range during text replacement
- (NSRange)_replaceTextInRange:(NSRange)range withLength:(NSUInteger)length selectedRange:(NSRange)selectedRange {
    // no change
    if (range.length == length) return selectedRange;
    // right
    if (range.location >= selectedRange.location + selectedRange.length) return selectedRange;
    // left
    if (selectedRange.location >= range.location + range.length) {
        selectedRange.location = selectedRange.location + length - range.length;
        return selectedRange;
    }
    // same
    if (NSEqualRanges(range, selectedRange)) {
        selectedRange.length = length;
        return selectedRange;
    }
    // one edge same
    if ((range.location == selectedRange.location && range.length < selectedRange.length) ||
        (range.location + range.length == selectedRange.location + selectedRange.length && range.length < selectedRange.length)) {
        selectedRange.length = selectedRange.length + length - range.length;
        return selectedRange;
    }
    selectedRange.location = range.location + length;
    selectedRange.length = 0;
    return selectedRange;
}
@end
