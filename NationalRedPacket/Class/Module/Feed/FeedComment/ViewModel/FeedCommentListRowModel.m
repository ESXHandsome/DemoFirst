//
//  FeedCommentListRowModel.m
//  NationalRedPacket
//
//  Created by fensi on 2018/4/23.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "FeedCommentListRowModel.h"
#import "NSString+Height.h"

@interface FeedCommentListRowModel ()

@property (assign, nonatomic) FeedCommentListRowType type;
@property (strong, nonatomic) XLFeedCommentModel *comment;

@end

@implementation FeedCommentListRowModel

+ (NSArray<FeedCommentListRowModel *> *)rowModelsFromSecondaryComments:(NSArray<XLFeedCommentModel *> *)comments section:(FeedCommentListSectionModel *)section {
    return [comments mapObjectsUsingBlock:^id(XLFeedCommentModel *obj, NSUInteger idx) {
        return [[FeedCommentListRowModel alloc] initSecondaryRowTypeWithComment:obj section:section];
    }];
}

- (instancetype)initFirstlyRowTypeWithComment:(XLFeedCommentModel *)comment section:(FeedCommentListSectionModel *)section {
    self = [super init];
    if (self) {
        _type = FeedCommentListFirstlyRowType;
        _comment = comment;
        _section = section;
        CGFloat height = [NSString heightWithString:comment.content fontSize:adaptFontSize(30) lineSpacing:adaptHeight1334(7) maxWidth: SCREEN_WIDTH - adaptWidth750(64*2) - adaptWidth750(40)];
        _isAllContent = height > adaptHeight1334(125*2) ? NO : YES;
    }
    return self;
}

- (instancetype)initSecondaryRowTypeWithComment:(XLFeedCommentModel *)comment section:(FeedCommentListSectionModel *)section {
    self = [super init];
    if (self) {
        _type = FeedCommentListSecondaryRowType;
        _comment = comment;
        _section = section;
    }
    return self;
}

- (instancetype)initSecondaryUnfoldTipRowTypeWithSection:(FeedCommentListSectionModel *)section {
    self = [super init];
    if (self) {
        _type = FeedCommentListSecondaryUnfoldTipRowType;
        _section = section;
    }
    return self;
}

- (instancetype)initSecondaryTopRowType {
    self = [super init];
    if (self) {
        _type = FeedCommentListSecondaryTopRowType;
    }
    return self;
}

- (instancetype)initSecondaryBottomRowType {
    self = [super init];
    if (self) {
        _type = FeedCommentListSecondaryBottomRowType;
    }
    return self;
}

@end
