//
//  HomeVideoModel.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/3.
//  Copyright © 2018 mh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeVideoModel : NSObject

@property(nonatomic,copy)NSString * videoUrl;
@property(nonatomic,copy)NSString * videoPreImage;
@property(nonatomic,copy)NSString * videoTitle;

@property(nonatomic,copy)NSString * userName;
@property(nonatomic,copy)NSString * userImage;

@property(nonatomic,assign)NSInteger zanNum;
@property(nonatomic,assign)NSInteger commentNum;
@property(nonatomic,assign)NSInteger shareNum;

@property(nonatomic,assign)BOOL isLiked;//是否喜欢

+(NSString *)t_videotitle:(NSInteger)index;

+(HomeVideoModel *)randomAModel;

@end

