//
//  CommentModel.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/5.
//  Copyright © 2018 mh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentHelper.h"
#import "CommentLayout.h"
#import "MHLinePositionModifier.h"


@interface CommentModel : NSObject

@property(nonatomic,copy)NSString * username;
@property(nonatomic,copy)NSString * userimage;
@property(nonatomic,copy)NSString * content;
@property(nonatomic,copy)NSString * time;
@property(nonatomic,assign)NSInteger zanNum;
@property(nonatomic,assign)BOOL beZan;


@property(nonatomic,assign)CGFloat contentHeight;//评论内容高度
@property(nonatomic,strong)YYTextLayout * contentTextLayout;//评论内容约束
@property(nonatomic,assign)CGFloat cellHeight;//整体cell高度

/** 根据model基本信息 计算约束 */
+(void)layoutCommnet:(CommentModel *)model;

/**
 正则匹配-返回匹配后的内容富文本
 @param content 评论内容
 @param postTime 评论时间
 @return 匹配后的富文本
 */
-(NSMutableAttributedString *)contentToAttribute:(NSString *)content postTime:(NSString *)postTime;

+(CommentModel *)test_getAModel;

+(NSArray *)test_getModels;
@end
