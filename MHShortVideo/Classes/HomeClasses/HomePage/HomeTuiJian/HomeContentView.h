//
//  HomeContentView.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/3.
//  Copyright © 2018 mh. All rights reserved.
//

#import "BaseView.h"

@interface HomeContentView : BaseView

/** 首页进入-开始播放 */
-(void)pageStartPlay;
/** 首页消失-停止播放 */
-(void)pageStopPlay;

@end
