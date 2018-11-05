//
//  XLPostViewController.h
//  NationalRedPacket
//
//  Created by Ying on 2018/7/11.
//  Copyright © 2018 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface XLPostAlertViewController : UIViewController

/**
 推出发布窗口

 @param contentView 当前的视图控制器
 */
- (void)presentPostAlertViewController:(UIViewController *)contentView;

@property (strong, nonatomic) NSArray *currentArray;

@end

NS_ASSUME_NONNULL_END
