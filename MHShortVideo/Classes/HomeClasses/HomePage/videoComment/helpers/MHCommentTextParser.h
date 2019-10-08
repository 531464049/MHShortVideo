//
//  MHCommentTextParser.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/5.
//  Copyright © 2018 mh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYText/YYText.h>
#import "CommentHelper.h"

@interface MHCommentTextParser : NSObject<YYTextParser>

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *highlightTextColor;

@end

