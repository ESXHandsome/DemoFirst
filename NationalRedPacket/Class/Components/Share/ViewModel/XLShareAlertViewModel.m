//
//  XLShareAlertViewModel.m
//  NationalRedPacket
//
//  Created by Ying on 2018/7/2.
//  Copyright © 2018 XLook. All rights reserved.
//

#import "XLShareAlertViewModel.h"
#import "WechatShare.h"
#import "TencentQQApi.h"
#import "UserApi.h"
#import "ShareImageTool.h"
#import "NewsApi.h"
#import "XLDataSourceManager.h"
#import "XLSaveVideo.h"
#import "XLPublishApi.h"
#import "XLDownloadVideo.h"

@interface XLShareAlertViewModel ()

@property (copy, nonatomic) NSString *shareHUDString;
@property (copy, nonatomic) NSString *successHUDString;
@property (copy, nonatomic) NSString *failedHUDString;

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImage *thumbImage;

@end

@implementation XLShareAlertViewModel


- (void)chooseToOpen:(NSString *)sign {
    
    if (!XLUserManager.shared.isOnceShared) {
        XLUserManager.shared.isOnceShared = YES;
    }
    
    if ([sign isEqualToString:@"微信"]) {
        if (self.shareURLModel) {
            [self shareURLToWeChat];
        } else if (self.shareImageModel) {
            [self shareImageToWechat];
        } else if (self.shareFeedModel) {
            [self shareFeedToWechat];
        } else {
            
        }
    } else if ([sign isEqualToString:@"朋友圈"]) {
        if (self.shareURLModel) {
            [self shareURLToTimeline];
        } else if (self.shareImageModel) {
            [self shareImageToTimeline];
        } else if (self.shareFeedModel) {
            [self shareFeedToTimeline];
        } else {
            
        }
    } else if ([sign isEqualToString:@"QQ"]) {
        if (self.shareURLModel) {
            [self shareURLToQQ];
        } else if (self.shareImageModel) {
            [self shareImageToQQ];
        } else if (self.shareFeedModel) {
            [self shareFeedToQQ];
        } else {
            
        }
    } else if ([sign isEqualToString:@"QQ空间"]) {
        if (self.shareURLModel) {
            [self shareURLToZone];
        } else if (self.shareImageModel) {
            [self shareImageToZone];
        } else if (self.shareFeedModel) {
            [self shareFeedToZone];
        } else {
            
        }
    } else if ([sign isEqualToString:@"举报"]) {
        [self presentReportView];
    } else if ([sign isEqualToString:@"拉黑"]) {
        [self uploadBacklist];
    } else if ([sign isEqualToString:@"收藏"]) {
        [self uploadCollection];
    } else if ([sign isEqualToString:@"删除"]) {
        [self deleteFeed];
    } else if ([sign isEqualToString:@"下载视频"]) {
        [self downloadVideo];
    } else {
        
    }

}

- (BOOL)canOpenWechat {
    NSString *wechatUrlString = @"weixin://";
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:wechatUrlString]];
}

- (BOOL)canOpenQQ {
    NSString *QQUrlString = @"mqq://";
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:QQUrlString]];
}

#pragma mark -
#pragma mark - back list
- (void)uploadBacklist {
    if (!self.shareBackListModel) return;
    [XLUserManager.shared blacklistUser:self.shareBackListModel.authorID];
    [MBProgressHUD showSuccess:@"操作成功"];
}

#pragma mark -
#pragma mark - negative

- (void)presentReportView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(presentReportView)]) {
        [self.delegate presentReportView];
    }
}

#pragma mark -
#pragma mark - Share URL Method

- (void)shareURLToWeChat {
    if (!self.shareURLModel) return;
    [[WechatShare sharedInstance] shareUrl:self.shareURLModel.title 
                                   content:self.shareURLModel.content
                                       url:[self chooseFeedShare:self.shareURLModel.url endString:WX_SESSION]
                                     image:self.shareURLModel.image
                                        to:WechatSceneSession
                           sendReqCallback:^(int code) {
                               if (code == 0) {
                                   [MBProgressHUD showSuccess:self.successHUDString];
                               } else {
                                   [MBProgressHUD showError:self.failedHUDString time:2.5];
                               }
                           }];
}

