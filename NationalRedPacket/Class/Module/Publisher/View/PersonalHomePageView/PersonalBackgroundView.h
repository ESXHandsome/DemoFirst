//
//  PersonalBackgroundView.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/1/25.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PersonalSegmentView;
@class PersonalTopView;

@interface PersonalBackgroundView : UIView

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) PersonalTopView *topView;
@property (strong, nonatomic) UITableView *dynamicView;
@property (strong, nonatomic) UITableView *videoView;

@end
