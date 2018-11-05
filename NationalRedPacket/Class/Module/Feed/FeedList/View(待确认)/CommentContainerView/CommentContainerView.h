//
//  CommentContainerView.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/1/11.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLFeedModel.h"

@protocol CommentContainerViewDelegate <NSObject>

@optional;

- (void)didClickPraiseButtonEvent:(XLFeedModel *)model;
- (void)didClickTreadButtonEvent:(XLFeedModel *)model;
- (void)didClickCommentButtonEvent:(XLFeedModel *)model;
- (void)didClickForwardButtonEvent:(XLFeedModel *)model;

@end

@interface CommentContainerView : UIView

@property (strong, nonatomic) XLFeedModel *model;
@property (weak, nonatomic) id<CommentContainerViewDelegate> delegate;

@end
