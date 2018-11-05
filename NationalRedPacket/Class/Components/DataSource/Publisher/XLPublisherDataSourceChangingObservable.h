//
//  XLPublisherDataSourceChangingObservable.h
//  NationalRedPacket
//
//  Created by fensi on 2018/4/13.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLDataSourceChangingObservable.h"

@protocol XLPublisherDataSourceChangingObservable <XLDataSourceChangingObservable>

/**
 更改一条 Publisher 的关注状态
 
 @param authorId ID
 @param isFollowed 是否已关注
 */
- (void)changePublisherFollowForAuthorId:(NSString *)authorId isFollowed:(BOOL)isFollowed;

@end
