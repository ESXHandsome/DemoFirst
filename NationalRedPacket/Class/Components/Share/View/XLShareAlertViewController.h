//
//  XLShareAlertView.h
//  NationalRedPacket
//
//  Created by Ying on 2018/7/2.
//  Copyright © 2018 XLook. All rights reserved.
//
typedef NS_ENUM(NSUInteger, sharingType) {
    sharingWithImage,
    sharingWithURL,
    sharimgWithVideo,
};

#import <UIKit/UIKit.h>
#import "XLShareImageModel.h"
#import "XLShareURLModel.h"
#import "XLShareFeedModel.h"
#import "XLShareCollectionModel.h"
#import "XLShareReportModel.h"
#import "XLShareBackListModel.h"
#import "XLDeleteFeedModel.h"
#import "XLSaveVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol XLShareAlertControllerShareDelegate <NSObject>

@optional

- (XLSaveVideoModel *)configSaveVideo;

/**
 收藏

 @return 信息流模型
 */
- (XLShareCollectionModel *)configUploadCollection;

/**
 举报

 @return 举报数据模型
 */
- (XLShareReportModel *)configUploadReport;

/**
 拉黑

 @return 拉黑数据模型
 */
- (XLShareBackListModel *)configUpLoadBackList;


/**
 分享内容
 
 @return 分享图片的数据模型
 */
- (id <XLShareModelDelegate>)configShareModel;


- (XLDeleteFeedModel *)configDeleteModel;

- (void)deleteFeedCell;

@end

@interface XLShareAlertViewController : UIViewController

/**
 推出分享弹窗

 @param contentView 目标视图控制器 (一般你在 controller 中传 self 就行)
 */
- (void)presentSheetAlertViewController:(UIViewController *)contentView;

/// 分享 请遵循此代理
@property (weak, nonatomic) id<XLShareAlertControllerShareDelegate> shareDelegate;

/**
 只有分享按钮
 */
- (void)onlyShare;

/**
 只有工具按钮
 */
- (void)onlyTool;

/**
 重置工具按钮

 @param titleArray 按钮名称数组
 @param iconArray 按钮icon按钮
 */
- (void)resetTool:(NSArray *)titleArray icon:(NSArray *)iconArray;


/**
 添加工具按钮去

 @param title 按钮名称
 @param icon  按钮icon
 */
- (void)addObjectToTool:(NSString *)title icon:(NSString *)icon;

@end

NS_ASSUME_NONNULL_END
