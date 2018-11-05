//
//  FollowHeaderView.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/1/26.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "FollowButton.h"
#import "XLFeedModel.h"

@interface NavigationBarFollowView : BaseView

@property (strong, nonatomic) FollowButton *followButton;
@property (strong, nonatomic) XLFeedModel *model;
@property (assign, nonatomic) BOOL transparency;

@end
