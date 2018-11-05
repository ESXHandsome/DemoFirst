//
//  PublisherVideoFeedListViewController.h
//  NationalRedPacket
//
//  Created by fensi on 2018/5/8.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "BaseFeedListViewController.h"

@class PublisherVideoFeedListViewController;

@protocol PublisherVideoFeedListViewControllerDelegate <NSObject>

- (void)feedList:(PublisherVideoFeedListViewController *)feedList scrollViewDidScroll:(UIScrollView *)scrollView;

@end

@interface PublisherVideoFeedListViewController : BaseFeedListViewController

@property (strong, nonatomic) XLPublisherModel *personalModel;

@property (weak, nonatomic) id<PublisherVideoFeedListViewControllerDelegate> delegate;

@end
