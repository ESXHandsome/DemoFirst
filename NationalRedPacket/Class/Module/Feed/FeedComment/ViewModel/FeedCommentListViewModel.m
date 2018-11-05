//
//  FeedCommentListViewModel.m
//  NationalRedPacket
//
//  Created by fensi on 2018/4/23.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "FeedCommentListViewModel.h"
#import "NewsApi.h"
#import "AliyunOSSApi.h"

@interface FeedCommentListViewModel ()

@property (strong, nonatomic) XLFeedModel *feed;
@property (strong, nonatomic) NSMutableArray<FeedCommentListSectionModel *> *mutableSections;

///上次拉取到的评论数据最后一条的commentId
@property (strong, nonatomic) NSString *commentId;
///上次拉取到的评论数据最后一条的点赞数量
@property (strong, nonatomic) NSString *lastUpNum;

@end

@implementation FeedCommentListViewModel

#pragma mark - Lifecycle

- (instancetype)initWithFeed:(XLFeedModel *)feed
{
    self = [super init];
    if (self) {
        _feed = feed;
        _mutableSections = [NSMutableArray array];
        
        self.commentId = @"0";
        self.lastUpNum = @"0";
        self.isFirstFetch = YES;
    }
    return self;
}

#pragma mark - Public

- (void)loadMore {
    
    void(^callDelegate)(NSArray *) = ^(NSArray *sections) {
        
        if ([self.delegate respondsToSelector:@selector(viewModel:didAppendSections:)]) {
            [self.delegate viewModel:self didAppendSections:sections];
        }
    };
    
    [NewsApi fetchCommentWithItemId:self.feed.itemId type:self.feed.type commentId:self.commentId lastUpNum:self.lastUpNum specialCommentId:self.specialCommentId specialSecondCommentId:self.specialSecondCommentId success:^(id responseDict) {
        
        NSMutableArray *array = [NSArray yy_modelArrayWithClass:XLFeedCommentModel.class json:responseDict[@"comment"]].mutableCopy;
        
        [XLUserManager.shared deleteUserCommentInBlacklist:array];
        
        [self.mutableSections addObjectsFromArray:[FeedCommentListSectionModel sectionModelsFromFirstlyComments:array]];
        if ([self.commentId isEqualToString:@"0"]) {
            self.isFirstFetch = YES;
            self.specialCommentId = nil;
            self.isSpecialComment = [responseDict[@"specialComment"] boolValue];
            self.isSpecialSecondComment = [responseDict[@"specialSecondComment"] boolValue];
        } else {
            self.isFirstFetch = NO;
        }
      
        if (array.count != 0) {
            self.commentId = [array.lastObject commentId];
            self.lastUpNum = [array.lastObject upNum];
        }
        
        callDelegate(array);
        
    } failure:^(NSInteger errorCode) { callDelegate(nil); }];
}

- (void)addFeedCommentWithModelArray:(NSMutableArray <XLFeedCommentModel *> *)array {
    [self.mutableSections addObjectsFromArray:[FeedCommentListSectionModel sectionModelsFromFirstlyComments:array]];
    for (FeedCommentListSectionModel *sectionModel in self.mutableSections) {
        NSArray *tempArray = sectionModel.rows;
        for (FeedCommentListRowModel *rowModel in tempArray) {
            if (rowModel.type == FeedCommentListFirstlyRowType) {
                rowModel.isAllContent = YES;
            }
        }
    }
}

- (void)loadMoreSecondaryMomentWithRowModel:(FeedCommentListRowModel *)rowModel
                                    success:(FeedCommentRowsChangedBlock)success
                                    failure:(FailureBlock)failure {
    
    [NewsApi fetchSecondaryCommentWithItemId:self.feed.itemId commentId:rowModel.section.firstlyCommentRow.comment.commentId type:self.feed.type secondCommentId:rowModel.section.lastSecondaryCommentRow.comment.commentId success:^(id responseDict) {

        NSMutableArray *array = [NSArray yy_modelArrayWithClass:XLFeedCommentModel.class json:responseDict[@"secondComment"]].mutableCopy;
        [XLUserManager.shared deleteUserCommentInBlacklist:array];
        
        [rowModel.section insertSecondaryCommentsFromArray:array rowsChanged:success];
        
    } failure:failure];
}

