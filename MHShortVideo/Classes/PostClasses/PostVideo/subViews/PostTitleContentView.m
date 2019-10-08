//
//  PostTitleContentView.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/29.
//  Copyright © 2018 mh. All rights reserved.
//

#import "PostTitleContentView.h"
#import "MHComposeTextParser.h"

@interface PostTitleContentView ()<YYTextViewDelegate>

@property(nonatomic,strong)YYTextView *textView;//输入框
@property(nonatomic,strong)UIImageView * preImgView;//封面

@end

@implementation PostTitleContentView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubViews];
    }
    return self;
}
-(void)creatSubViews
{
    _textView = [[YYTextView alloc] initWithFrame:CGRectMake(Width(10), Width(10), self.frame.size.width-Width(100) - Width(20), Width(105) - Width(20))];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.textColor = [UIColor whiteColor];
    _textView.textContainerInset = UIEdgeInsetsMake(Width(5), Width(5), Width(5), Width(5));
    _textView.font = FONT(15);
    _textView.textParser = [MHComposeTextParser new];
    _textView.delegate = self;
    
    YYTextLinePositionSimpleModifier * modifier = [YYTextLinePositionSimpleModifier new];
    modifier.fixedLineHeight = 20;
    _textView.linePositionModifier = modifier;
    
    NSString *placeholderPlainText = @"写标题并使用合适的话题，能让更多人看到~";
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:placeholderPlainText];
    atr.yy_color = [UIColor grayColor];
    atr.yy_font = FONT(15);
    _textView.placeholderAttributedText = atr;
    [self addSubview:_textView];
    
    _preImgView = [[UIImageView alloc] init];
    _preImgView.contentMode = UIViewContentModeScaleAspectFill;
    _preImgView.clipsToBounds = YES;
    _preImgView.layer.cornerRadius = 4;
    _preImgView.layer.masksToBounds = YES;
    [self addSubview:_preImgView];
    _preImgView.sd_layout.rightSpaceToView(self, Width(15)).topSpaceToView(self, Width(15)).bottomSpaceToView(self, Width(15)).leftSpaceToView(_textView, Width(10));
    
    //话题 好友
    UIButton * topicBtn = [UIButton buttonWithType:0];
    topicBtn.frame = CGRectMake(Width(15), CGRectGetMaxY(self.textView.frame) + Width(10), Width(60), Width(25));
    topicBtn.backgroundColor = RGB(27, 28, 36);
    [topicBtn setTitle:@"#话题" forState:0];
    [topicBtn setTitleColor:[UIColor whiteColor] forState:0];
    topicBtn.titleLabel.font = FONT(15);
    topicBtn.layer.cornerRadius = 3;
    topicBtn.layer.masksToBounds = YES;
    [topicBtn addTarget:self action:@selector(topicItemClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:topicBtn];
    
    UIButton * atBtn = [UIButton buttonWithType:0];
    atBtn.frame = CGRectMake(CGRectGetMaxX(topicBtn.frame) + Width(10), CGRectGetMaxY(self.textView.frame) + Width(10), Width(60), Width(25));
    atBtn.backgroundColor = RGB(27, 28, 36);
    [atBtn setTitle:@"@好友" forState:0];
    [atBtn setTitleColor:[UIColor whiteColor] forState:0];
    atBtn.titleLabel.font = FONT(15);
    atBtn.layer.cornerRadius = 3;
    atBtn.layer.masksToBounds = YES;
    [atBtn addTarget:self action:@selector(atItemClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:atBtn];
    
    UIView * speLine = [[UIView alloc] init];
    speLine.backgroundColor = [UIColor grayColor];
    [self addSubview:speLine];
    speLine.sd_layout.leftSpaceToView(self, Width(15)).bottomSpaceToView(self, 0).rightSpaceToView(self, Width(15)).heightIs(0.5);
}
- (void)setVideoModel:(PostVideoModel *)videoModel
{
    _videoModel = videoModel;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage * img = [MHVideoTool mh_getVideoTempImageFromVideo:[NSURL fileURLWithPath:videoModel.finalVideoPath] withTime:videoModel.videoCaverLocation];
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_preImgView.image = img;
        });
    });
}
#pragma mark - 话题 点击
-(void)topicItemClick
{
    if (!self.textView.isFirstResponder) {
        [self.textView becomeFirstResponder];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(titleContentTopicItemHandle)]) {
        [self.delegate titleContentTopicItemHandle];
    }
}
#pragma mark - @好友 点击
-(void)atItemClick
{
    if (!self.textView.isFirstResponder) {
        [self.textView becomeFirstResponder];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(titleContentATUserItemHandle)]) {
        [self.delegate titleContentATUserItemHandle];
    }
}
#pragma mark - 添加一个话题
-(void)textViewAddTopic:(NSString *)topic
{
    [self.textView becomeFirstResponder];
    NSString * topicStr = [NSString stringWithFormat:@"#%@ ",topic];
    [_textView replaceRange:_textView.selectedTextRange withText:topicStr];
}
#pragma mark - 添加一个 @的好友
-(void)textViewAddATUser:(NSString *)userName
{
    [self.textView becomeFirstResponder];
    NSString * asStr = [NSString stringWithFormat:@"@%@ ",userName];
    [_textView replaceRange:_textView.selectedTextRange withText:asStr];
}
- (void)textViewDidChange:(YYTextView *)textView {
    if (textView.text.length == 0) {
        textView.textColor = [UIColor whiteColor];
    }
}
- (void)textViewDidBeginEditing:(YYTextView *)textView
{
    DLog(@"textViewDidBeginEditing");
    if (self.delegate && [self.delegate respondsToSelector:@selector(titleContentTextViewIsEidting:)]) {
        [self.delegate titleContentTextViewIsEidting:YES];
    }
}
- (void)textViewDidEndEditing:(YYTextView *)textView
{
    DLog(@"textViewDidEndEditing");
    if (self.delegate && [self.delegate respondsToSelector:@selector(titleContentTextViewIsEidting:)]) {
        [self.delegate titleContentTextViewIsEidting:NO];
    }
}
@end
