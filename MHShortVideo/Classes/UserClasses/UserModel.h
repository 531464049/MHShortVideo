//
//  UserModel.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/29.
//  Copyright © 2018 mh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property(nonatomic,copy)NSString * userHeaderImage;
@property(nonatomic,copy)NSString * userName;
@property(nonatomic,copy)NSString * userIntroduce;

+(UserModel *)randomeUser;

@end

