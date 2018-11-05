//
//  XLDownloadVideo.h
//  NationalRedPacket
//
//  Created by Ying on 2018/7/31.
//  Copyright © 2018 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^successBlock)(id path);
typedef void(^failedBlock)(id error);
typedef void(^progressBlock)(id progress);

@interface XLDownloadVideo : NSObject
+ (instancetype)sharedInstance;
- (void)downloadVideo:(NSString *)videoURL
              success:(successBlock)success
             progress:(progressBlock)progress
               failed:(failedBlock)failed;
@end

NS_ASSUME_NONNULL_END
