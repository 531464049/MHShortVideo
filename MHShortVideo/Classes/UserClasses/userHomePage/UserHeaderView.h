//
//  UserHeaderView.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/19.
//  Copyright © 2018 mh. All rights reserved.
//

#import "BaseView.h"

@interface UserHeaderView : BaseView

/** 跟随外界偏移量改变位置 */
-(void)updateHeaderContentOffY:(CGFloat)offy;

@end
