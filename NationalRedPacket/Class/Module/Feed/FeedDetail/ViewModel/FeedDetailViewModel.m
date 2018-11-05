//
//  FeedDetailViewModel.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/5/7.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "FeedDetailViewModel.h"
#import "NewsApi.h"
#import "WechatShare.h"
#import "TencentQQApi.h"
#import "XLFeedDataSource.h"

@interface FeedDetailViewModel ()<XLDataSourceDelegate>



@property (assign, nonatomic) BOOL               shouldUploadPraise;
@property (assign, nonatomic) BOOL               shouldUploadTread;

/** 统计相关 */
@property (strong, nonatomic) NSMutableArray     *contentDurationArray;
@property (strong, nonatomic) NSMutableArray     *commentDurationArray;
@property (strong, nonatomic) NSMutableArray     *videoFloatDurationArray;
@property (copy, nonatomic)   NSString           *contentKey;
@property (copy, nonatomic)   NSString           *commentKey;
@property (copy, nonatomic)   NSString           *videoFloatKey;

@end

@implementation FeedDetailViewModel

@synthesize feed = _feed;

- (instancetype)initWithFeed:(XLFeedModel *)feed
{
    self = [super init];
    if (self) {
        self.feed = feed;
        self.feed.bestComment = nil; //详情页移除神评数据
        _shouldUploadPraise = YES;
        _shouldUploadTread = YES;
    }
    return self;
}

#pragma mark - 数据同步

- (XLFeedModel *)feed {
    return self.dataSource.elements.firstObject;
}

- (void)setFeed:(XLFeedModel *)feed {
    if (self.dataSource == nil) {
        self.dataSource = [[XLFeedDataSource alloc] init];
        self.dataSource.delegate = self;
    }
    [self.dataSource setElementsFromArray:@[feed]];
}

- (void)dataSource:(XLDataSource *)dataSource didChangedForIndex:(NSInteger)index {

    XLFeedModel *model = self.dataSource.elements[index];

    if (self.delegate && [self.delegate respondsToSelector:@selector(feedModelDidUpdate:)]) {
        [self.delegate feedModelDidUpdate:model];
    }
}

#pragma mark - 统计

- (void)statBeginPage {
    
    [self resetArrayAndKey];
    
    if (self.feed.type.integerValue == XLFeedCellMultiPictureType) {
        [StatServiceApi statEventBegin:IMAGE_DETAIL_DURATION model:self.feed];
    } else {
        [StatServiceApi statEventBegin:VIDEO_DETAIL_DURATION model:self.feed];
    }
}

- (void)statEndPage {
    
    [self statEndContent];
    [self statEndComment];
    [self statEndVideoFloat];
    
    if (self.feed.type.integerValue == XLFeedCellMultiPictureType) {
        [StatServiceApi statEvent:IMAGE_READ_DURATION model:self.feed timeDuration:[self calculateDurationWithArray:self.contentDurationArray]];
        [StatServiceApi statEvent:IMAGE_COMMENT_DURATION model:self.feed timeDuration:[self calculateDurationWithArray:self.commentDurationArray]];
        [StatServiceApi statEventEnd:IMAGE_DETAIL_DURATION model:self.feed];
    } else {
        [StatServiceApi statEvent:VIDEO_DURATION model:self.feed timeDuration:[self calculateDurationWithArray:self.contentDurationArray]];
        [StatServiceApi statEvent:VIDEO_COMMENT_DURATION model:self.feed timeDuration:[self calculateDurationWithArray:self.commentDurationArray]];
        [StatServiceApi statEvent:VIDEO_FLOAT_PLAY_DURATION model:self.feed timeDuration:[self calculateDurationWithArray:self.videoFloatDurationArray]];
        [StatServiceApi statEventEnd:VIDEO_DETAIL_DURATION model:self.feed];
    }
    [self resetArrayAndKey];
}

- (void)resetArrayAndKey {
    
    self.commentDurationArray = [NSMutableArray array];
    self.contentDurationArray = [NSMutableArray array];
    self.videoFloatDurationArray = [NSMutableArray array];
    
    [NSUserDefaults.standardUserDefaults removeObjectForKey:self.commentKey];
    [NSUserDefaults.standardUserDefaults removeObjectForKey:self.contentKey];
    [NSUserDefaults.standardUserDefaults removeObjectForKey:self.videoFloatKey];
    
    self.isStatingContent = NO;
    self.isStatingComment = NO;
    
}

- (NSString *)statEndVideoContentDuration {
    
    return [self calculateDurationWithArray:self.contentDurationArray];
}

- (NSString *)calculateDurationWithArray:(NSMutableArray *)array {
    __block NSInteger result = 0;
    [array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        result += [obj longLongValue];
    }];
    return [NSString stringWithFormat:@"%ld", result];
}

/**
 内容开始打点
 */
- (void)statBeginContent {
    self.isStatingContent = YES;
    [NSUserDefaults.standardUserDefaults setObject:[NSString stringWithFormat:@"%ld", time(0)] forKey:self.contentKey];
}

