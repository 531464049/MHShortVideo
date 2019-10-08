//
//  PostTFHanldeView.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/29.
//  Copyright © 2018 mh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PostTopicListCell;
@protocol PostTFHanldeDelegate;

@interface PostTFHanldeView : UIView

@property(nonatomic,weak)id <PostTFHanldeDelegate> delegate;

/** 切换到话题列表 */
-(void)updateToTopicList;

@end


@protocol PostTFHanldeDelegate <NSObject>

@optional
/** 回调隐藏键盘 */
-(void)tfHanldeViewHanldeKeyBordDown;
/** 历史话题列表 选中回调 */
-(void)historyTopicListSelectedTopic:(NSString *)topic;

@end



@interface PostTopicListCell : UITableViewCell

@property(nonatomic,copy)NSString * topic;

@end
