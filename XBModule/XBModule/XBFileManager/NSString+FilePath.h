//
//  NSString+FilePath.h
//  mars_ios
//
//  Created by XB on 2020/11/25.
//  Copyright © 2020 thirdrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (FilePath)

#pragma mark - 文件路径
+(NSString *)getDocumentPath;
+(NSString *)getLibraryPath;
+(NSString *)getCachesPath;
+(NSString *)getTemporaryPath;

/*
 *  创建随机文件名
 *  eg: 传入type = mp4 return xxx.mp4
 */
+ (NSString *)getRandomFileNameWithType:(NSString *)type;

@end

NS_ASSUME_NONNULL_END
