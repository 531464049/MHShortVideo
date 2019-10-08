//
//  CommentTextView.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/6.
//  Copyright © 2018 mh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommentInputVideDelegate <NSObject>

@optional
-(void)inputViewSendText:(NSString *)sendText;
/** 键盘弹起/收起 回调 */
-(void)inputVideKeyBordShow:(BOOL)show;

@end

@interface CommentTextView : UIView

@property (nonatomic, weak) id<CommentInputVideDelegate> delegate;


@end