- (void)deleteFeedCommentWithModel:(FeedCommentListRowModel *)rowModel success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    [NewsApi deleteCommentWithItemId:self.feed.itemId commentId:rowModel.comment.commentId type:self.feed.type success:^(id responseDict) {
        [self.mutableSections removeObject:rowModel.section];
        if (success) {
            success(responseDict);
        }
        
    } failure:^(NSInteger errorCode) {
        if (failure) {
            failure(errorCode);
        }
    }];
}

- (void)deleteSecondaryCommentWithModel:(FeedCommentListRowModel *)rowModel
                                success:(SuccessBlock)success
                                failure:(FailureBlock)failure {
    
    [rowModel.section removeSecondaryCommentRow:rowModel];

    [NewsApi deleteSecondaryCommentWithItemId:self.feed.itemId commentId:rowModel.section.firstlyCommentRow.comment.commentId secondCommentId:rowModel.comment.commentId type:self.feed.type success:^(id responseDict) {

        if (success) {
            success(@{});
        }
    
    } failure:^(NSInteger errorCode) {
        if (failure) {
            failure(errorCode);
        }
    }];
}

- (void)praiseFeedCommentWithCommentId:(NSString *)commentId isPraise:(BOOL)isPraise success:(SuccessBlock)success failure:(FailureBlock)failure {

    [NewsApi commentPraiseWithItemId:self.feed.itemId commentId:commentId type:self.feed.type action:isPraise success:^(id responseDict) {

        if (success) {
            success(responseDict);
        }
        
    } failure:^(NSInteger errorCode) {
        if (failure) {
            failure(errorCode);
        }
    }];
}

- (void)commentFeedWithContent:(NSString *)content picture:(UIImage *)picture pictureFileURL:(NSURL *)pictureFileURL isForward:(BOOL)isForward success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    [StatServiceApi statEvent:self.feed.type.integerValue == XLFeedCellMultiPictureType ? IMAGE_COMMENT : VIDEO_COMMENT model:self.feed];

    void(^commentBlock)(NSDictionary *) = ^(NSDictionary *imageInfo) {
        
        [NewsApi commentWithItemId:self.feed.itemId type:self.feed.type content:content imageInfo:imageInfo success:^(id responseDict) {
            
            if ([responseDict[@"result"] integerValue] != 0) {
                [MBProgressHUD showError:@"你输入的内容含有违规内容，请编辑后重新发送"];
                return;
            }
            XLFeedCommentModel *comment = [XLFeedCommentModel yy_modelWithJSON:responseDict[@"comment"]];
            
            [self.mutableSections insertObject:[[FeedCommentListSectionModel alloc] initWithComment:comment] atIndex:0];
            
            if (success) {
                success(comment);
            }
        } failure:failure];

    };
    
    if (picture) {
        [AliyunOSSApi.shared uploadObjectAsyncWithImage:picture imageFileURL:pictureFileURL success:commentBlock failure:failure];
    } else {
        commentBlock(nil);
    }
}

- (void)replyCommentRow:(FeedCommentListRowModel *)row content:(NSString *)content isForward:(BOOL)isForward success:(FeedCommentRowsChangedBlock)success failure:(FailureBlock)failure {
    
    [NewsApi commentWithCommentId:row.section.firstlyCommentRow.comment.commentId toAuthorId:(row.type == FeedCommentListSecondaryRowType ? row.comment.fromAuthorId : @"") type:self.feed.type content:content success:^(id responseDict) {

        if ([responseDict[@"result"] integerValue] != 0) {
            [MBProgressHUD showError:@"你输入的内容含有违规内容，请编辑后重新发送"];
            return;
        }
        XLFeedCommentModel *comment = [XLFeedCommentModel yy_modelWithJSON:responseDict[@"secondComment"]];

        [row.section insertMySecondaryComment:comment rowsChanged:success];
        [StatServiceApi statEvent:SECOND_COMMENT model:nil otherString:row.type == FeedCommentListSecondaryRowType ? [NSString stringWithFormat:@"second,%@", row.section.firstlyCommentRow.comment.commentId] : [NSString stringWithFormat:@"first,%@", row.section.firstlyCommentRow.comment.commentId]];
        
    } failure:failure];
}

#pragma mark - Private

- (void)reload {
    
    self.commentId = @"0";
    self.lastUpNum = @"0";
    
    [self loadMore];
}

#pragma mark - Custom Accessors

- (NSArray<FeedCommentListSectionModel *> *)sections {
    return [NSArray arrayWithArray:self.mutableSections];
}


@end
