//
//  MCacheManager.h
//  HzWeather
//
//  Created by 马浩 on 2018/9/5.
//  Copyright © 2018年 马浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCacheManager : NSObject

/**
 将可归档的文件数据保存在沙盒document下
 @param data 可归档的文件
 @param pathKey 存放的路径key（文件名）
 @return 是否成功
 */
+(BOOL)cacheDataInDocument:(id)data pathKey:(NSString *)pathKey;

/**
 将可归档的文件数据保存在沙盒caches下
 @param data 可归档的文件
 @param pathKey 存放的路径key（文件名）
 @return 是否成功
 */
+(BOOL)cacheDataInache:(id)data pathKey:(NSString *)pathKey;

+(void)readDocuemntPathKey:(NSString *)pathKey callBack:(void(^)(BOOL isSuccess , id response))callBack;
+(void)readCachePathKey:(NSString *)pathKey callBack:(void(^)(BOOL isSuccess , id response))callBack;


/**
 计算cache文件夹下所有缓存文件的大小
 @return 文件大小 eg：34.5M
 */
+(NSString *)calculateCachesDirTotleSize;
/** 删除cache文件夹下所有缓存文件 */
+(void)cleanAllCaches;
@end
