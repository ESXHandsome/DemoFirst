//
//  PublisherVideoFeedListViewModel.m
//  NationalRedPacket
//
//  Created by fensi on 2018/5/10.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "PublisherVideoFeedListViewModel.h"
#import "NewsApi.h"

@implementation PublisherVideoFeedListViewModel

- (void)refresh {
    /*视频页和动态页面的接口相同,所以延迟一秒请求,想要好的体验,你叫服务端加个接口呀!*/
    [NSThread sleepForTimeInterval:1];
    
    NSString *action = self.isFirstRefresh ? @"new" : @"old";
    NSString *contentType = @"video";
    
    XLFeedModel *lastItemModel = self.dataSource.elements.lastObject;
    NSString *lastItemID = self.isFirstRefresh ? @"" : lastItemModel.itemId;
    NSString *authorId = self.personalModel.authorId;
    NSString *index = lastItemModel.index;
    
    [NewsApi fetchPersonalHomePageFeedsWithAction:action
                                           itemID:lastItemID
                                      contenttype:contentType
                                         authorID:authorId
                                            index:index
                                          success:^(NSDictionary *response) {
                                              NSMutableArray *itemArray = [NSArray yy_modelArrayWithClass:XLFeedModel.class json:response[@"item"]].mutableCopy;
                                              if ([response[@"result"] integerValue] == 4) {
                                                  return;
                                              }
                                              // 移除黑名单用户发布内容
                                              [XLUserManager.shared deleteUserFeedInBlacklist:itemArray];

                                              [self refreshSuccess:itemArray tipCount:0];
                                          } failure:^(NSInteger errorCode) {
                                              [self refreshFailure:errorCode];
                                          }];
}

- (void)loadMore {
    
    NSString *action = @"old";
    NSString *contentType = @"video";
    
    XLFeedModel *lastItemModel = self.dataSource.elements.lastObject;
    NSString *lastItemID = self.isFirstRefresh ? @"" : lastItemModel.itemId;
    NSString *authorId = self.personalModel.authorId;
    NSString *index = lastItemModel.index;
    
    [NewsApi fetchPersonalHomePageFeedsWithAction:action
                                           itemID:lastItemID
                                      contenttype:contentType
                                         authorID:authorId
                                            index:index
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