- (void)shareURLToTimeline {
    if (!self.shareURLModel) return;
    [[WechatShare sharedInstance] shareUrl:self.shareURLModel.title
                                   content:self.shareURLModel.content
                                       url:[self chooseFeedShare:self.shareURLModel.url endString:WX_MOMENT]
                                     image:self.shareURLModel.image
                                        to:WechatSceneTimeline
                           sendReqCallback:^(int code) {
                               if (code == 0) {
                                   [MBProgressHUD showSuccess:self.successHUDString];
                               } else {
                                   [MBProgressHUD showError:self.failedHUDString time:2.5];
                               }
                           }];
}

- (void)shareURLToQQ {
    if (!self.shareURLModel) return;
    [[TencentQQApi sharedInstance] shareNewsArticle:[self chooseFeedShare:self.shareURLModel.url endString:QQ_SESSION]
                                              title:self.shareURLModel.title
                                        description:self.shareURLModel.content
                                              thumb:self.shareURLModel.image
                                                 to:QQSceneSession
                                           callback:^(int code, NSString * _Nullable description) {
                                               if (code == 0) {
                                                   [MBProgressHUD showError:self.successHUDString time:2.5];
                                               } else {
                                                   [MBProgressHUD showError:self.failedHUDString time:2.5];
                                               }
                                           }];
}

- (void)shareURLToZone {
    if (!self.shareURLModel) return;
    [[TencentQQApi sharedInstance] shareNewsArticle:[self chooseFeedShare:self.shareURLModel.url endString:QQ_ZONE]
                                              title:self.shareURLModel.title
                                        description:self.shareURLModel.content
                                              thumb:self.shareURLModel.image
                                                 to:QQSceneQzone
                                           callback:^(int code, NSString * _Nullable description) {
                                               if (code == 0) {
                                                   [MBProgressHUD showError:self.successHUDString time:2.5];
                                               } else {
                                                   [MBProgressHUD showError:self.failedHUDString time:2.5];
                                               }
                                           }];
}

- (NSString *)chooseFeedShare:(NSString *)string endString:(NSString *)endString {
    if ([string hasSuffix:@"*FEED*"]) {
        string = [string stringByReplacingOccurrencesOfString:@"*FEED*"withString:endString];
        return string;
    } else {
        return string;
    }
}

#pragma mark -
#pragma mark - Share Image Method

/**下载需要分享的图片*/
- (void)prepareSharedImage:(void(^)(void))success {
    if (!self.shareImageModel) return;
    @weakify(self)
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:self.shareImageModel.image] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        /**下载图片完成*/
        @strongify(self);
        image = [ShareImageTool createShareImageWithUrl:self.shareImageModel.url image:image];
        UIImage *thumbImage = [UIImage imageWithImage:image scaledToSize:CGSizeMake(image.size.width / 5.0, image.size.height / 5.0)];
        
        self.image = image;
        self.thumbImage = thumbImage;
        
        /**进行完一系列配置工作,现在准备开始分享*/
        success();
    }];
}

- (void)shareImageToWechat {
    if (!self.shareImageModel) return;
    [[WechatShare sharedInstance] shareImage:self.image
                                  thumbImage:self.thumbImage
                                          to:WechatSceneSession
                             sendReqCallback:^(int code) {
                                 if (code == 0) {
                                     [MBProgressHUD showSuccess:self.successHUDString];
                                 } else {
                                     [MBProgressHUD showError:self.failedHUDString time:2.5];
                                 }
                             }];
}

- (void)shareImageToTimeline {
    if (!self.shareImageModel) return;
    [[WechatShare sharedInstance] shareImage:self.image
                                  thumbImage:self.thumbImage
                                          to:WechatSceneTimeline
                             sendReqCallback:^(int code) {
                                 if (code == 0) {
                                     [MBProgressHUD showSuccess:self.successHUDString ];
                                 } else {
                                     [MBProgressHUD showError:self.failedHUDString time:2.5];
                                 }
                             }];
}

- (void)shareImageToQQ {
    if (!self.shareImageModel) return;
    [[TencentQQApi sharedInstance] shareImage:self.image
                                        title:@""
                                  description:@""
                                           to:QQSceneSession
                                     callback:^(int code, NSString * _Nullable description) {
                                         if (code == 0) {
                                             [MBProgressHUD showError:self.successHUDString time:2.5];
                                         } else {
                                             [MBProgressHUD showError:self.failedHUDString time:2.5];
                                         }
                                     }];
}

