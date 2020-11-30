//
//  XBFileManager.h
//  XBDemo
//
//  Created by XB on 2020/9/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "NSString+FilePath.h"

NS_ASSUME_NONNULL_BEGIN

@interface XBFileManager : NSObject

#pragma mark - 文件操作
//文件是否存在
+(BOOL)fileExistsAtPath:(NSString *)filePath;
+(BOOL)copyFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath;
+(BOOL)moveFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath;
+(BOOL)removeFileAtPath:(NSString *)filePath;

#pragma mark - 文件夹操作
//文件夹是否存在
+(BOOL)directoryExistsAtPath:(NSString *)directoryPath;
//创建文件夹
+(BOOL)createDirectoryAtPath:(NSString *)directoryPath;
//删除文件夹(会清除文件夹内文件)
+(BOOL)removeDirectoryAtPath:(NSString *)directoryPath;
//复制文件夹(会复制文件夹内文件)
+(BOOL)copyDirectoryFromPath:(NSString *)fromPath toPath:(NSString *)toPath;
//移动文件夹
+(BOOL)moveDirectoryFromPath:(NSString *)fromPath toPath:(NSString *)toPath;

#pragma mark - 文件计算
//文件夹大小(字节)
+(CGFloat)directorySizeAtPath:(NSString *)directoryPath;
//单个文件的大小(字节)
+(CGFloat)fileSizeAtPath:(NSString *)filePath;

#pragma mark - 文件存储到本地
//图片存储到本地 (.jpg)
+(BOOL)saveImage:(UIImage *)image toFilePath:(NSString *)filePath;
//视频存储到本地 (.mp4)
+(void)saveVideo:(AVAsset *)avAsset toFilePath:(NSString *)filePath callback:(void(^)(NSError * error))callback;


@end

NS_ASSUME_NONNULL_END
