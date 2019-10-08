//
//  SRCompositeModel.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/11.
//  Copyright © 2018 mh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeVideoModel.h"
#import "CommentModel.h"

@class SRCompositeLayout;

@interface SRCompositeModel : NSObject

@property(nonatomic,strong)HomeVideoModel * videoModel;
@property(nonatomic,strong)CommentModel * commentModel;

@property(nonatomic,assign)CGFloat videoTitleHeight;//视频标题高度
@property(nonatomic,assign)CGFloat totleHeight;//整体高度

+(NSArray *)randomModels;

@end


@interface SRCompositeLayout : NSObject

@property(nonatomic,assign)CGFloat leftRightMaring;//内容 左右 间隔
@property(nonatomic,assign)CGFloat headerTop;//头像-顶端 间隔
@property(nonatomic,assign)CGFloat headerImageWidth;//用户头像宽度=高度
@property(nonatomic,assign)CGFloat header_title_margin;//头像-标题 间隔
@property(nonatomic,strong)UIFont * titleFont;//标题字体
@property(nonatomic,assign)CGFloat title_preImage_margin;//标题-预览 间隔
@property(nonatomic,assign)CGFloat preImageWidth;//预览 宽度
@property(nonatomic,assign)CGFloat preImageHeight;//预览 高度
@property(nonatomic,assign)CGFloat videoBarHeight;//视频底部bar 高度

@end
