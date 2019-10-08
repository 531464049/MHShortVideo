//
//  SearchModel.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/10.
//  Copyright © 2018 mh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchModel : NSObject

@property(nonatomic,copy)NSString * topicName;//话题名称
@property(nonatomic,copy)NSString * dataNumStr;//话题重复次数 202.8w
@property(nonatomic,strong)NSArray * topicImagesArr;//话题图片数组

+(NSArray *)randomDataArr;

@end


@interface SearchHeaderModel : NSObject

@property(nonatomic,strong)NSArray * hotSearchModels;
@property(nonatomic,strong)NSArray * adArr;

+(SearchHeaderModel *)randomHeadeModel;

@end


@interface HotSearchModel : NSObject

@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * imgUrl;
@property(nonatomic,assign)NSInteger hotType;//0-热 2-新 1-默认

@end
