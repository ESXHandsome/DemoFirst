//
//  UserLikeFeedListViewModel.m
//  NationalRedPacket
//
//  Created by fensi on 2018/5/10.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "UserLikeFeedListViewModel.h"
#import "NewsApi.h"

@implementation UserLikeFeedListViewModel

- (void)refresh {
    
    NSString *fetchAction = self.isFirstRefresh ? @"new" : @"old";
    XLFeedModel *model = self.dataSource.elements.lastObject;
    
    @weakify(self);
    [NewsApi fetchMyLikesWithAction:fetchAction
                             itemID:model.itemId
                            success:^(NSDictionary *response) {
                                @strongify(self);
                                NSMutableArray *feeds = [NSArray yy_modelArrayWithClass:XLFeedModel.class json:response[@"item"]].mutableCopy;

                                // 移除黑名单用户发布内容
                                [XLUserManager.shared deleteUserFeedInBlacklist:feeds];
                                
                                [self refreshSuccess:feeds tipCount:0];
                                
                                if (self.isFirstRefresh && feeds.count < 10) {
                                    [self.baseDelegate refreshFinish:NO];
                                }
                                    
                            } failure:^(NSInteger errorCode) {
                                @strongify(self);
                                [self refreshFailure:errorCode];
                            }];
}

- (void)loadMore {
    
    NSString *fetchAction = self.isFirstRefresh ? @"new" : @"old";
    XLFeedModel *model = self.dataSource.elements.lastObject;
    
    @weakify(self);
    [NewsApi fetchMyLikesWithAction:fetchAction
                             itemID:model.itemId
                            success:^(NSDictionary *response) {
                                @strongify(self);
                                NSMutableArray *feeds = [NSArray yy_modelArrayWithClass:XLFeedModel.class json:response[@"item"]].mutableCopy;
                                // 移除黑名单用户发布内容
                                [XLUserManager.shared deleteUserFeedInBlacklist:feeds];
                                
                                [self loadMoreSuccess:feeds];
                            } failure:^(NSInteger errorCode) {
                                @strongify(self);
                                [self loadMoreFailure:errorCode];
                            }];
}

@end
