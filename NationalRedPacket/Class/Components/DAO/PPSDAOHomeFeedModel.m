//
//  PPSDAOHomeFeedModel.m
//  NationalRedPacket
//
//  Created by 张子琦 on 27/01/2018.
//  Copyright © 2018 孙明悦. All rights reserved.
//

#import "PPSDAOHomeFeedModel.h"

@interface PPSDAOHomeFeedModel ()

@property (assign, nonatomic, readwrite) BOOL shouldUpdateLikedStatus;
@property (assign, nonatomic, readwrite) BOOL shouldUpdateReadStatus;

@end

@implementation PPSDAOHomeFeedModel

- (instancetype)init {
    if (self = [super init]) {
        self.feedId = nil;
        self.templateType = -1;
        self.commentCount = -1;
        self.likedCount = -1;
        self.forwardCount = -1;
        self.JSON = nil;
        self.publisherId = nil;
        self.publishTimestamp = -1;
        self.createdTimestamp = -1;
        self.shouldUpdateLikedStatus = NO;
        self.shouldUpdateReadStatus = NO;
    }
    return self;
}

- (void)setIsLiked:(BOOL)isLiked {
    _isLiked = isLiked;
    self.shouldUpdateLikedStatus = YES;
}

- (void)setIsRead:(BOOL)isRead {
    _isRead = isRead;
    self.shouldUpdateReadStatus = YES;
}

@end
