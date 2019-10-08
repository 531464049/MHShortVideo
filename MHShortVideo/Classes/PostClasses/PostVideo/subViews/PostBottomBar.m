//
//  PostBottomBar.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/3.
//  Copyright © 2018 mh. All rights reserved.
//

#import "PostBottomBar.h"

@interface PostBottomBar ()

@property(nonatomic,strong)UIImageView * localSaveIcon;//保存本地 图标
@property(nonatomic,strong)UILabel * localSaveLab;//保存本地 lab

@end

@implementation PostBottomBar

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _saveToLocal = YES;
        [self commit_subViews];
    }
    return self;
}
-(void)commit_subViews
{
    self.localSaveLab = [UILabel labTextColor:[UIColor base_yellow_color] font:FONT(13) aligent:NSTextAlignmentCenter];
    self.localSaveLab.text = @"保存本地";
    [self addSubview:self.localSaveLab];
    self.localSaveLab.sd_layout.rightSpaceToView(self, Width(15)).centerYIs(Width(15)).heightIs(Width(30));
    [self.localSaveLab setSingleLineAutoResizeWithMaxWidth:120];
    [self.localSaveLab updateLayout];
    
    self.localSaveIcon = [[UIImageView alloc] init];
    self.localSaveIcon.image = [UIImage imageNamed:@"post_localSave"];
    self.localSaveIcon.contentMode = UIViewContentModeScaleAspectFit;
    self.localSaveIcon.clipsToBounds = YES;
    [self addSubview:self.localSaveIcon];
    self.localSaveIcon.sd_layout.rightSpaceToView(self.localSaveLab, 5).centerYEqualToView(self.localSaveLab).widthIs(15).heightEqualToWidth();
    
    UIButton * tap = [UIButton buttonWithType:0];
    [tap addTarget:self action:@selector(localSaveTap) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:tap];
    tap.sd_layout.rightSpaceToView(self, 0).centerYIs(Width(15)).heightIs(Width(30)).widthIs(Width(90));
    
    CGFloat itemWidth = (Screen_WIDTH - Width(15)*2 - Width(10))/2;
    
    UIButton * caogao = [UIButton buttonWithType:0];
    [caogao setBackgroundColor:RGB(43, 43, 53)];
    [caogao setTitle:@"草稿" forState:0];
    [caogao setTitleColor:[UIColor whiteColor] forState:0];
    [caogao setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [caogao setImage:[UIImage imageNamed:@"post_saveDocument"] forState:0];
    caogao.layer.cornerRadius = 4;
    caogao.layer.masksToBounds = YES;
    [caogao addTarget:self action:@selector(saveCaoGao) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:caogao];
    caogao.sd_layout.leftSpaceToView(self, Width(15)).bottomSpaceToView(self, Width(25)).heightIs(Width(45)).widthIs(itemWidth);
    
    UIButton * post = [UIButton buttonWithType:0];
    [post setBackgroundColor:RGB(243, 13, 68)];
    [post setTitle:@"发布" forState:0];
    [post setTitleColor:[UIColor whiteColor] forState:0];
    [post setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [post setImage:[UIImage imageNamed:@"post_post"] forState:0];
    post.layer.cornerRadius = 4;
    post.layer.masksToBounds = YES;
    [post addTarget:self action:@selector(post) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:post];
    post.sd_layout.leftSpaceToView(caogao, Width(10)).centerYEqualToView(caogao).widthIs(itemWidth).heightRatioToView(caogao, 1);
}
-(void)localSaveTap
{
    if (_saveToLocal) {
        self.localSaveIcon.image = [UIImage imageNamed:@"post_unLocalSave"];
        self.localSaveLab.textColor = [UIColor grayColor];
    }else{
        self.localSaveIcon.image = [UIImage imageNamed:@"post_localSave"];
        self.localSaveLab.textColor = [UIColor base_yellow_color];
    }
    _saveToLocal = !_saveToLocal;
}
-(void)saveCaoGao
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(postBottomHandleClickSaveCaoGao)]) {
        [self.delegate postBottomHandleClickSaveCaoGao];
    }
}
-(void)post
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(postBottomHandleClickPost)]) {
        [self.delegate postBottomHandleClickPost];
    }
}
@end
