//
//  XLSessionBaseViewModel.m
//  NationalRedPacket
//
//  Created by Ying on 2018/5/28.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLSessionBaseViewModel.h"
#import "SessionsMessageApi.h"
#import "HttpCommonParam.h"
#import "PublisherApi.h"
#import "XLUserManager.h"
#import "XLPublisherDataSource.h"

@interface XLSessionBaseViewModel()

@end

@implementation XLSessionBaseViewModel

- (void)loadMore {

}

- (void)refresh {
    @weakify(self);
    [SessionsMessageApi fetchMessageType:self.type action:@"new" lastId:@"" success:^(id responseDict) {
        @strongify(self);
        self.sessionMessageArray = [NSArray yy_modelArrayWithClass:XLSessionMessageModel.class json:responseDict[@"item"]];
        if (self.sessionMessageArray.count == 0) {
            [self.baseDelegate removeLoadView];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.baseDelegate emptyDate];
            });
          
        } else {
            [self.baseDelegate removeLoadView];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.baseDelegate refreshFinish];
                [self dataPersistence:(NSArray *)responseDict[@"item"]];
            });
        }
    } failure:^(NSInteger errorCode) {
        @strongify(self);
        [self.baseDelegate removeLoadView];
        if ([self dataExtraction]) {
            self.sessionMessageArray = [NSArray yy_modelArrayWithClass:XLSessionMessageModel.class json:[self dataExtraction]];
            [self.baseDelegate refreshFinish];
        } else {
            [self.baseDelegate emptyDate];
        }
    }];
    
}

- (BOOL)authorIdFollowedExtra:(NSString *)authorId extra:(NSString *)extra{
    /**服务端传来的是否关注*/
    BOOL follow = NO;
    if ([extra integerValue] > 2) {
        follow = YES;
    }
    
    /**本地数据是否关注*/
    NSArray <NSString *>* followingAuthorIdArray = [XLPublisherDataSource followingAuthorIds];
    BOOL isFollowing = [followingAuthorIdArray containsObject:authorId];
    
    /**相同就不需要变换按钮状态*/
    if (follow == isFollowing) {
        return NO;
    }
    return YES;
}

/**提取数据*/
- (NSArray *)dataExtraction {
    NSString *type = [NSString stringWithFormat:@"%ld",(long)self.type];
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *txtPath = [cachePath stringByAppendingString:@"/"];
    txtPath = [txtPath stringByAppendingString:[HttpCommonParam userAccount]];
    txtPath = [txtPath stringByAppendingString:type];
    txtPath = [txtPath stringByAppendingString:@".txt"];
    NSArray *array = [NSArray arrayWithContentsOfFile:txtPath];
    return array;
}

/**数据持久化*/
- (void)dataPersistence:(NSArray *)array {
    NSString *type = [NSString stringWithFormat:@"%ld",(long)self.type];
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *txtPath = [cachePath stringByAppendingString:@"/"];
    txtPath = [txtPath stringByAppendingString:[HttpCommonParam userAccount]];
    txtPath = [txtPath stringByAppendingString:type];
    txtPath = [txtPath stringByAppendingString:@".txt"];
    [array writeToFile:txtPath atomically:YES];
}

/**判断用户是否存在, 我也不知道他们干嘛用, 就好像现在的用户会突然消失一样, 而且人家刚关注你的*/
- (void)isHadAuthor:(NSString *)authorld {
    if (!self.baseDelegate &&
        ![self.baseDelegate respondsToSelector:@selector(findAuthor:)] &&
        ![self.baseDelegate respondsToSelector:@selector(defindAuthor)]) {
            return;
        }
    @weakify(self);
    [PublisherApi fetchPublisherInfoWithPublisherId:authorld Success:^(id responseDict) {
        @strongify(self);
        if ([responseDict[@"result"] isEqualToString:@"3"]) {
             [self.baseDelegate defindAuthor];
        } else {
            [self.baseDelegate findAuthor:authorld];
        }
    } failure:^(NSInteger errorCode) {
        [MBProgressHUD showError:@"网络出现故障"];
    }];
}


@end
