//
//  PostWCSVC.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/3.
//  Copyright © 2018 mh. All rights reserved.
//

#import "BaseViewController.h"

@class WhoCSCell;

typedef void(^whoCanSeeCallBack)(MHPostVideoOpenType openType);

@interface PostWCSVC : BaseViewController

@property(nonatomic,copy)whoCanSeeCallBack callBack;

@property(nonatomic,assign)MHPostVideoOpenType openType;

@end


@interface WhoCSCell : BaseCell

@property(nonatomic,assign)NSInteger a_index;
@property(nonatomic,assign)BOOL a_isSelected;

@end
