//
//  HomeFollowFeedListViewModel.h
//  NationalRedPacket
//
//  Created by fensi on 2018/5/10.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "BaseFeedListViewModel.h"

@protocol HomeFollowFeedListViewModelDelegate <NSObject>

- (void)showDiscoverGuidance;
- (void)hideDiscoverGuidance;
- (void)didChangedFollowingFeedState:(BOOL)isHasNewFeed;

@end

@interface HomeFollowFeedListViewModel : BaseFeedListViewModel

@property (weak, nonatomic) id<HomeFollowFeedListViewModelDelegate> delegate;

@end
