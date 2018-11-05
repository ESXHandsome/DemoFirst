//
//  XLPosrPhotoTools.h
//  NationalRedPacket
//
//  Created by Ying on 2018/7/11.
//  Copyright © 2018 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLPosrPhotoTools : NSObject

/**
 根据路径获取第一帧图像

 @param videoURL 路径
 @return 图像
 */
+(UIImage *)getImage:(NSURL *)videoURL;

/**
 根据路径获取视频的大小和时长

 @param url 路径
 @return 视频和时长的字典
 */
+ (NSDictionary *)getVideoInfoWithSourcePath:(NSURL *)url;

+ (CGFloat)getImageFileSizeWithURL:(NSURL *)url;
@end

NS_ASSUME_NONNULL_END
