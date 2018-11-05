//
//  HomeFollowFeedListViewController.h
//  NationalRedPacket
//
//  Created by fensi on 2018/5/8.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "BaseFeedListViewController.h"

@class HomeFollowFeedListViewController;

@protocol HomeFollowFeedListViewControllerDelegate <NSObject>

- (void)feedList:(HomeFollowFeedListViewController *)feedList didChangedFollowingFeedState:(BOOL)isHasNewFeed;

@end

@interface HomeFollowFeedListViewController : BaseFeedListViewController

@property (weak, nonatomic) id<HomeFollowFeedListViewControllerDelegate> delegate;

@end
