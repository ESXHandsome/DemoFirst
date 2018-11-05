//
//  XLMyUploadViewController.h
//  NationalRedPacket
//
//  Created by Ying on 2018/7/12.
//  Copyright © 2018 XLook. All rights reserved.
//

#import "BaseFeedListViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol XLMyUploadViewControllerDelegate <NSObject>

- (void)didClickCancelButton;

@end

@interface XLMyUploadViewController : BaseFeedListViewController

@property (weak, nonatomic) id<XLMyUploadViewControllerDelegate> delegate;

@property (assign, nonatomic) BOOL isUploadAlertPush;
@end

NS_ASSUME_NONNULL_END
