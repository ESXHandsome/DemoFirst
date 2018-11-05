//
//  CommentLoadingMoreButton.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/4/26.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentLoadingMoreButton : UIButton

@property (assign, nonatomic) BOOL isLoading;

- (void)startLoading;
- (void)stopLoading;

@end
