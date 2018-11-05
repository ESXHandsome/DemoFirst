//
//  PersonalHomepageViewController.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/1/25.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLPublisherModel.h"

@interface PublisherViewController : UIViewController

@property (strong, nonatomic) XLPublisherModel *model;
@property (strong, nonatomic) NSString         *publisherId;
@property (assign, nonatomic) CGPoint printPoint;

@property (copy, nonatomic) void (^personalHomepageControllerWillDisplayBlock)(void);

@end
