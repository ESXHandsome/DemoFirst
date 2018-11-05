//
//  XLPublisherDataSource.m
//  NationalRedPacket
//
//  Created by fensi on 2018/4/13.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLPublisherDataSource.h"

static NSMutableArray<NSString *> *_followingAuthorIds;

@implementation XLPublisherDataSource

#pragma mark - Class Method

+ (NSArray<NSString *> *)followingAuthorIds {

    if (_followingAuthorIds == nil) {
        _followingAuthorIds = [NSMutableArray array];
    }
    
    return _followingAuthorIds;
}

+ (void)addFollowingAuthorId:(NSString *)authorId {
    
    [_followingAuthorIds addObject:authorId];
}

+ (void)removeFollowingAuthorId:(NSString *)authorId {

    [_followingAuthorIds removeObject:authorId];
}

+ (void)setFollowingAuthorIds:(NSArray<NSString *> *)authorIds {
    
    _followingAuthorIds = [NSMutableArray arrayWithArray:authorIds];
}

+ (void)resetIsFollowedFromArray:(NSArray *)array {
    
    for (id model in array) {
        
        NSString *authorId = [model authorId];
        
        [model setIsFollowed:[XLPublisherDataSource.followingAuthorIds containsObject:authorId]];
    }
}

#pragma mark - Override

- (void)addElementsFromArray:(NSArray *)otherArray {
    
    [XLPublisherDataSource resetIsFollowedFromArray:otherArray];
    
    [super addElementsFromArray:otherArray];
}

- (void)setElementsFromArray:(NSArray *)otherArray {
    
    [XLPublisherDataSource resetIsFollowedFromArray:otherArray];
    
    [super setElementsFromArray:otherArray];
}

#pragma mark - XLPublisherDataSourceChangingObservable

- (void)changePublisherFollowForAuthorId:(NSString *)authorId isFollowed:(BOOL)isFollowed {
    
    [self enumerateElementsChangeUsingBlock:^BOOL(__kindof XLPublisherModel *obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj.authorId isEqualToString:authorId]) {
            if (obj.isFollowed != isFollowed) {
                obj.isFollowed = isFollowed;
                obj.fansCount += isFollowed ? 1 : -1;
            }
            return YES;
        }
        
        return NO;
    }];
}

@end
