//
//  HomeShareView.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/7.
//  Copyright © 2018 mh. All rights reserved.
//

#import "BaseView.h"
#import "HomeVideoModel.h"

@interface HomeShareView : BaseView

+(void)showShareWindowWithVideo:(HomeVideoModel *)model;

@end
