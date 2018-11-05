//
//  UserCollectionFeedListViewModel.m
//  NationalRedPacket
//
//  Created by fensi on 2018/5/10.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "UserCollectionFeedListViewModel.h"
#import "NewsApi.h"

@implementation UserCollectionFeedListViewModel

- (void)refresh {
    NSString *fetchAction = @"new";
    XLFeedModel *model = self.dataSource.elements.lastObject;
    [NewsApi fetchMyCollectionsWithAction:fetchAction
                                   itemID:model.itemId
                                  success:^(NSDictionary *response) {
                                      NSMutableArray *itemArray = [NSArray yy_modelArrayWithClass:XLFeedModel.class json:response[@"item"]].mutableCopy;
                                      // 移除黑名单用户发布内容
                                      [XLUserManager.shared deleteUserFeedInBlacklist:itemArray];
                                      
                                      [self refreshSuccess:itemArray tipCount:0];
                                  } failure:^(NSInteger errorCode) {
                                      [self refreshFailure:errorCode];
                                  }];
}

-(void)refreshSuccess:(NSArray<XLFeedModel *> *)feeds tipCount:(NSInteger)tipCount {
    [super refreshSuccess:feeds tipCount:tipCount];
    if (feeds.count == 0) {
        [self.baseDelegate showEmpty];
    }
}

- (void)loadMore {
    NSString *fetchAction = @"old";
    XLFeedModel *model = self.dataSource.elements.lastObject;
    [NewsApi fetchMyCollectionsWithAction:fetchAction
                                   itemID:model.itemId
                                  success:^(NSDictionary *response) {
                                      NSMutableArray *itemArray = [NSArray yy_modelArrayWithClass:XLFeedModel.class json:response[@"item"]].mutableCopy;
                                      // 移除黑名单用户发布内容
                                      [XLUserManager.shared deleteUserFeedInBlacklist:itemArray];

                                      [self loadMoreSuccess:itemArray];
                                  } failure:^(NSInteger errorCode) {
                                      [self loadMoreFailure:errorCode];
                                  }];
}

@end
