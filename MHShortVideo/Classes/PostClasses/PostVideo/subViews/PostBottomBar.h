//
//  PostBottomBar.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/3.
//  Copyright © 2018 mh. All rights reserved.
//

#import "BaseView.h"

@protocol PostBottomBarDelegate;

@interface PostBottomBar : BaseView
@property(nonatomic,weak)id <PostBottomBarDelegate> delegate;
@property(nonatomic,assign,readonly)BOOL saveToLocal;//是否保存到本地

@end


@protocol PostBottomBarDelegate <NSObject>

@optional
-(void)postBottomHandleClickPost;
-(void)postBottomHandleClickSaveCaoGao;

@end
