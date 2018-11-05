//
//  XLUpLoadViewModel.m
//  NationalRedPacket
//
//  Created by Ying on 2018/7/12.
//  Copyright © 2018 XLook. All rights reserved.
//

#import "XLMyUpLoadViewModel.h"
#import "NewsApi.h"

@interface XLMyUpLoadViewModel ()

@property (assign, nonatomic) NSInteger index;

@end

@implementation XLMyUpLoadViewModel

- (void)refresh {
    NSString *fetchAction = @"new";
    XLFeedModel *model = self.dataSource.elements.lastObject;
    [NewsApi fetchMyUploadWithAction:fetchAction
                               index:self.index
                              itemId:model.itemId
                             success:^(id responseDict) {
                                 self.index = [responseDict[@"itemCount"] integerValue];
                                 NSMutableArray *itemArray = [NSArray yy_modelArrayWithClass:XLFeedModel.class json:responseDict[@"item"]].mutableCopy;
                                 // 移除黑名单用户发布内容
                                 [XLUserManager.shared deleteUserFeedInBlacklist:itemArray];
                                 [self refreshSuccess:itemArray tipCount:0];
                                 
                             } failure:^(NSInteger errorCode) {
                                  [self refreshFailure:errorCode];
                             }];
}

- (void)refreshSuccess:(NSArray<XLFeedModel *> *)feeds tipCount:(NSInteger)tipCount {
    [super refreshSuccess:feeds tipCount:tipCount];
    if (feeds.count == 0) {
        [self.baseDelegate showEmpty];
    }
}

- (void)loadMore {
    NSString *fetchAction = @"old";
    XLFeedModel *model = self.dataSource.elements.lastObject;
    [NewsApi fetchMyUploadWithAction:fetchAction
                               index:self.index
                              itemId:model.itemId
                             success:^(id responseDict) {
                                 NSMutableArray *itemArray = [NSArray yy_modelArrayWithClass:XLFeedModel.class json:responseDict[@"item"]].mutableCopy;
                                 [XLUserManager.shared deleteUserFeedInBlacklist:itemArray];
                                 
                                 [self loadMoreSuccess:itemArray];
                             } failure:^(NSInteger errorCode) {
                                  [self refreshFailure:errorCode];
                             }];
}

- (NSInteger)index {
    if (!_index) {
        _index = 0;
    }
    return _index;
}

@end
