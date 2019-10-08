//
//  CommentHelper.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/5.
//  Copyright © 2018 mh. All rights reserved.
//

#import "CommentHelper.h"

@implementation CommentHelper
#pragma mark - 话题正则
+ (NSRegularExpression *)topicRegex {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"#[^@#]+?\\s+" options:kNilOptions error:NULL];
    });
    return regex;
}
#pragma mark - @好友正则
+ (NSRegularExpression *)atRegex {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"@[-_a-zA-Z0-9\u4E00-\u9FA5]+\\s+" options:kNilOptions error:NULL];
    });
    return regex;
}
#pragma mark - 表情正则
+ (NSRegularExpression *)regexEmoticon {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\[[^ \\[\\]]+?\\]" options:kNilOptions error:NULL];
    });
    return regex;
}
#pragma mark - 表情字典
+ (NSDictionary *)emoticonDic {
    static NSMutableDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = [self creatEmotionDic];
    });
    return dic;
}
+(NSMutableDictionary *)creatEmotionDic
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    NSString * emoticonBundlePath = [[NSBundle mainBundle] pathForResource:@"weiboEmotioninfo" ofType:@"plist"];
    NSArray * emotionArr = [NSArray arrayWithContentsOfFile:emoticonBundlePath];
    //NSLog(@"%@",emotionArr);
    for (NSDictionary * emotionDic in emotionArr) {
        NSString * png = emotionDic[@"png"];
        if (png.length == 0) {
            continue;
        }
        NSString * chs = emotionDic[@"chs"];
        if (chs.length > 0) {
            dic[chs] = png;
        }
    }
    return dic;
}
#pragma mark - 获取表情图片
+ (UIImage *)emotionWithName:(NSString *)name
{
    if (!name) return nil;
    return [UIImage imageNamed:name];
}
@end

