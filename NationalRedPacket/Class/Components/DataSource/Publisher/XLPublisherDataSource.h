//
//  XLPublisherDataSource.h
//  NationalRedPacket
//
//  Created by fensi on 2018/4/13.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLDataSource.h"
#import "XLPublisherModel.h"

@interface XLPublisherDataSource : XLDataSource<__kindof XLPublisherModel *>

/**
 关注的人的 ID 集合

 @return 字符串 ID 数组
 */
+ (NSArray<NSString *> *)followingAuthorIds;

/**
 添加关注的人

 @param authorId ID
 */
+ (void)addFollowingAuthorId:(NSString *)authorId;

/**
 删除关注的人

 @param authorId ID
 */
+ (void)removeFollowingAuthorId:(NSString *)authorId;

/**
 设置关注的人的 ID 集合

 @param authorIds 字符串 ID 数组
 */
+ (void)setFollowingAuthorIds:(NSArray<NSString *> *)authorIds;

/**
 重置集合中每条数据的关注状态
 需包含 authorId 和 isFollowed 属性

 @param array 集合
 */
+ (void)resetIsFollowedFromArray:(NSArray *)array;

@end