- (void)shareImageToZone {
    if (!self.shareImageModel) return;
    [[TencentQQApi sharedInstance] shareImage:self.image
                                        title:@""
                                  description:@""
                                           to:QQSceneQzone
                                     callback:^(int code, NSString * _Nullable description) {
                                         if (code == 0) {
                                             [MBProgressHUD showError:self.successHUDString time:2.5];
                                         } else {
                                             [MBProgressHUD showError:self.failedHUDString time:2.5];
                                         }
                                     }];
}

- (void)shareFeedToWechat {
    if (!self.shareFeedModel) return;
    [self statSharePlatform:WECHAT_SESSION_CHANNEL];
    [[WechatShare sharedInstance] shareFeed:self.shareFeedModel.title
                                    content:self.shareFeedModel.content
                                    feedUrl:[self chooseFeedShare:self.shareFeedModel.feedUrl endString:WX_SESSION]
                                   imageUrl:self.shareFeedModel.imageUrl
                                   feedType:self.shareFeedModel.feedType
                                         to:WechatSceneSession
                                sendReqCallback:^(int code) {
                                             if (code == 0) {
                                                 [self statShareSuccessPlatform:WECHAT_SESSION_CHANNEL];
                                                 [MBProgressHUD showError:self.successHUDString time:2.5];
                                             } else {
                                                 [MBProgressHUD showError:self.failedHUDString time:2.5];
                                             }
                                         }];
    
}

- (void)shareFeedToTimeline {
    if (!self.shareFeedModel) return;
    [self statSharePlatform:WECHAT_MOMENTS_CHANNEL];
    [[WechatShare sharedInstance] shareFeed:self.shareFeedModel.title
                                    content:self.shareFeedModel.content
                                    feedUrl:[self chooseFeedShare:self.shareFeedModel.feedUrl endString:WX_MOMENT]
                                   imageUrl:self.shareFeedModel.imageUrl
                                   feedType:self.shareFeedModel.feedType
                                         to:WechatSceneTimeline
                            sendReqCallback:^(int code) {
                                 if (code == 0) {
                                     [self statShareSuccessPlatform:WECHAT_MOMENTS_CHANNEL];
                                     [MBProgressHUD showError:self.successHUDString time:2.5];
                                 } else {
                                     [MBProgressHUD showError:self.failedHUDString time:2.5];
                                 }
                             }];
}

- (void)shareFeedToQQ {
    if (!self.shareFeedModel) return;
    [self statSharePlatform:QQ_SESSION_CHANNEL];
    [[TencentQQApi sharedInstance] shareFeed:self.shareFeedModel.title
                                      content:self.shareFeedModel.content
                                          url:[self chooseFeedShare:self.shareFeedModel.feedUrl endString:QQ_SESSION]
                                        image:self.shareFeedModel.imageUrl
                                           to:QQSceneSession
                                     callback:^(int code, NSString * _Nullable description) {
                                         if (code == 0) {
                                             [self statShareSuccessPlatform:QQ_SESSION_CHANNEL];
                                             [MBProgressHUD showError:self.successHUDString time:2.5];
                                         } else {
                                             [MBProgressHUD showError:self.failedHUDString time:2.5];
                                         }
    }];
}

- (void)shareFeedToZone {
    if (!self.shareFeedModel) return;
    [self statSharePlatform:QQ_ZONE_CHANNEL];
    [[TencentQQApi sharedInstance] shareFeed:self.shareFeedModel.title
                                      content:self.shareFeedModel.content
                                          url:[self chooseFeedShare:self.shareFeedModel.feedUrl endString:QQ_ZONE]
                                        image:self.shareFeedModel.imageUrl
                                           to:QQSceneQzone
                                     callback:^(int code, NSString * _Nullable description) {
                                         if (code == 0) {
                                             [self statShareSuccessPlatform:QQ_ZONE_CHANNEL];
                                             [MBProgressHUD showError:self.successHUDString time:2.5];
                                         } else {
                                             [MBProgressHUD showError:self.failedHUDString time:2.5];
                                         }
                                     }];
}

#pragma mark -
#pragma mark - Delete feed

- (void)deleteFeed {
    NSDictionary *info = @{@"index" : [NSNumber numberWithInteger:self.deleteFeedModel.index] ,
                           @"itemId": self.deleteFeedModel.itemId,
                           @"type"  : [NSNumber numberWithInteger:self.deleteFeedModel.type]
                           };
    @weakify(self);
    [XLPublishApi deletePersionItem:info success:^(id responseDict) {
        [MBProgressHUD showSuccess:@"删除成功"];
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(deleteFeedItem)]) {
            [self.delegate deleteFeedItem];
        }
    } failure:^(NSInteger errorCode) {
        [MBProgressHUD showError:@"删除失败"];
    }];
}

