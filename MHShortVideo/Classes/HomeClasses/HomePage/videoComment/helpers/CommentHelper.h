//
//  CommentHelper.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/5.
//  Copyright © 2018 mh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentHelper : NSObject

/// 话题正则 例如 #哈哈哈
+ (NSRegularExpression *)topicRegex;
/// @好友正则 例如 @你好啊
+ (NSRegularExpression *)atRegex;


/// 表情正则 例如 [偷笑]
+ (NSRegularExpression *)regexEmoticon;
/// 表情字典 key:[偷笑] value:ImagePath
+ (NSDictionary *)emoticonDic;
/// 根据表情名字获取图片
+ (UIImage *)emotionWithName:(NSString *)name;
@end

