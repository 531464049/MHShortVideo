//
//  SRCompositeCellBar.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/12.
//  Copyright © 2018 mh. All rights reserved.
//

#import "SRCompositeCellBar.h"

@interface SRCompositeCellBar ()



@end

@implementation SRCompositeCellBar

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat margin = Width(15);
        CGFloat itemWidth = (Screen_WIDTH - margin*2)/4;
        NSArray * imgArr = @[@"",@"home_comment",@"home_share",@"home_share"];
        for (int i = 0; i < 4; i ++) {
            UIView * itemView = [[UIView alloc] initWithFrame:CGRectMake(margin + itemWidth * i, 0, itemWidth, frame.size.height)];
            [self addSubview:itemView];
            
            UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width(25), frame.size.height)];
            icon.contentMode = UIViewContentModeScaleAspectFit;
            icon.clipsToBounds = YES;
            icon.tag = 3000 + i;
            [itemView addSubview:icon];
            if (i > 0) {
                icon.image = [UIImage imageNamed:imgArr[i]];
            }
            
            UILabel * lab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(14) aligent:NSTextAlignmentLeft];
            lab.numberOfLines = 1;
            lab.frame = CGRectMake(Width(25), 0, itemWidth - Width(25), frame.size.height);
            lab.tag = 4000 + i;
            [itemView addSubview:lab];
        }
    }
    return self;
}
-(void)setVideoModel:(HomeVideoModel *)videoModel
{
    _videoModel = videoModel;
    
    UIImageView * likeIcon = (UIImageView *)[self viewWithTag:3000];
    if (videoModel.isLiked) {
        likeIcon.image = [UIImage imageNamed:@"home_lineSelected"];
    }else{
        likeIcon.image = [UIImage imageNamed:@"home_likeUnSelected"];
    }
    UILabel * likeNum = (UILabel *)[self viewWithTag:4000];
    likeNum.text = [NSObject numToStr:videoModel.zanNum];
    UILabel * commentNum = (UILabel *)[self viewWithTag:4000 + 1];
    commentNum.text = [NSObject numToStr:videoModel.commentNum];
    UILabel * shareNum = (UILabel *)[self viewWithTag:4000 + 2];
    shareNum.text = [NSObject numToStr:videoModel.shareNum];
    UILabel * shareNum2 = (UILabel *)[self viewWithTag:4000 + 3];
    shareNum2.text = [NSObject numToStr:videoModel.shareNum];
}
@end
