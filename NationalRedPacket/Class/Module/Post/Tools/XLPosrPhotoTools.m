//
//  XLPosrPhotoTools.m
//  NationalRedPacket
//
//  Created by Ying on 2018/7/11.
//  Copyright © 2018 XLook. All rights reserved.
//

#import "XLPosrPhotoTools.h"
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>

@implementation XLPosrPhotoTools

+ (UIImage *)getImage:(NSURL *)videoURL {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
}

+ (NSDictionary *)getVideoInfoWithSourcePath:(NSURL *)url {
    AVURLAsset * asset = [AVURLAsset assetWithURL:url];
    CMTime   time = [asset duration];
    int seconds = ceil(time.value/time.timescale);
    NSString *path = [url absoluteString];
    NSInteger   fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
    return @{@"size" : @(fileSize),
             @"duration" : @(seconds)};
}

+ (CGFloat)getImageFileSizeWithURL:(NSURL *)url
{
    NSURL *mUrl = nil;
    if ([url isKindOfClass:[NSURL class]]) {
        mUrl = url;
    }
    if (!mUrl) {
        return 0.0f;
    }
    
    CGFloat fileSize = 0;
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithURL((CFURLRef)mUrl, NULL);
    if (imageSourceRef) {
        CFDictionaryRef imageProperties = CGImageSourceCopyProperties(imageSourceRef, NULL);
        if (imageProperties != NULL) {
            CFNumberRef fileSizeNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyFileSize);
            if (fileSizeNumberRef != NULL) {
                CFNumberGetValue(fileSizeNumberRef, kCFNumberFloat64Type, &fileSize);
            }
            CFRelease(imageProperties);
        }
        CFRelease(imageSourceRef);
    }
    return fileSize;
}
@end
