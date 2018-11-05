//
//  PublisherLatestFeedListViewModel.m
//  NationalRedPacket
//
//  Created by fensi on 2018/5/10.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "PublisherLatestFeedListViewModel.h"
#import "NewsApi.h"

static NSString *PreviousPublisherAuthorId;
static NSArray *PreviousPublisherListCache;

@interface PublisherLatestFeedListViewModel ()

@property (assign, nonatomic) BOOL dataFromCache;

@end

@implementation PublisherLatestFeedListViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            // 耗时的操作
            NSString *authorID = PreviousPublisherAuthorId;
            
            if ([authorID isEqualToString:self.personalModel.authorId]) {
                
                NSArray *constDataArray = PreviousPublisherListCache;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.dataFromCache = YES;
                    // 更新界面
                    [self refreshSuccess:constDataArray tipCount:0];
                });
            } else {
                [self refresh];
            }
        });
    }
    return self;
}

- (void)refresh {
    
    XLFeedModel *lastItemModel = self.dataSource.elements.lastObject;
    
    NSString *contentType = @"all";
    NSString *action = self.isFirstRefresh ? @"new" : @"old";
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
                                                  self.permanentBan = YES;
                                                  [self refreshFailure:4];
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
    
    XLFeedModel *lastItemModel = self.dataSource.elements.lastObject;
    
    NSString *contentType = @"all";
    NSString *action = self.isFirstRefresh ? @"new" : @"old";
    NSString *lastItemID = self.isFirstRefresh ? @"" : lastItemModel.itemId;
    NSString *authorId = self.personalModel.authorId;
    NSString *index = lastItemModel.index;
    
    [NewsApi fetchPersonalHomePageFeedsWithAction:action
                                           itemID:lastItemID
                                      contenttype:contentType
                                         authorID:authorId
                                            index:index
                                          success:^(NSDictionary *response) {
                                              NSMutableArray *itemArray = (NSMutableArray *)[NSArray yy_modelArrayWithClass:XLFeedModel.class json:response[@"item"]];
                                              // 移除黑名单用户发布内容
                                              [XLUserManager.shared deleteUserFeedInBlacklist:itemArray];
                                              
                                              [self loadMoreSuccess:itemArray];
                                          } failure:^(NSInteger errorCode) {
                                              [self loadMoreFailure:errorCode];
                                          }];
}

- (void)loadMoreSuccess:(NSArray<XLFeedModel *> *)feeds {
    [super loadMoreSuccess:feeds];
    [self cacheData:feeds];
}

- (void)cacheData:(NSArray *)itemArray {
    if (!self.dataFromCache && self.isFirstRefresh) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PreviousPublisherAuthorId = self.personalModel.authorId ?: @"";
            PreviousPublisherListCache = self.dataSource.elements ?: @[];
        });
    }
}

@end
