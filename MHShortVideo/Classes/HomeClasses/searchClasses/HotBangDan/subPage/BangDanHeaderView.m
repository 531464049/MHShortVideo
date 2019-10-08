//
//  BangDanHeaderView.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/11.
//  Copyright © 2018 mh. All rights reserved.
//

#import "BangDanHeaderView.h"

@interface BangDanHeaderView ()

@property(nonatomic,strong)UIImageView * headerImage;

@end

@implementation BangDanHeaderView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.headerImage = [[UIImageView alloc] initWithFrame:self.bounds];
        self.headerImage.contentMode = UIViewContentModeScaleAspectFill;
        self.headerImage.clipsToBounds = YES;
        self.headerImage.image = [UIImage imageNamed:@"search_hot_bang"];
        [self addSubview:self.headerImage];
    }
    return self;
}
-(void)updateHeaderContentOffY:(CGFloat)offY
{
    if (offY < 0) {
        CGRect imgRect = self.headerImage.frame;
        imgRect.origin.y = offY;
        imgRect.size.height = self.bounds.size.height - offY;
        self.headerImage.frame = imgRect;
    }else{
        self.headerImage.frame = self.bounds;
    }
}

@end