/**
 内容结束打点
 */
- (void)statEndContent {
    self.isStatingContent = NO;
    NSUInteger begin = [[NSUserDefaults.standardUserDefaults objectForKey:self.contentKey] longLongValue];
    if (begin == 0) {
        XLLog(@"无效打点，无开始值，临界处理");
        return;
    }
    NSUInteger duration = time(0) - begin;
    NSString *endTime = [NSString stringWithFormat:@"%lu", (unsigned long)duration];
    [self.contentDurationArray addObject:endTime];
    [NSUserDefaults.standardUserDefaults removeObjectForKey:self.contentKey];
}

/**
 评论开始打点
 */
- (void)statBeginComment {
    self.isStatingComment = YES;
    [NSUserDefaults.standardUserDefaults setObject:[NSString stringWithFormat:@"%ld", time(0)] forKey:self.commentKey];
}

/**
 评论结束打点
 */
- (void)statEndComment {
    self.isStatingComment = NO;
    NSUInteger begin = [[NSUserDefaults.standardUserDefaults objectForKey:self.commentKey] longLongValue];
    if (begin == 0) {
        XLLog(@"无效打点，无开始值，临界处理");
        return;
    }
    NSUInteger duration = time(0) - begin;
    NSString *endTime = [NSString stringWithFormat:@"%lu", (unsigned long)duration];
    [self.commentDurationArray addObject:endTime];
    [NSUserDefaults.standardUserDefaults removeObjectForKey:self.commentKey];
}

/**
 视频悬浮窗开始打点
 */
- (void)statBeginVideoFloat {
    
    [NSUserDefaults.standardUserDefaults setObject:[NSString stringWithFormat:@"%ld", time(0)] forKey:self.videoFloatKey];
}

/**
 视频悬浮窗结束打点
 */
- (void)statEndVideoFloat {
    
    NSUInteger begin = [[NSUserDefaults.standardUserDefaults objectForKey:self.videoFloatKey] longLongValue];
    if (begin == 0) {
        XLLog(@"无效打点，无开始值，临界处理");
        return;
    }
    NSUInteger duration = time(0) - begin;
    NSString *endTime = [NSString stringWithFormat:@"%lu", (unsigned long)duration];
    [self.videoFloatDurationArray addObject:endTime];
    [NSUserDefaults.standardUserDefaults removeObjectForKey:self.videoFloatKey];
}

- (NSString *)contentKey {
    return [[@"content" stringByAppendingString:self.feed.itemId] stringByAppendingString:self.feed.type];
}

- (NSString *)commentKey {
    return [[@"comment" stringByAppendingString:self.feed.itemId] stringByAppendingString:self.feed.type];
}

- (NSString *)videoFloatKey {
    return [[@"videoFloat" stringByAppendingString:self.feed.itemId] stringByAppendingString:self.feed.type];
}

/**
 点赞上传

 @param repeat 是否重复
 */
- (void)repeatUpload:(BOOL)repeat {
    
    if (!_shouldUploadPraise) {
        return;
    }
    if (self.feed.isPraise) {
        //点赞
        if (self.feed.type.integerValue == XLFeedCellMultiPictureType) {
            [StatServiceApi statEvent:IMAGE_LIKE model:self.feed];
        } else {
            [StatServiceApi statEvent:VIDEO_LIKE model:self.feed];
        }
    }
    [NewsApi praiseWithItemId:self.feed.itemId
                         type:self.feed.type
                       action:self.feed.isPraise ? @"praise": @"noPraise"
                      success:^(id responseDict) {
                          
                      } failure:^(NSInteger errorCode) {
                          if (!repeat) {
                              return;
                          }
                          self.shouldUploadPraise = NO;
                          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                              self.shouldUploadPraise = YES;
                              [self repeatUpload:NO];
                          });
                      }];
}

/**
 踩上传
 
 @param repeat 是否重复
 */
- (void)treadRepeatUpload:(BOOL)repeat {
    
    if (!_shouldUploadTread) {
        return;
    }
    
    if (self.feed.isTread) {
        //点赞
        if (self.feed.type.integerValue == XLFeedCellMultiPictureType) {
            [StatServiceApi statEvent:IMAGE_TREAD model:self.feed];
        } else {
            [StatServiceApi statEvent:VIDEO_TREAD model:self.feed];
        }
    }
    
    [NewsApi treadWithItemId:self.feed.itemId
                        type:self.feed.type
                      action:self.feed.isTread ? @"tread": @"noTread"
                     success:^(id responseDict) {
                         
                      } failure:^(NSInteger errorCode) {
                          if (!repeat) {
                              return;
                          }
                          self.shouldUploadTread = NO;
                          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                              self.shouldUploadTread = YES;
                              [self treadRepeatUpload:NO];
                          });
                      }];
}

- (NSInteger)removeFeedModel:(XLFeedModel *)model {
    NSInteger index = [self.dataSource.elements indexOfObject:model];
    [self.dataSource removeElementAtIndex:index];
    return index;
}

@end
