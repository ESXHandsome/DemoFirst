//
//  XLFeedDataSource.m
//  NationalRedPacket
//
//  Created by fensi on 2018/4/13.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLFeedDataSource.h"
#import "XLPublisherDataSource.h"
#import "XLFeedCommentModel.h"

@implementation XLFeedDataSource

#pragma mark - Override

- (void)addElementsFromArray:(NSArray *)otherArray {
    
    [XLPublisherDataSource resetIsFollowedFromArray:otherArray];
    
    [super addElementsFromArray:otherArray];
}

- (void)setElementsFromArray:(NSArray *)otherArray {
    
    [XLPublisherDataSource resetIsFollowedFromArray:otherArray];
    
    [super setElementsFromArray:otherArray];
}

#pragma mark - XLFeedDataSourceChangingObservable

- (void)changeFeedTreadForItemId:(NSString *)itemId isTreaded:(BOOL)isTreaded {

    [self enumerateElementsChangeUsingBlock:^BOOL(__kindof XLFeedModel *obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj.itemId isEqualToString:itemId]) {
            if (obj.isTread != isTreaded) {
                obj.isTread = isTreaded;
                obj.treadNum += isTreaded ? 1 : -1;
            }
            *stop = YES;
            return YES;
        }
        
        return NO;
    }];
}

- (void)changeFeedPraiseForItemId:(NSString *)itemId isPraised:(BOOL)isPraised {
    [self enumerateElementsChangeUsingBlock:^BOOL(__kindof XLFeedModel *obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj.itemId isEqualToString:itemId]) {
            if (obj.isPraise != isPraised) {
                obj.isPraise = isPraised;
                obj.praiseNum += isPraised ? 1 : -1;
            }
            *stop = YES;
            return YES;
        }
        
        return NO;
    }];
}

- (void)changeFeedSuperCommentForItemId:(NSString *)itemId commentId:(NSString *)commentId isPraised:(BOOL)isPraised {
    
    [self enumerateElementsChangeUsingBlock:^BOOL(__kindof XLFeedModel *obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj.itemId isEqualToString:itemId]) {
            NSMutableArray *tempArray = obj.bestComment.mutableCopy;
            for (XLFeedCommentModel *comment in tempArray) {
                if ([comment.commentId isEqualToString:commentId]) {
                    if (comment.isPraise != isPraised) {
                        comment.isPraise = isPraised;
                        comment.upNum = [NSString stringWithFormat:@"%ld", comment.upNum.integerValue + (isPraised ? 1 : -1)];
                    }
                }
            }
            obj.bestComment = tempArray;
            *stop = YES;
            return YES;
        }
        
        return NO;
    }];
}

- (void)changeFeedCollectionForItemId:(NSString *)itemId isCollection:(BOOL)isCollection {
    
    [self enumerateElementsChangeUsingBlock:^BOOL(__kindof XLFeedModel *obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj.itemId isEqualToString:itemId]) {
            if (obj.isCollection != isCollection) {
                obj.isCollection = isCollection;
            }
            *stop = YES;
            return YES;
        }
        
        return NO;
    }];
}

- (void)changeFeedCommentNumForItemId:(NSString *)itemId num:(NSInteger)num {
    
    [self enumerateElementsChangeUsingBlock:^BOOL(__kindof XLFeedModel *obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj.itemId isEqualToString:itemId]) {
            obj.commentNum = num;
            *stop = YES;
            return YES;
        }
        
        return NO;
    }];
}

- (void)increaseFeedCommentNumForItemId:(NSString *)itemId {
    
    [self enumerateElementsChangeUsingBlock:^BOOL(__kindof XLFeedModel *obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj.itemId isEqualToString:itemId]) {
            obj.commentNum += 1;
            *stop = YES;
            return YES;
        }
        
        return NO;
    }];
}

- (void)decreaseFeedCommentNumForItemId:(NSString *)itemId {
    
    [self enumerateElementsChangeUsingBlock:^BOOL(__kindof XLFeedModel *obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj.itemId isEqualToString:itemId]) {
            obj.commentNum -= 1;
            *stop = YES;
            return YES;
        }
        
        return NO;
    }];
}

- (void)increaseFeedForwardNumForItemId:(NSString *)itemId {
    
    [self enumerateElementsChangeUsingBlock:^BOOL(__kindof XLFeedModel *obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj.itemId isEqualToString:itemId]) {
            obj.forwardNum += 1;
            *stop = YES;
            return YES;
        }
        
        return NO;
    }];
}

#pragma mark - XLPublisherDataSourceChangingObservable

- (void)changePublisherFollowForAuthorId:(NSString *)authorId isFollowed:(BOOL)isFollowed {
    
    [self enumerateElementsChangeUsingBlock:^BOOL(__kindof XLFeedModel *obj, NSUInteger idx, BOOL *stop) {
        
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
