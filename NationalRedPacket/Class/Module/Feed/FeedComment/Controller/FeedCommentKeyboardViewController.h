//
//  FeedCommentKeyboardViewController.h
//  NationalRedPacket
//
//  Created by fensi on 2018/4/24.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLFeedCommentModel.h"

@class FeedCommentKeyboardViewController;

typedef void(^FeedCommentKeyboardCompletion)(NSString *content, UIImage *picture, NSURL *pictureFileURL, BOOL isForward, void(^sendFinish)(BOOL isSuccess));

@interface FeedCommentKeyboardViewController : UIViewController

/**
 获取从 xib 生成的控制器实例

 @return 类型实例
 */
+ (instancetype)xibViewController;

/// 完成后的回调
@property (copy, nonatomic) FeedCommentKeyboardCompletion completion;

/// 被回复的发布者名字
@property (copy, nonatomic) NSString *toAuthorName;

/// 是否直接弹出相册选择
@property (assign, nonatomic, getter=isShortcutShowPhotos) BOOL shortcutShowPhotos;

@end
