//
//  NewUserGestureAnimation.h
//  NationalRedPacket
//
//  Created by Ying on 2018/6/20.
//  Copyright © 2018 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NewUserGestureGuideViewDelegate <NSObject>

- (void)gestureGuideViewWillDisappear;

@end

@interface NewUserGestureGuideView : UIView

@property (weak, nonatomic) id<NewUserGestureGuideViewDelegate> delegate;

/**展示手势引导页*/
- (void)showGestureAnimation;

@end
