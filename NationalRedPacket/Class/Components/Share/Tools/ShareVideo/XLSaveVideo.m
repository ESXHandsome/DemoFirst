//
//  XLSaveVideo.m
//  NationalRedPacket
//
//  Created by Ying on 2018/7/11.
//  Copyright © 2018 XLook. All rights reserved.
//

#import "XLSaveVideo.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation XLSaveVideo

+ (void)writeVideoToPhotoLibrary:(NSURL *)url {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error){
        if (error == nil) {
            [MBProgressHUD showSuccess:@"视频下载成功"];
        }else{
            [MBProgressHUD showError:@"视频下载失败"];
        }
    }];
}

@end