#pragma mark -
#pragma mark - Save video

- (void)downloadVideo {

    XLDownloadVideo *download = [XLDownloadVideo sharedInstance];
    [download downloadVideo:self.saveVideoModel.videoURLString success:^(id  _Nonnull path) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [XLSaveVideo writeVideoToPhotoLibrary:[NSURL URLWithString:path]];
        });
    } progress:^(NSProgress *  _Nonnull progress) {

        
    } failed:^(id  _Nonnull error) {
        [MBProgressHUD showError:@"下载失败"];
    }];
    
    [StatServiceApi statEvent:VIDEO_DOWNLOAD_CLICK model:self.saveVideoModel.originModel];
}

#pragma mark -
#pragma mark - collection

- (void)uploadCollection {
    if (!self.shareCollectionModel) return;
    if ([NetworkManager.shared.netWorkTypeString isEqualToString:XLAlertNetworkNotReachable]) {
        [MBProgressHUD showError:XLAlertNetworkNotReachable];
        return;
    }
    
    if (!XLLoginManager.shared.isAccountLogined) {
        [UIViewController.currentViewController dismissViewControllerAnimated:YES completion:^{
            [LoginViewController showLoginVCFromSource:self.shareFeedModel.feedType.integerValue == XLFeedCellMultiPictureType ? LoginSourceTypeImageCollection : LoginSourceTypeVideoCollection];
        }];
        return;
    }
    if (!self.shareCollectionModel.isCollection) {
        NSString *event;
        if (self.shareCollectionModel.type.integerValue == XLFeedCellMultiPictureType) {
            event = IMAGE_COLLECTION_CLICK;
        } else {
            event = VIDEO_COLLECTION_CLICK;
        }
        [StatServiceApi statEvent:event model:self.shareCollectionModel.originModel];
    }
    
    [NewsApi collectionWithItemId:self.shareCollectionModel.itemID
                             type:self.shareCollectionModel.type
                           action:!self.shareCollectionModel.isCollection ? @"yes" : @"no"
                          success:^(id responseDict) {
                              [MBProgressHUD showSuccess:!self.shareCollectionModel.isCollection ? @"收藏成功" : @"取消收藏"];
                          } failure:^(NSInteger errorCode) {
                              [MBProgressHUD showError:!self.shareCollectionModel.isCollection ? @"收藏失败" : @"取消失败"];
                          }];
}

#pragma mark - FeedShareStat

- (void)statSharePlatform:(NSString *)platform {
    
    NSString *event = self.shareFeedModel.feedType.integerValue == XLFeedCellMultiPictureType ? IMAGE_FORWARD_TYPE : VIDEO_FORWARD_TYPE;
    [StatServiceApi statEvent:event model:self.shareFeedModel.originModel otherString:[NSString stringWithFormat:@"%@,%@", platform, self.shareFeedModel.position]];
    
}

- (void)statShareSuccessPlatform:(NSString *)platform {
    
    NSString *event = self.shareFeedModel.feedType.integerValue == XLFeedCellMultiPictureType ? IMAGE_FORWARDED : VIDEO_FORWARDED;
    [StatServiceApi statEvent:event model:self.shareFeedModel.originModel otherString:[NSString stringWithFormat:@"%@,%@", platform, self.shareFeedModel.position]];
    ///转发数自增
    [XLDataSourceManager.shared increaseFeedForwardNumForItemId:self.shareFeedModel.originModel.itemId];
    ///上传分享成功操作
    [NewsApi feedForwardWithItemId:self.shareFeedModel.originModel.itemId source:platform type:self.shareFeedModel.originModel.type success:nil failure:nil];
    
}

#pragma mark -
#pragma mark - Getter

- (NSString *)successHUDString {
    if (!_successHUDString) {
        if (self.shareHUDString) {
            _successHUDString = [self.shareHUDString stringByAppendingString:@"成功"];
        } else {
            _successHUDString = @"分享成功";
        }
    }
    return _successHUDString;
}

- (NSString *)failedHUDString {
    if (!_failedHUDString) {
        if (self.shareHUDString) {
            _failedHUDString = [self.shareHUDString stringByAppendingString:@"失败"];
        } else {
            _failedHUDString = @"分享失败";
        }
    }
    return _failedHUDString;
}

@end
