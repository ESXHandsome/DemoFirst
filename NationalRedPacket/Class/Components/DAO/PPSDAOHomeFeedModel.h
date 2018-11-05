//
//  PPSDAOHomeFeedModel.h
//  NationalRedPacket
//
//  Created by 张子琦 on 27/01/2018.
//  Copyright © 2018 孙明悦. All rights reserved.
//

#import "PPSDAOBaseModel.h"

@interface PPSDAOHomeFeedModel : PPSDAOBaseModel
/// feed ID
@property (strong, nonatomic) NSString *feedId;
/// 模版类型
@property (assign, nonatomic) NSInteger templateType;
/// 是否被点赞
@property (assign, nonatomic) BOOL isLiked;
/// 是否被阅读
@property (assign, nonatomic) BOOL isRead;
/// 评论数
@property (assign, nonatomic) NSInteger commentCount;
/// 喜欢数
@property (assign, nonatomic) NSInteger likedCount;
/// 转发数
@property (assign, nonatomic) NSInteger forwardCount;
/// 服务端传递的原始 JSON
@property (strong, nonatomic) NSString *JSON;
/// 发布者 ID
@property (strong, nonatomic) NSString *publisherId;
/// 发布时间戳
@property (assign, nonatomic) NSInteger publishTimestamp;
/// 拉取时间戳
@property (assign, nonatomic) NSInteger createdTimestamp;

/// 是否要更新喜欢状态，外部不要调用
@property (assign, nonatomic, readonly) BOOL shouldUpdateLikedStatus;
/// 是否要更新阅读状态，外部不要调用
@property (assign, nonatomic, readonly) BOOL shouldUpdateReadStatus;

@end
