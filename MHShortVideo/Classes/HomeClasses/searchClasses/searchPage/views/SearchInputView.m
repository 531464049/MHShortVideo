//
//  SearchInputView.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/12.
//  Copyright © 2018 mh. All rights reserved.
//

#import "SearchInputView.h"

typedef void(^inputCallBack)(NSString * searchKey);

@interface SearchInputView ()<UITextFieldDelegate>

@property(nonatomic,copy)NSString * curentSearchKey;
@property(nonatomic,copy)inputCallBack callBack;

@property(nonatomic,strong)UITextField * searchTf;//搜索输入框
@property(nonatomic,strong)UIButton * cancleBtn;//取消输入按钮

@end

@implementation SearchInputView

-(instancetype)initWithFrame:(CGRect)frame searchkey:(NSString *)searchKey callBack:(inputCallBack)callBack
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor base_color];
        self.curentSearchKey = searchKey;
        self.callBack = callBack;
        [self commit_tfbar];
    }
    return self;
}
-(void)commit_tfbar
{
    UIView * topBar = [[UIView alloc] initWithFrame:CGRectMake(0, K_StatusHeight, Screen_WIDTH, NavHeight - K_StatusHeight)];
    topBar.backgroundColor = [UIColor base_color];
    [self addSubview:topBar];
    
    CGFloat searchheight = topBar.frame.size.height - Width(3)*2;
    self.searchTf = [[UITextField alloc] initWithFrame:CGRectMake(Width(15), Width(3), Screen_WIDTH - Width(15) - Width(60), searchheight)];
    [self.searchTf addTarget:self action:@selector(textfileEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    self.searchTf.borderStyle = UITextBorderStyleNone;
    self.searchTf.backgroundColor = RGB(50, 50, 50);
    self.searchTf.layer.cornerRadius = 4;
    self.searchTf.layer.masksToBounds = YES;
    NSString * plhStr = @"霍建华进货价";
    self.searchTf.attributedPlaceholder = [plhStr attributedStr:FONT(15) textColor:[UIColor grayColor] lineSpace:0 keming:0];
    self.searchTf.textAlignment = NSTextAlignmentLeft;
    self.searchTf.font = FONT(15);
    self.searchTf.textColor = [UIColor whiteColor];
    self.searchTf.delegate = self;
    
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width(30), searchheight)];
    leftView.backgroundColor = [UIColor clearColor];
    UIImageView * left = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width(15), searchheight)];
    left.center = CGPointMake(Width(15), searchheight/2);
    left.image = [UIImage imageNamed:@"search_gray"];
    left.contentMode = UIViewContentModeScaleAspectFit;
    left.clipsToBounds = YES;
    [leftView addSubview:left];
    self.searchTf.leftView = leftView;
    self.searchTf.leftViewMode = UITextFieldViewModeAlways;
    self.searchTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTf.returnKeyType = UIReturnKeySearch;
    [topBar addSubview:self.searchTf];
    
    self.cancleBtn = [UIButton buttonWithType:0];
    self.cancleBtn.frame = CGRectMake(Screen_WIDTH - Width(60), 0, Width(60), topBar.frame.size.height);
    [self.cancleBtn setTitle:@"取消" forState:0];
    [self.cancleBtn setTitleColor:[UIColor base_yellow_color] forState:0];
    self.cancleBtn.titleLabel.font = FONT(14);
    [self.cancleBtn addTarget:self action:@selector(cancleInput) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:self.cancleBtn];
    
    [self.searchTf becomeFirstResponder];
}
#pragma mark - 点击键盘上的【搜索按钮】
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField.text length] > 0) {
        
        return YES;
    }
    return NO;
}
-(void)textfileEditingChanged:(UITextField *)textfield
{
    UITextRange *selectedRange = [textfield markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textfield positionFromPosition:selectedRange.start offset:0];
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    textfield.rightView.hidden = !textfield.hasText;
    if (textfield.hasText) {
        
    }else{
        
    }
}
-(void)cancleInput
{
    if (self.callBack) {
        self.callBack(nil);
    }
    [self removeFromSuperview];
}
+(void)showWithSearchKey:(NSString *)searchKey callBack:(void (^)(NSString *))callBack
{
    UIWindow * keywindow = [UIApplication sharedApplication].keyWindow;
    if (!keywindow) {
        keywindow = [[UIApplication sharedApplication].windows firstObject];
    }
    
    SearchInputView * vvv = [[SearchInputView alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH, Screen_HEIGTH) searchkey:searchKey callBack:callBack];
    [keywindow addSubview:vvv];
}
@end
