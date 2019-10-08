//
//  ChatInputView.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/17.
//  Copyright © 2018 mh. All rights reserved.
//

#import "ChatInputView.h"
#import "MHChatTextParser.h"
#import "MHLinePositionModifier.h"
#import "MHEmotionInputView.h"

@interface ChatInputView ()<YYTextViewDelegate, YYTextKeyboardObserver,MHEmotionInputViewDelegate>
{
    CGRect _oldRect;//初始化时的rect
    CGFloat _inputTopMargin;//输入框距顶部/底部距离
    CGFloat _totleHeight;//整体高度
}
@property(nonatomic,strong)YYTextView *textView;
@property(nonatomic,strong)UIButton * chooseImageItem;//相册选图按钮
@property(nonatomic,strong)UIButton * emotionItem;//表情按钮

@end

@implementation ChatInputView

- (void)dealloc {
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _oldRect = frame;
        _inputTopMargin = Width(10);
        _totleHeight = frame.size.height;
        self.backgroundColor = [UIColor base_color];
        [[YYTextKeyboardManager defaultManager] addObserver:self];
        [self commit_subViews];
    }
    return self;
}
-(void)commit_subViews
{
    UIView * topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
    topLine.backgroundColor = [UIColor grayColor];
    [self addSubview:topLine];
    
    _textView = [YYTextView new];
    _textView.frame = CGRectMake(Width(10), _inputTopMargin, self.frame.size.width - Width(10) - Width(80), self.frame.size.height - _inputTopMargin*2);
    _textView.backgroundColor = [UIColor grayColor];
    _textView.layer.cornerRadius = 4;
    _textView.layer.masksToBounds = YES;
    _textView.textContainerInset = UIEdgeInsetsMake(Width(5), 0, 0, 0);
    _textView.showsVerticalScrollIndicator = NO;
    _textView.alwaysBounceVertical = YES;
    _textView.allowsCopyAttributedString = NO;
    _textView.font = [UIFont systemFontOfSize:16];
    _textView.textParser = [MHChatTextParser new];
    _textView.delegate = self;
    _textView.returnKeyType = UIReturnKeySend;
    
    MHLinePositionModifier *modifier = [MHLinePositionModifier new];
    modifier.font = [UIFont fontWithName:@"Heiti SC" size:16];
    modifier.paddingTop = 8;
    modifier.paddingBottom = 0;
    modifier.lineHeightMultiple = 1.5;
    _textView.linePositionModifier = modifier;
    
    NSString *placeholderPlainText = @"有爱评论，说点好听的~";
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:placeholderPlainText];
    atr.yy_color = [UIColor darkGrayColor];
    atr.yy_font = [UIFont systemFontOfSize:16];
    _textView.placeholderAttributedText = atr;
    [self addSubview:_textView];
    
    self.emotionItem = [UIButton buttonWithType:0];
    self.emotionItem.frame = CGRectMake(self.frame.size.width - Width(80), 0, Width(40), self.frame.size.height);
    [self.emotionItem setImage:[UIImage imageNamed:@"common_emotion"] forState:0];
    [self.emotionItem addTarget:self action:@selector(emotionItemClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.emotionItem];
    
    self.chooseImageItem = [UIButton buttonWithType:0];
    self.chooseImageItem.frame = CGRectMake(self.frame.size.width - Width(40), 0, Width(40), self.frame.size.height);
    [self.chooseImageItem setImage:[UIImage imageNamed:@"common_at"] forState:0];
    [self.chooseImageItem addTarget:self action:@selector(chooseImageItemClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.chooseImageItem];
}
#pragma mark - YYTextViewDelegate
- (void)textViewDidChange:(YYTextView *)textView
{
    if (_textView.textLayout.rowCount > 1) {
        CGFloat tfHeight = _textView.textLayout.textBoundingSize.height + _textView.textContainerInset.top + _textView.textContainerInset.bottom;
        //输入框上下间隔
        CGFloat totleHeight = tfHeight + _inputTopMargin*2;
        if (totleHeight > _oldRect.size.height) {
            
            _totleHeight = totleHeight;
            
        }else{
            _totleHeight = _oldRect.size.height;
        }
    }else{
        _totleHeight = _oldRect.size.height;
    }
    CGRect nRect = self.frame;
    nRect.origin.y = nRect.origin.y + nRect.size.height - _totleHeight;
    nRect.size.height = _totleHeight;
    self.frame = nRect;
    
    CGRect tfRect = self.textView.frame;
    tfRect.size.height = self.frame.size.height - _inputTopMargin*2;
    self.textView.frame = tfRect;
}
- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self input_Send];
        return NO;
    }
    return YES;
}
#pragma mark - 发送
-(void)input_Send
{
    if (_textView.text.length > 0) {
        [_textView resignFirstResponder];
        //发送
        [_textView setText:@""];
    }
}
#pragma mark - YYTextKeyboardObserver
- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition
{
    CGRect toFrame = transition.toFrame;
    CGFloat keybordOriginY = toFrame.origin.y;
    CGFloat keybordHeight = toFrame.size.height;
    //NSLog(@"键盘 %f",keybordOriginY);
    
    CGRect n_rect = self.frame;
    
    if (keybordOriginY < Screen_HEIGTH) {
        n_rect.origin.y = _oldRect.origin.y + _oldRect.size.height + k_bottom_margin - keybordHeight - _totleHeight;
//        if (self.delegate && [self.delegate respondsToSelector:@selector(inputVideKeyBordShow:)]) {
//            [self.delegate inputVideKeyBordShow:YES];
//        }
    }else{
        n_rect.origin.y = _oldRect.origin.y + _oldRect.size.height - _totleHeight;
//        if (self.delegate && [self.delegate respondsToSelector:@selector(inputVideKeyBordShow:)]) {
//            [self.delegate inputVideKeyBordShow:NO];
//        }
    }
    
    if (transition.animationDuration == 0) {
        self.frame = n_rect;
    }else{
        [UIView animateWithDuration:transition.animationDuration delay:0 options:transition.animationOption | UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.frame = n_rect;
        } completion:NULL];
    }
}
#pragma mark - 显示/关闭表情键盘
-(void)emotionItemClick
{
    if (_textView.inputView) {
        _textView.inputView = nil;
        [_textView reloadInputViews];
        [_textView becomeFirstResponder];
    } else {
        MHEmotionInputView * emotionView = [MHEmotionInputView sharedInstance];
        emotionView.delegate = self;
        _textView.inputView = emotionView;
        [_textView reloadInputViews];
        [_textView becomeFirstResponder];
    }
}
#pragma mark - 表情键盘回调
- (void)emoticonInputDidTapText:(NSString *)text
{
    if (text.length) {
        [_textView replaceRange:_textView.selectedTextRange withText:text];
    }
}
- (void)emoticonInputDidTapBackspace
{
    [_textView deleteBackward];
}
- (void)emoticonInputDidTapSend
{
    [self input_Send];
}
-(void)chooseImageItemClick
{
    
}
@end
