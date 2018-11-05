//
//  BaseNewsCell.h
//  WatermelonNews
//
//  Created by sunmingyue on 17/11/14.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "XLFeedModel.h"
#import "TTTAttributedLabel.h"
#import "BaseFeedListViewController.h"

#define kLeftMargin adaptWidth750(32)
#define kSeparatLineHeight adaptHeight1334(10)
#define kMaxHeight  adaptHeight1334(92)

@interface BaseFeedCell : BaseTableViewCell

@property (strong, nonatomic) TTTAttributedLabel *titleLabel;
@property (strong, nonatomic) UIButton *fullTextButton;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UIView *lineView;
@property (assign, nonatomic) NSInteger isContainFollowButton;

- (void)setContentDidRead:(BOOL)isRead;

@end


