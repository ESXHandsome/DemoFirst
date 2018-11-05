//
//  BaseView.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2017/6/27.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BackResult)(NSInteger index);

@interface BaseView : UIView

@property (copy, nonatomic) BackResult backResult;

- (void)setupViews;

@end
