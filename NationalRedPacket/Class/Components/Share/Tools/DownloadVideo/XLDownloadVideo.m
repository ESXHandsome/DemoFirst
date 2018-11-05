
//
//  XLDownloadVideo.m
//  NationalRedPacket
//
//  Created by Ying on 2018/7/31.
//  Copyright © 2018 XLook. All rights reserved.
//

#import "XLDownloadVideo.h"
#import "XLFileHandler.h"
#import "NSURL+ResourceLoader.h"
#import "XLResourceRequestTask.h"
#import "MBProgressHUD+MJ.h"
#import "MD5Encrypt.h"

static dispatch_queue_t videoSaveSerialQueue;
static NSOperationQueue *videoRequestOperationQueue;

@interface XLDownloadVideo () <NSURLSessionDataDelegate>
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURLSessionDataTask *task;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (assign, nonatomic) BOOL isWorking;
@end

@implementation XLDownloadVideo

+ (instancetype)sharedInstance
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (void)configHUD {
    
    self.hud = [[MBProgressHUD alloc] init];
    self.hud.mode = MBProgressHUDModeText;
    self.hud.detailsLabel.text = @"正在下载视频";
    self.hud.offset = CGPointMake(0, adaptHeight1334(213.5*2));
    self.hud.detailsLabel.font = [UIFont systemFontOfSize:adaptFontSize(30)];
    self.hud.detailsLabel.textColor = [UIColor colorWithString:COLORffffff];
    self.hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.6];
    self.hud.bezelView.layer.cornerRadius = adaptFontSize(8);
    self.hud.margin = adaptWidth750(25);
    self.hud.isUsed = YES;
    self.hud.userInteractionEnabled = NO;
    [KeyWindow addSubview:self.hud];
    [self.hud showAnimated:YES];
}

- (void)downloadVideo:(NSString *)videoURL
              success:(successBlock)success
             progress:(progressBlock)progress
               failed:(failedBlock)failed {
    /**下载视频*/
    
    if (self.isWorking) {
        [MBProgressHUD showSuccess:@"还有未完成的下载视频"];
        return;
    }
    
    /**检查视频缓存*/
    if ([XLFileHandler cacheFileExistsWithURL:[NSURL URLWithString:videoURL]]) {
        /**视频已经缓存,拿到地址*/
        NSString *path = [XLFileHandler cacheFileExistsWithURL:[NSURL URLWithString:videoURL]];
        /**根据地址进行视频的保存*/
        if (success) {
            success(path);
        }
        
    } else {
        /**视频没有缓存*/
        [MBProgressHUD showSuccess:@"开始下载视频"];
        self.isWorking = YES;
        [[NSUserDefaults standardUserDefaults] setObject:videoURL forKey:XLUnDownloadVideo];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSURL *url = [NSURL URLWithString:videoURL];
        __block NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",[MD5Encrypt MD5ForLower16Bate:videoURL]]];;
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        @weakify(self);
        NSURLSessionDownloadTask *task =
        [manager downloadTaskWithRequest:request
                                progress:^(NSProgress * _Nonnull downloadProgress) {
                                    if (progress) progress(downloadProgress);
                                    @strongify(self);
                                    if (!self.hud) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [self configHUD];
                                        });
                                    }
                                    
                                    int present = downloadProgress.fractionCompleted*100;
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        if (present < 100) {
                                            self.hud.detailsLabel.text = [NSString stringWithFormat:@"正在下载视频 %d%%",present];
                                        } else {
                                            [self.hud removeFromSuperview];
                                        }
                                    });
                                }
                             destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                  return [NSURL fileURLWithPath:path];
                                }
                       completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               MBProgressHUD *hud = [MBProgressHUD HUDForView:KeyWindow];
                               [hud removeFromSuperview];
                           });
                           if (error) {
                               if (failed) failed(error);
                           } else {
                               if (success) success(path);
                           }
                           self.isWorking = NO;
                           self.hud = nil;
                           [[NSUserDefaults standardUserDefaults] setObject:nil forKey:XLUnDownloadVideo];
                       }];

        [task resume];
    }
    
}

- (void)requestTaskDidReceiveData {
    
}

@end
