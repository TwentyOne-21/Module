//
//  XBFileManager.m
//  XBDemo
//
//  Created by XB on 2020/9/28.
//

#import "XBFileManager.h"

@implementation XBFileManager

#pragma mark - 文件操作
+(BOOL)fileExistsAtPath:(NSString *)filePath {
    BOOL isDirectory = NO;
    BOOL result = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
    return result&!isDirectory;
}
+(BOOL)copyFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath {
    if (![XBFileManager fileExistsAtPath:fromPath]) return NO;
    
    //如果toPath已经存在 先删除
    BOOL remove = YES;
    if ([XBFileManager fileExistsAtPath:toPath]) {
        remove = [XBFileManager removeFileAtPath:toPath];
    }
    
    BOOL copy = [[NSFileManager defaultManager] copyItemAtPath:fromPath toPath:toPath error:NULL];
    
    return (remove && copy);
}
+(BOOL)moveFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath {
    if (![XBFileManager fileExistsAtPath:fromPath]) return NO;
    
    //如果toPath已经存在 先删除
    BOOL remove = YES;
    if ([XBFileManager fileExistsAtPath:toPath]) {
        remove = [XBFileManager removeFileAtPath:toPath];
    }
    
    BOOL move = [[NSFileManager defaultManager] moveItemAtPath:fromPath toPath:toPath error:NULL];
    
    return (remove && move);
}
+(BOOL)removeFileAtPath:(NSString *)path {
    if (![XBFileManager fileExistsAtPath:path]) return NO;
    
    BOOL remove = [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
    
    return remove;
}

#pragma mark - 文件夹操作
//文件夹是否存在
+(BOOL)directoryExistsAtPath:(NSString *)directoryPath {
    BOOL isDirectory = NO;
    BOOL result = [[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    return result&isDirectory;
}
//创建文件夹
+(BOOL)createDirectoryAtPath:(NSString *)directoryPath {
    if ([XBFileManager directoryExistsAtPath:directoryPath]) return NO;
    return [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:NULL];
}
//删除文件夹
+(BOOL)removeDirectoryAtPath:(NSString *)directoryPath {
    if (![XBFileManager directoryExistsAtPath:directoryPath]) return NO;
    
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:NULL];
    if (files.count > 0) {
        [files enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [XBFileManager removeFileAtPath:[NSString stringWithFormat:@"%@/%@",directoryPath,obj]];
        }];
    }
    
    BOOL remove = [[NSFileManager defaultManager] removeItemAtPath:directoryPath error:NULL];
    
    return remove;
}
//复制文件夹(会复制文件夹内文件)
+(BOOL)copyDirectoryFromPath:(NSString *)fromPath toPath:(NSString *)toPath {
    if (![XBFileManager directoryExistsAtPath:fromPath]) return NO;
    
    if (![XBFileManager directoryExistsAtPath:toPath]) {
        [XBFileManager createDirectoryAtPath:toPath];
    }
    
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fromPath error:NULL];
    [files enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *tempPath = [fromPath stringByAppendingPathComponent:obj];
        if ([XBFileManager directoryExistsAtPath:tempPath]) {
            [XBFileManager copyDirectoryFromPath:tempPath toPath:[NSString stringWithFormat:@"%@/%@",toPath,obj]];
        }else if ([XBFileManager fileExistsAtPath:tempPath]) {
            [XBFileManager copyFileFromPath:tempPath toPath:[NSString stringWithFormat:@"%@/%@",toPath,obj]];
            NSLog(@"%@",[NSString stringWithFormat:@"%@/%@",toPath,obj]);
        }
    }];
    
    return YES;
}
//移动文件夹
+(BOOL)moveDirectoryFromPath:(NSString *)fromPath toPath:(NSString *)toPath {
    if (![XBFileManager directoryExistsAtPath:fromPath]) return NO;
    
    if (![XBFileManager directoryExistsAtPath:toPath]) {
        [XBFileManager createDirectoryAtPath:toPath];
    }
    
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fromPath error:NULL];
    [files enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *tempPath = [fromPath stringByAppendingPathComponent:obj];
        if ([XBFileManager directoryExistsAtPath:tempPath]) {
            [XBFileManager moveDirectoryFromPath:tempPath toPath:[NSString stringWithFormat:@"%@/%@",toPath,obj]];
        }else if ([XBFileManager fileExistsAtPath:tempPath]) {
            [XBFileManager moveFileFromPath:tempPath toPath:[NSString stringWithFormat:@"%@/%@",toPath,obj]];
            NSLog(@"%@",[NSString stringWithFormat:@"%@/%@",toPath,obj]);
        }
    }];
    
    return YES;
}

#pragma mark - 文件计算
//文件夹大小(字节)
+(CGFloat)directorySizeAtPath:(NSString *)directoryPath {
    if (![XBFileManager directoryExistsAtPath:directoryPath]) return 0;
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:directoryPath] objectEnumerator];
    NSString *fileName;
    CGFloat directorySize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString *filePath = [directoryPath stringByAppendingPathComponent:fileName];
        directorySize += [XBFileManager fileSizeAtPath:filePath];
    }
    return directorySize;
}
//单个文件的大小(字节)
+(CGFloat)fileSizeAtPath:(NSString *)filePath {
    if (![XBFileManager fileExistsAtPath:filePath]) return 0;
    NSFileManager *manager = [NSFileManager defaultManager];
    return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
}
#pragma mark - 文件存储到本地
//图片存储到本地
+(BOOL)saveImage:(UIImage *)image toFilePath:(NSString *)filePath {
    if (!image || filePath.length <= 0) return NO;
    if (![XBFileManager directoryExistsAtPath:[filePath stringByDeletingLastPathComponent]]) return NO;
    
    return [UIImageJPEGRepresentation(image, 1.0) writeToFile:filePath atomically:YES];
}
//视频存储到本地
+(void)saveVideo:(AVAsset *)avAsset toFilePath:(NSString *)filePath callback:(void(^)(NSError * error))callback {
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetHighestQuality];
    session.outputURL = [NSURL fileURLWithPath:filePath];
    session.outputFileType = AVFileTypeMPEG4;
    session.shouldOptimizeForNetworkUse = YES;
    [session exportAsynchronouslyWithCompletionHandler:^(void){
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(session.error);
        });
    }];
}

@end
