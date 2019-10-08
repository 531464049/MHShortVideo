//
//  FDGuessLikeUser.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/14.
//  Copyright © 2018 mh. All rights reserved.
//

#import "BaseView.h"

@protocol FDGuessLikeDelegate;

/** 好友推荐 猜你喜欢 */
@interface FDGuessLikeUser : BaseView

@property(nonatomic,weak)id <FDGuessLikeDelegate> delegate;

@end


@protocol FDGuessLikeDelegate <NSObject>

@optional
/** 用户点击回调-理论上应该传递过去真个usermodel */
-(void)fdGuessLikeUserHandleSelectedUser:(NSString *)userName;
/** 查看更多 */
-(void)fdGuessLikeUserHandleCheckMore;
@end
