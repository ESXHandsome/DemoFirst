//
//  NegativeFeedbackView.h
//  NationalRedPacket
//
//  Created by Ying on 2018/5/7.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NegativeFeedbackDelegate <NSObject>
- (void)negativeFeedBackButtonDidClicked:(XLFeedModel *)model content:(NSString *)content;
@end

@interface NegativeFeedbackView : UIView
@property (weak, nonatomic) id<NegativeFeedbackDelegate> delegate;
@property (strong, nonatomic) XLFeedModel *model;
- (void)presentFromView:(UIView *)fromView
            toContainer:(UIView *)container
               animated:(BOOL)animated
             completion:(void (^)(void))completion;
@end
