//
//  FeedArticleViewController.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/24.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedArticleDetailViewController : UIViewController

@property (strong, nonatomic) XLFeedModel *feedModel;

- (void)callBackWebFollowState:(BOOL)isFollow;

@end
