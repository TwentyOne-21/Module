//
//  NSString+FilePath.m
//  mars_ios
//
//  Created by XB on 2020/11/25.
//  Copyright © 2020 thirdrock. All rights reserved.
//

#import "NSString+FilePath.h"

@implementation NSString (FilePath)

#pragma mark - 文件路径
+(NSString *)getDocumentPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}
+(NSString *)getLibraryPath {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}
+(NSString *)getCachesPath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}
+(NSString *)getTemporaryPath {
    return NSTemporaryDirectory();
}

+ (NSString *)getRandomFileNameWithType:(NSString *)type {
    NSString *fileName = [NSString stringWithFormat:@"%@.%@",[[NSUUID UUID] UUIDString],type];
    return fileName;
}

@end
