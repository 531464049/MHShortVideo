//
//  PostTitleContentView.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/29.
//  Copyright © 2018 mh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostVideoModel.h"

@protocol PostTitleContentDelegate;

@interface PostTitleContentView : UIView

@property(nonatomic,weak)id <PostTitleContentDelegate> delegate;
@property(nonatomic,strong)PostVideoModel * videoModel;//保存视频信息的模型


-(void)textViewAddATUser:(NSString *)userName;
-(void)textViewAddTopic:(NSString *)topic;

@end


@protocol PostTitleContentDelegate <NSObject>

@optional
/** 话题 点击回调 */
-(void)titleContentTopicItemHandle;
/** @好友 点击回调 */
-(void)titleContentATUserItemHandle;
/** 输入框是否在编辑状态 */
-(void)titleContentTextViewIsEidting:(BOOL)isEidting;

@end
