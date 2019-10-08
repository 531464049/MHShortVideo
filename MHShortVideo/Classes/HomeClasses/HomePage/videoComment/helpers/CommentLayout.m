//
//  CommentLayout.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/5.
//  Copyright © 2018 mh. All rights reserved.
//

#import "CommentLayout.h"

@implementation CommentLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        _userHeader_left = Width(15);
        _userHeader_top = Width(15);
        _userHeader_width = Width(35);
        _userName_header = Width(10);
        _userName_top = Width(15);
        _userName_right = Width(70);
        _userName_height = _userHeader_width/2;
        _userName_fontSize = 15;
        _userName_color = [UIColor grayColor];
        _content_header = _userName_header;
        _content_name = 10;
        _content_right = _userName_right;
        _content_nomalFontSize = 17;
        _content_nomalColor = [UIColor whiteColor];
        _content_hightLightColor = [UIColor base_yellow_color];
        _content_smallFontSize = 14;
        _content_smallColor = _userName_color;
    }
    return self;
}
@end
