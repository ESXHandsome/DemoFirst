//
//  XLShareAlertViewModel.h
//  NationalRedPacket
//
//  Created by Ying on 2018/7/2.
//  Copyright © 2018 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLShareImageModel.h"
#import "XLShareURLModel.h"
#import "XLShareFeedModel.h"
#import "XLShareBackListModel.h"
#import "XLShareCollectionModel.h"
#import "XLSaveVideoModel.h"
#import "XLDeleteFeedModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol XLShareAlertViewModelDelegate <NSObject>

/**
 需要展示HUD

 @param type 1为成功 0为失败
 */
- (void)showHUD:(BOOL)type;

/**
 需要弹出反馈视图
 */
- (void)presentReportView;

- (void)deleteFeedItem;

@end

@interface XLShareAlertViewModel : NSObject

@property (weak, nonatomic) id<XLShareAlertViewModelDelegate> delegate;

@property (strong, nonatomic) XLShareImageModel *shareImageModel; /// 图片分享
@property (strong, nonatomic) XLShareURLModel   *shareURLModel;   /// 链接分享
@property (strong, nonatomic) XLShareFeedModel *shareFeedModel;   /// 视频分享
@property (strong, nonatomic) XLShareBackListModel *shareBackListModel; /// 拉黑
@property (strong, nonatomic) XLShareCollectionModel *shareCollectionModel; /// 收藏
@property (strong, nonatomic) XLSaveVideoModel *saveVideoModel;   /// 下载视频
@property (strong, nonatomic) XLDeleteFeedModel *deleteFeedModel; /// 删除信息流

@property (assign, nonatomic) BOOL shareType; /**1 分享图片 ; 2 分享链接*/

- (void)chooseToOpen:(NSString *)sign;

@end

NS_ASSUME_NONNULL_END
