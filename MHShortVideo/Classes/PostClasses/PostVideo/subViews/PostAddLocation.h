//
//  PostAddLocation.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/30.
//  Copyright © 2018 mh. All rights reserved.
//

#import "BaseView.h"

@protocol PostAddLocationDelegate;

@interface PostAddLocation : BaseView

@property(nonatomic,weak)id <PostAddLocationDelegate> delegate;
@property(nonatomic,copy)NSString * curentLocationName;//当前位置名称

@end


@protocol PostAddLocationDelegate <NSObject>

@optional
/** 选中的位置回调 */
-(void)postAddLocationChoosedLocation:(NSString *)locationName;
/** 更多按钮点击回调 */
-(void)postAddLocationMoreItemHandle;

@end
