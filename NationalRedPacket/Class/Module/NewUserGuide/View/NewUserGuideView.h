//
//  NewUserGuideView.h
//  NationalRedPacket
//
//  Created by Ying on 2018/4/8.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewUserGuideViewDelegate <NSObject>

/**
 cell上的button点击后的回调

 @param authorld cell的authorld
 @param buttonState buttonState
 */
- (void)cellButtonClicked:(NSString *)authorld state:(BOOL)buttonState;

@end

@interface NewUserGuideView : UIView

@property (strong, nonatomic) UIImageView   *imageView;
@property (strong, nonatomic) UILabel       *titleLabel;
@property (strong, nonatomic) UIButton      *button;
@property (copy  , nonatomic) NSString      *authorld;
@property (weak  , nonatomic) id<NewUserGuideViewDelegate> delegate;

/**
   给按钮数据

 @param imageUrl imageURLString
 @param title    cell.title.text
 @param authorld authorld
 */
- (void)setImage:(NSString *)imageUrl title:(NSString *)title authorld:(NSString *)authorld;

/**
    给外部主动调用button点击事件 用来处理第一个cell已经被点击
 */
- (void)buttonAction;

@end
