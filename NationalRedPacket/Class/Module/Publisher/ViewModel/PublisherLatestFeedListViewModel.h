//
//  PublisherLatestFeedListViewModel.h
//  NationalRedPacket
//
//  Created by fensi on 2018/5/10.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "BaseFeedListViewModel.h"

@interface PublisherLatestFeedListViewModel : BaseFeedListViewModel

@property (strong, nonatomic) XLPublisherModel *personalModel;
@property (assign, nonatomic, getter=isPermanentBan) BOOL permanentBan;

@end
