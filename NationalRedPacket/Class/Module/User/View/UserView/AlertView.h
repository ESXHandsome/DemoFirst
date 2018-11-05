//
//  alertView.h
//  NationalRedPacket
//
//  Created by 王海玉 on 2018/1/2.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "BaseView.h"

@interface AlertView : BaseView

@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *rightButton;

- (void)alertViewWithTitle:(NSString *)title detail:(NSString *)detail leftBtnName:(NSString *)left rightBtnName:(NSString *)right;

@end
