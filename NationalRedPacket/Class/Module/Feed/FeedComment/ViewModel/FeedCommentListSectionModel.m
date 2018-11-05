//
//  FeedCommentListSectionModel.m
//  NationalRedPacket
//
//  Created by fensi on 2018/4/23.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "FeedCommentListSectionModel.h"

@interface FeedCommentListSectionModel ()

@property (strong, nonatomic) NSArray<FeedCommentListRowModel *> *rows;

@property (strong, nonatomic) FeedCommentListRowModel *firstlyCommentRow;
@property (strong, nonatomic) FeedCommentListRowModel *secondaryTopRow;
@property (strong, nonatomic) NSMutableArray<FeedCommentListRowModel *> *secondaryCommentRows;
@property (strong, nonatomic) FeedCommentListRowModel *secondaryUnfoldTipRow;
@property (strong, nonatomic) FeedCommentListRowModel *secondaryBottomRow;

@end

@implementation FeedCommentListSectionModel

+ (NSArray<FeedCommentListSectionModel *> *)sectionModelsFromFirstlyComments:(NSArray<XLFeedCommentModel *> *)comments {
    return [comments mapObjectsUsingBlock:^id(XLFeedCommentModel *obj, NSUInteger idx) {
        return [[FeedCommentListSectionModel alloc] initWithComment:obj];
    }];
}

#pragma mark - Lifecycle

- (instancetype)initWithComment:(XLFeedCommentModel *)comment {
    self = [super init];
    if (self) {
        _firstlyCommentRow = [[FeedCommentListRowModel alloc] initFirstlyRowTypeWithComment:comment section:self];
        
        NSMutableArray *secondaryArray = comment.secondaryComments.mutableCopy;
        [XLUserManager.shared deleteUserCommentInBlacklist:secondaryArray];
        
        _secondaryCommentRows = [NSMutableArray arrayWithArray:[FeedCommentListRowModel rowModelsFromSecondaryComments: secondaryArray section:self]];
        
        if (_secondaryCommentRows.count > 0) {
            _secondaryTopRow = [[FeedCommentListRowModel alloc] initSecondaryTopRowType];
            _secondaryBottomRow = [[FeedCommentListRowModel alloc] initSecondaryBottomRowType];
            
            if (comment.secondaryCommentTotalCount > 3) {
                _secondaryUnfoldTipRow = [[FeedCommentListRowModel alloc] initSecondaryUnfoldTipRowTypeWithSection:self];
            }
        }
        
        [self resetRows];
    }
    return self;
}

#pragma mark - Public

- (void)insertMySecondaryComment:(XLFeedCommentModel *)comment rowsChanged:(FeedCommentRowsChangedBlock)rowsChanged {
    
    self.secondaryCommentTotalCount += 1;
    
    if (self.secondaryCommentRows.count + 1 >= self.secondaryCommentTotalCount) {
        [self insertSecondaryCommentsFromArray:@[comment] rowsChanged:rowsChanged];
    } else {
        if (rowsChanged) {
            NSNumber *index = [NSNumber numberWithInteger:[self.rows indexOfObject:self.secondaryUnfoldTipRow]];
            rowsChanged(nil, nil, @[index]);
        }
    }
}

- (void)insertSecondaryCommentsFromArray:(NSArray<XLFeedCommentModel *> *)comments rowsChanged:(FeedCommentRowsChangedBlock)rowsChanged {
    
    NSMutableArray *inserts = [NSMutableArray array];
    NSMutableArray *deletes = [NSMutableArray array];
    
    if (!self.secondaryTopRow) {
        self.secondaryTopRow = [[FeedCommentListRowModel alloc] initSecondaryTopRowType];
        [inserts addObject:@1];
    }
    
    for (int i = 0; i < comments.count; i++) {
        [inserts addObject:@(2 + self.secondaryCommentRows.count + i)];
    }
    
    [self.secondaryCommentRows addObjectsFromArray:[FeedCommentListRowModel rowModelsFromSecondaryComments:comments section:self]];
    
    if (!self.secondaryBottomRow) {
        self.secondaryBottomRow = [[FeedCommentListRowModel alloc] initSecondaryBottomRowType];
        [inserts addObject:@(2 + self.secondaryCommentRows.count)];
    }
    
    if (self.secondaryCommentCount >= self.secondaryCommentTotalCount) {
        if (self.secondaryUnfoldTipRow) {
            NSNumber *index = [NSNumber numberWithInteger:[self.rows indexOfObject:self.secondaryUnfoldTipRow]];
            [deletes addObject:index];
        }
        self.secondaryUnfoldTipRow = nil;
    }
    
    [self resetRows];
    
    if (rowsChanged) {
        rowsChanged(inserts, deletes, nil);
    }
}

- (void)removeSecondaryCommentRow:(FeedCommentListRowModel *)row {
    
    [self.secondaryCommentRows removeObject:row];
    
    self.secondaryCommentTotalCount -= 1;
    
    if (self.secondaryCommentCount == 0) {
        self.secondaryTopRow = nil;
        self.secondaryBottomRow = nil;
        self.secondaryUnfoldTipRow = nil;
    }
    
    [self resetRows];
}

#pragma mark - Private

- (void)resetRows {
    
    NSMutableArray *rows = [NSMutableArray array];
    
    [rows addObject:self.firstlyCommentRow];

    if (self.secondaryTopRow) { [rows addObject:self.secondaryTopRow]; }
    
    [rows addObjectsFromArray:self.secondaryCommentRows];
    
    if (self.secondaryUnfoldTipRow) { [rows addObject:self.secondaryUnfoldTipRow]; }
    
    if (self.secondaryBottomRow) { [rows addObject:self.secondaryBottomRow]; }
    
    self.rows = rows;
}

#pragma mark - Custom Accessors

- (NSInteger)secondaryCommentCount {
    return self.secondaryCommentRows.count;
}

- (NSInteger)secondaryCommentTotalCount {
    return self.firstlyCommentRow.comment.secondaryCommentTotalCount;
}

- (void)setSecondaryCommentTotalCount:(NSInteger)secondaryCommentTotalCount {
    self.firstlyCommentRow.comment.secondaryCommentTotalCount = secondaryCommentTotalCount;
}

- (FeedCommentListRowModel *)lastSecondaryCommentRow {
    return self.secondaryCommentRows.lastObject;
}

@end

