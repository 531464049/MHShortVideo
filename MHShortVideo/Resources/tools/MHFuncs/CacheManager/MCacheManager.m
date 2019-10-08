//
//  MCacheManager.m
//  HzWeather
//
//  Created by 马浩 on 2018/9/5.
//  Copyright © 2018年 马浩. All rights reserved.
//

#import "MCacheManager.h"

@implementation MCacheManager
#pragma mark - 根据key获取缓存路径
+(NSString *)documentPathFromKey:(NSString *)pathKey
{
    NSString *lib_cash = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * cacheFolderPath = [lib_cash stringByAppendingPathComponent:@"WeatherDomCache"];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSError *error = nil;
    if(![filemgr createDirectoryAtPath:cacheFolderPath withIntermediateDirectories:YES attributes:nil error:&error]) {
        cacheFolderPath = nil;
    }
    NSString *cashPath =  [cacheFolderPath stringByAppendingPathComponent:pathKey];
    return cashPath;
}
#pragma mark - 根据key获取缓存路径
+(NSString *)cachePathFromKey:(NSString *)pathKey
{
    NSString *lib_cash = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * cacheFolderPath = [lib_cash stringByAppendingPathComponent:@"WeatherCacheDir"];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSError *error = nil;
    if(![filemgr createDirectoryAtPath:cacheFolderPath withIntermediateDirectories:YES attributes:nil error:&error]) {
        cacheFolderPath = nil;
    }
    NSString *cashPath =  [cacheFolderPath stringByAppendingPathComponent:pathKey];
    return cashPath;
}
+(BOOL)cacheDataInDocument:(id)data pathKey:(NSString *)pathKey
{
    return [NSKeyedArchiver archiveRootObject:data toFile:[MCacheManager documentPathFromKey:pathKey]];
}
+(BOOL)cacheDataInache:(id)data pathKey:(NSString *)pathKey
{
    return [NSKeyedArchiver archiveRootObject:data toFile:[MCacheManager cachePathFromKey:pathKey]];
}
+(void)readDocuemntPathKey:(NSString *)pathKey callBack:(void (^)(BOOL, id))callBack
{
    NSString * path = [MCacheManager documentPathFromKey:pathKey];
    id data = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (data) {
        callBack(YES,data);
    }else{
        callBack(NO,nil);
    }
}
+(void)readCachePathKey:(NSString *)pathKey callBack:(void (^)(BOOL, id))callBack
{
    NSString * path = [MCacheManager cachePathFromKey:pathKey];
    id data = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (data) {
        callBack(YES,data);
    }else{
        callBack(NO,nil);
    }
}
#pragma mark - 计算cache文件夹下所有缓存文件的大小
+(NSString *)calculateCachesDirTotleSize
{
    NSString *lib_cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    float totalSize = 0;
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:lib_cache];
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [lib_cache stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        unsigned long long length = [attrs fileSize];
        totalSize += length / 1024.0 / 1024.0;
    }
    return [NSString stringWithFormat:@"%.2fM",totalSize];
}
#pragma mark - 删除cache文件夹下所有缓存文件
+(void)cleanAllCaches
{
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) firstObject];
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
    for (NSString *subFile in files) {
        NSError *error;
        NSString *path = [cachPath stringByAppendingPathComponent:subFile];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        }
    }
}
@end
