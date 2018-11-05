//
//  PublisherLatestFeedListViewController.h
//  NationalRedPacket
//
//  Created by fensi on 2018/5/8.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "BaseFeedListViewController.h"

@class PublisherLatestFeedListViewController;

@protocol PublisherLatestFeedListViewControllerDelegate <NSObject>

- (void)feedList:(PublisherLatestFeedListViewController *)feedList scrollViewDidScroll:(UIScrollView *)scrollView;

- (void)leadToUserPermanentBan;

@end

@interface PublisherLatestFeedListViewController : BaseFeedListViewController

@property (strong, nonatomic) XLPublisherModel *personalModel;

@property (weak, nonatomic) id<PublisherLatestFeedListViewControllerDelegate> delegate;

@end
