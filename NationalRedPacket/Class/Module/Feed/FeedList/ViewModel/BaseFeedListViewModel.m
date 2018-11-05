//
//  BaseFeedListViewModel.m
//  NationalRedPacket
//
//  Created by fensi on 2018/5/10.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "BaseFeedListViewModel.h"
#import "NewsApi.h"
#import "TencentQQApi.h"
#import "WechatShare.h"
#import "XLDataSourceManager.h"
#import "XLUserManager.h"
#import "XLPublishApi.h"

@interface BaseFeedListViewModel () <XLDataSourceDelegate>

@property (strong, nonatomic) XLFeedDataSource *dataSource;
@property (strong, nonatomic) XLFeedModel *sharingFeed;
@property (assign, nonatomic) BOOL isFirstRefresh;
@property (assign, nonatomic) BOOL isAllowPraise;
@property (assign, nonatomic) BOOL isAllowTread;

@end

@implementation BaseFeedListViewModel

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataSource = [[XLFeedDataSource alloc] init];
        _dataSource.delegate = self;
        _isFirstRefresh = YES;
        _isAllowPraise = YES;
        _isAllowTread = YES;
    }
    return self;
}

#pragma mark - XLDataSourceDelegate

- (void)dataSource:(XLDataSource *)dataSource didChangedForIndex:(NSInteger)index {
    
    XLFeedModel *model = [dataSource.elements objectAtIndex:index];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    [self.baseDelegate reloadModel:model atIndexPath:indexPath];
}

#pragma mark - Public

- (void)resetAndRefresh {
    
    self.isFirstRefresh = YES;
    
    [self.baseDelegate showLoading];
    [self refresh];
}

- (void)refresh {
    NSAssert(NO, @"需要子类实现");
}

- (void)refreshSuccess:(NSArray<XLFeedModel *> *)feeds tipCount:(NSInteger)tipCount {
    
    [self.baseDelegate hideLoading];
    [self.baseDelegate hideLoadFailed];
    [self.baseDelegate hideEmpty];
    
    // 第一次拉取时无数据
    if (feeds.count == 0 && self.isFirstRefresh) {
        [self.baseDelegate showEmpty];
    }
    
    [self.dataSource setElementsFromArray:feeds];
    
    [self.baseDelegate reloadData];
    [self.baseDelegate refreshFinish:YES];
    [self.baseDelegate showTipCount:tipCount];
    
    self.isFirstRefresh = NO;
}

- (void)refreshFailure:(NSInteger)errorCode {
    
    [self.baseDelegate showTipCount:errorCode];
    [self.baseDelegate hideLoading];
    
    if (self.dataSource.elements.count == 0 && self.isFirstRefresh) {
        [self.baseDelegate showLoadFailed];
    }
}

- (void)loadMore {
    NSAssert(NO, @"需要子类实现");
}

- (void)loadMoreSuccess:(NSArray<XLFeedModel *> *)feeds {
    
    [self.baseDelegate hideLoading];
    [self.baseDelegate hideLoadFailed];
    
    if (feeds.count == 0) {
        
        [self.baseDelegate loadMoreFinish:NO];
        
        if (self.isFirstRefresh) {
            [self.baseDelegate showEmpty];
        }
        
    } else {
        
        NSInteger beforeCount = self.dataSource.elements.count;
        
        @weakify(self);
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
            
            NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:feeds.count];
            
            for (int i = 0; i < feeds.count; i++) {
                [indexPaths addObject:[NSIndexPath indexPathForRow:beforeCount + i inSection:0]];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
                
                [self.dataSource addElementsFromArray:feeds];
                [self.baseDelegate insertRowsAtIndexPaths:indexPaths];
                [self.baseDelegate loadMoreFinish:YES];
            });
        });
    }
    
    self.isFirstRefresh = NO;
}

- (void)loadMoreFailure:(NSInteger)errorCode {
    
    [self.baseDelegate loadMoreFinish:YES];
    [self.baseDelegate hideLoading];
    [self.baseDelegate showErrorWithCode:errorCode];
    
    if (self.dataSource.elements.count == 0 && self.isFirstRefresh) {
        [self.baseDelegate showLoadFailed];
    }
}

- (void)praise:(XLFeedModel *)feed {
    
    if (!feed.isPraise) {
        feed.isPraise = YES;
        feed.praiseNum += 1;
    } else {
        feed.isPraise = NO;
        feed.praiseNum -= 1;
    }
    
    [self uploadPraise:feed repeatUpload:YES];
    
    [XLFeedModel updateDataBaseModel:feed];
}

