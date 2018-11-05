//
//  XLSaveVideo.h
//  NationalRedPacket
//
//  Created by Ying on 2018/7/11.
//  Copyright © 2018 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLSaveVideo : NSObject

/**
 保存视频到相册

 @param url 视频的URL
 */
+ (void)writeVideoToPhotoLibrary:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
