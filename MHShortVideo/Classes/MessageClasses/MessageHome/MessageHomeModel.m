//
//  MessageHomeModel.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/14.
//  Copyright © 2018 mh. All rights reserved.
//

#import "MessageHomeModel.h"

@implementation MessageHomeModel

+(NSArray *)testModels
{
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    
    NSArray * msgArr = @[@"这些东西够不能吃！",@"寻找**首尾人",@"参与新人调查 赢限量**周边",@"你好啊"];
    for (int i = 0; i < 4; i ++) {
        MessageHomeModel * model = [[MessageHomeModel alloc] init];
        model.messageType = i;
        
        model.msgStr = msgArr[i];
        model.msgTimeStr = @"昨天";
        
        if (i == 3) {
            model.userHeaderImage = @"http://pic32.photophoto.cn/20140819/0008020285038599_b.jpg";
            model.userName = @"二狗子";
        }
        
        [arr addObject:model];
    }
    return [NSArray arrayWithArray:arr];
}

@end
