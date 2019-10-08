//
//  HomePageRightBar.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/4.
//  Copyright © 2018 mh. All rights reserved.
//

#import "BaseView.h"
#import "HomeVideoModel.h"

typedef enum : NSInteger  {
    PageRightBarHandleTypeFocusUser      = 0, //用户头像-关注
    PageRightBarHandleTypeLike           = 1, //喜欢
    PageRightBarHandleTypeComment        = 2, //评论
    PageRightBarHandleTypeShare          = 3, //分享
}PageRightBarHandleType;//首页videopage右侧bar点击类型

@protocol HomePageRightBarDelegate;

@interface HomePageRightBar : BaseView
// 60 + 10 + 60*3 + 10*2 + 30 + 50 + 10

@property(nonatomic,weak)id <HomePageRightBarDelegate> delegate;

@property(nonatomic,strong)HomeVideoModel * videoModel;

@end

@protocol HomePageRightBarDelegate <NSObject>

@optional
-(void)pageRightBarHandle:(PageRightBarHandleType)handleType;

@end