- (void)tread:(XLFeedModel *)feed {
    
    if (!feed.isTread) {
        feed.isTread = YES;
        feed.treadNum += 1;
    } else {
        feed.isTread = NO;
        feed.treadNum -= 1;
    }
    
    [self uploadTread:feed repeatUpload:YES];
    
    [XLFeedModel updateDataBaseModel:feed];
}

- (void)follow:(XLFeedModel *)feed success:(void (^)(BOOL))success failure:(FailureBlock)failure {
    
    BOOL isToFollow = !feed.isFollowed;
    
    [NewsApi followWithAuthorId:feed.authorId action:isToFollow success:^(id responseDict) {
        
        if (success) {
            success(isToFollow);
        }
                            
        if (isToFollow) {
            [StatServiceApi statEvent:FOLLOW_CLICK model:feed];
        }
        
    } failure:failure];
}

- (void)prepareShare:(XLFeedModel *)feed {
    
    self.sharingFeed = feed;
    
    if (feed.type.integerValue == XLFeedCellMultiPictureType) {
        [StatServiceApi statEvent:IMAGE_FORWARD model:feed];
    } else if (feed.type.integerValue == XLFeedCellArticleQQCircleType){
        [StatServiceApi statEvent:ARTICLE_FORWARD model:feed];
    } else {
        [StatServiceApi statEvent:VIDEO_FORWARD model:feed];
    }
}

- (void)uploadNegativeFeedBackItemID:(XLFeedModel *)model content:(NSString *)content success:(void(^)(id obj, NSInteger index)) successBlock{
    [NewsApi negativeFeedbackWithItemId:model.itemId type:model.type action:content isReport:NO success:^(id responseDict) {
        [MBProgressHUD showSuccess:@"反馈成功"];
        NSInteger index = [self.dataSource.elements indexOfObject:model];
        [self.dataSource removeElementAtIndex:index];
        if(successBlock){
            successBlock(nil, index);
        }
    } failure:^(NSInteger errorCode) {
        [MBProgressHUD showError:@"反馈失败"];
    }];
}

- (NSInteger)removeFeedModel:(XLFeedModel *)model {
    NSInteger index = [self.dataSource.elements indexOfObject:model];
    [self.dataSource removeElementAtIndex:index];
    return index;
}

- (void)deleteMyUploadFeed:(XLFeedModel *)model success:(void(^)(void))success {
    
    NSDictionary *info = @{@"index" : model.index,
                           @"itemId": model.itemId,
                           @"type"  : model.type
                           };
    [XLPublishApi deletePersionItem:info success:^(id responseDict) {
        if (success) {
            success();
        }
        [MBProgressHUD showSuccess:@"删除成功"];
    } failure:^(NSInteger errorCode) {
        [MBProgressHUD showError:@"删除失败"];
    }];
}

#pragma mark - Private

- (void)uploadPraise:(XLFeedModel *)model repeatUpload:(BOOL)repeatUpload {
    
    if (!self.isAllowPraise) {
        return;
    }
    if (model.isPraise) {
        //点赞
        if (model.type.integerValue == XLFeedCellMultiPictureType) {
            [StatServiceApi statEvent:IMAGE_LIKE model:model];
        } else if (model.type.integerValue == XLFeedCellArticleQQCircleType){
            [StatServiceApi statEvent:ARTICLE_LIKE model:model];
        } else {
            [StatServiceApi statEvent:VIDEO_LIKE model:model];
        }
    }
    
    [NewsApi praiseWithItemId:model.itemId type:model.type action:model.isPraise ? @"praise": @"noPraise" success:^(id responseDict) {
        
    } failure:^(NSInteger errorCode) {
        if (!repeatUpload) {
            return;
        }
        self.isAllowPraise = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isAllowPraise = YES;
            [self uploadPraise:model repeatUpload:NO];
        });
    }];
}

- (void)uploadTread:(XLFeedModel *)model repeatUpload:(BOOL)repeatUpload {
    
    if (!self.isAllowTread) {
        return;
    }
    if (model.isTread) {
        //踩
        if (model.type.integerValue == XLFeedCellMultiPictureType) {
            [StatServiceApi statEvent:IMAGE_TREAD model:model];
        } else {
            [StatServiceApi statEvent:VIDEO_TREAD model:model];
        }
    }
    [NewsApi treadWithItemId:model.itemId type:model.type action:model.isTread ? @"tread" : @"noTread" success:^(id responseDict) {
        
    } failure:^(NSInteger errorCode) {
        if (!repeatUpload) {
            return;
        }
        self.isAllowTread = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isAllowTread = YES;
            [self uploadTread:model repeatUpload:NO];
        });
    }];
}

#pragma mark - Custom Accessors

@end
