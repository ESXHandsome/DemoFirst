//
//  PPSDAOPublisherModel.m
//  NationalRedPacket
//
//  Created by 张子琦 on 27/01/2018.
//  Copyright © 2018 孙明悦. All rights reserved.
//

#import "PPSDAOPublisherModel.h"

@interface PPSDAOPublisherModel ()
@property (assign, nonatomic, readwrite) BOOL shouldUpdateFollowingStatus;
@end


@implementation PPSDAOPublisherModel

- (instancetype)init {
    if (self = [super init]) {
        self.publisherId = nil;
        self.nickname = nil;
        self.gender = UNKNOWN;
        self.age = -1;
        self.location = nil;
        self.bio = nil;
        self.constellation = nil;
        self.followerCount = -1;
        self.followingCount = -1;
    }
    return self;
}

- (void)setIsFollowing:(BOOL)isFollowing {
    _isFollowing = isFollowing;
    self.shouldUpdateFollowingStatus = YES;
}

@end
