//
//  PPSDAOPublisherModel.h
//  NationalRedPacket
//
//  Created by 张子琦 on 27/01/2018.
//  Copyright © 2018 孙明悦. All rights reserved.
//

#import "PPSDAOBaseModel.h"

typedef enum : NSUInteger {
    UNKNOWN = 0,
    MALE,
    FEMALE,
} Gender;

@interface PPSDAOPublisherModel : PPSDAOBaseModel
/// 发布者 ID
@property (strong, nonatomic) NSString *publisherId;
/// 昵称
@property (strong, nonatomic) NSString *nickname;
/// 性别
@property (assign, nonatomic) Gender gender;
/// 年龄
@property (assign, nonatomic) NSInteger age;
/// 位置
@property (strong, nonatomic) NSString *location;
/// 简介
@property (strong, nonatomic) NSString *bio;
/// 星座
@property (strong, nonatomic) NSString *constellation;
/// 粉丝数
@property (assign, nonatomic) NSInteger followerCount;
/// 关注数
@property (assign, nonatomic) NSInteger followingCount;
/// 是否被“我”关注
@property (assign, nonatomic) BOOL isFollowing;
/// 是否要更新关注状态，外部不要调用
@property (assign, nonatomic, readonly) BOOL shouldUpdateFollowingStatus;
@end
