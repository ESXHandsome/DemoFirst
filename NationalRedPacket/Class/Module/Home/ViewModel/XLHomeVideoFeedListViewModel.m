//
//  XLHomeVideoFeedListViewModel.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/7/12.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLHomeVideoFeedListViewModel.h"
#import "NewsApi.h"

@implementation XLHomeVideoFeedListViewModel

- (void)refresh {
    [StatServiceApi statEvent:USER_DOWN_FETCH];
    
    [NewsApi fetchNewClassify:@"video" success:^(id responseDict) {
        
        NSMutableArray *feeds = [NSArray yy_modelArrayWithClass:XLFeedModel.class json:responseDict[@"item"]].mutableCopy;
        
        // 移除黑名单用户发布内容
        [XLUserManager.shared deleteUserFeedInBlacklist:feeds];
        
        [self refreshSuccess:feeds tipCount:feeds.count];
        
    } failure:^(NSInteger errorCode) {
        [self loadMoreFailure:errorCode];
    }];
}

- (void)loadMore {
    [StatServiceApi statEvent:USER_UP_FETCH];

    [NewsApi fetchNewClassify:@"video" success:^(id responseDict) {
        
        NSMutableArray *feeds = [NSArray yy_modelArrayWithClass:XLFeedModel.class json:responseDict[@"item"]].mutableCopy;
        // 移除黑名单用户发布内容
        [XLUserManager.shared deleteUserFeedInBlacklist:feeds];
        
        [self loadMoreSuccess:feeds];
        
    } failure:^(NSInteger errorCode) {
        [self loadMoreFailure:errorCode];
    }];
}

@end
