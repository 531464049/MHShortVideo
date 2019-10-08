//
//  UserModel.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/29.
//  Copyright © 2018 mh. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+(UserModel *)randomeUser
{
    NSArray * imgArr = @[
                         @"http://tx.haiqq.com/uploads/allimg/c161025/14M32W35M640-31Q8.jpg",
                         @"http://tx.haiqq.com/uploads/allimg/c161025/14M32W3601c0-134H8.jpg",
                         @"http://www.jf258.com/uploads/2015-05-15/102214870.jpg",
                         @"http://pic103.nipic.com/file/20160713/9168605_090218320763_2.jpg"];
    
    NSArray * nameArr = @[
                          @"明太祖-朱元璋",
                          @"明惠帝-朱允炆",
                          @"明成祖-朱棣",
                          @"明仁宗-朱高炽",
                          @"明宣宗-朱瞻基",
                          @"明英宗-朱祁镇",
                          @"明代宗-朱祁钰",
                          @"明宪宗-朱见深",
                          @"明孝宗-朱佑樘",
                          @"明武宗-朱厚照"];
    
    UserModel * model = [UserModel new];
    
    int x = arc4random() % 4;
    model.userHeaderImage = imgArr[x];
    
    int y = arc4random() % 10;
    model.userName = nameArr[y];
    
    model.userIntroduce = nil;
    
    return model;
}

@end
