//
//  FeedDetailViewModel.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/5/7.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLFeedDataSource.h"

@protocol FeedDetailViewModelDelegate<NSObject>

- (void)feedModelDidUpdate:(XLFeedModel *)feed;

@end

@interface FeedDetailViewModel : NSObject

@property (strong, nonatomic) XLFeedDataSource *dataSource;

@property (strong, nonatomic) XLFeedModel *feed;

@property (weak, nonatomic)   id<FeedDetailViewModelDelegate>delegate;

@property (assign, nonatomic) BOOL isStatingContent;
@property (assign, nonatomic) BOOL isStatingComment;
@property (assign, nonatomic) BOOL isShowCommentRefreshAnination;
@property (assign, nonatomic, getter=isAppointCommentScroll) BOOL appointCommentScroll;
@property (copy, nonatomic) NSString *appointCommentId;
@property (copy, nonatomic) NSString *appointSecondCommentId;

- (instancetype)initWithFeed:(XLFeedModel *)feed;

- (void)statBeginPage;

- (void)statEndPage;

/**
 内容开始打点
 */
- (void)statBeginContent;

/**
 内容结束打点
 */
- (void)statEndContent;

- (void)resetArrayAndKey;

- (NSString *)statEndVideoContentDuration;

/**
 评论开始打点
 */
- (void)statBeginComment;

/**
 评论结束打点
 */
- (void)statEndComment;

/**
 视频悬浮窗开始打点
 */
- (void)statBeginVideoFloat;

/**
 视频悬浮窗结束打点
 */
- (void)statEndVideoFloat;

/**
 点赞上传
 
 @param repeat 是否重复
 */
- (void)repeatUpload:(BOOL)repeat;

/**
 踩上传
 
 @param repeat 是否重复
 */
- (void)treadRepeatUpload:(BOOL)repeat;

- (NSInteger)removeFeedModel:(XLFeedModel *)model;

@end
