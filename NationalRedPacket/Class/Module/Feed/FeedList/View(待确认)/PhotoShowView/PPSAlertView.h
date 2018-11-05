//
//  PPSAlertView.h
//  NationalRedPacket
//  自定义alertView （从屏幕下方弹出）
//  Created by Ying on 2018/2/26.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    AlertActionStyleDefault,
    AlertActionStyleCancel
}AlertViewStyle;

@interface XLAlertView :UIButton
@property (strong, nonatomic) NSString *labelText;
@property (strong, nonatomic) UILabel  *label;
@property (copy, nonatomic) void(^block)(void);

- (void)alertButtonSetLabelText:(NSString *)labelText action:(void(^)(void))action;

@end




@interface PPSAlertView : UIView

@property (strong, nonatomic) UIView   *containerView;
@property (strong, nonatomic) UIView   *freedom;

/*
 * 添加一行cell给alertView
 * title：标题
 * style：是常规按钮还是取消按钮
 *       AlertActionStyleDefault
 *       AlertActionStyleCancel
 * action：触发的事件
 * 大体同系统的UIAlertView
 */
- (void)addCellForAlerView:(NSString *)title style:(AlertViewStyle)style Action:(void (^)(void))action;
-(void)showWithAnimation:(BOOL)animation;

@end
