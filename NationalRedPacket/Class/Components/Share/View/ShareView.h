//
//  ShareView.h
//  NationalRedPacket
//
//  Created by sunmingyue on 17/11/15.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "BaseView.h"

@protocol ShareViewDelegate <NSObject>

- (void)didClickWechatShareButton;
- (void)didClickTimeLineShareButton;
- (void)didClickQQZoneShareButton;
- (void)didClickQQChatShareButton;

@end

@interface ShareView : BaseView

- (void)showShareView;

@property (weak, nonatomic) id<ShareViewDelegate> delegate;

@end
