//
//  CommentLayout.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/5.
//  Copyright © 2018 mh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentHelper.h"

@interface CommentLayout : NSObject

@property(nonatomic,assign,readonly)CGFloat userHeader_left;//头像 左边距
@property(nonatomic,assign,readonly)CGFloat userHeader_top;//头像 上边距
@property(nonatomic,assign,readonly)CGFloat userHeader_width;//头像宽度 长=宽

@property(nonatomic,assign,readonly)CGFloat userName_header;//名字 -头像
@property(nonatomic,assign,readonly)CGFloat userName_top;//名字 上边距
@property(nonatomic,assign,readonly)CGFloat userName_right;//名字 右边距
@property(nonatomic,assign,readonly)CGFloat userName_height;//名字 高度
@property(nonatomic,assign,readonly)CGFloat userName_fontSize;//名字 字体大小
@property(nonatomic,assign,readonly)UIColor * userName_color;//名字 颜色

@property(nonatomic,assign,readonly)CGFloat content_header;//内容-头像 左边距
@property(nonatomic,assign,readonly)CGFloat content_name;//内容-名字 上边距
@property(nonatomic,assign,readonly)CGFloat content_right;//内容-右边距
@property(nonatomic,assign,readonly)CGFloat content_nomalFontSize;//内容 字体大小
@property(nonatomic,assign,readonly)UIColor * content_nomalColor;//内容 颜色
@property(nonatomic,assign,readonly)UIColor * content_hightLightColor;//内容 高亮颜色
@property(nonatomic,assign,readonly)CGFloat content_smallFontSize;//内容 小文字字体大小
@property(nonatomic,assign,readonly)UIColor * content_smallColor;//内容 小文字颜色

@end
