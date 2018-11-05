//
//  CustomEditView.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/23.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "BaseView.h"

#define kEditViewHeight adaptHeight1334(88)

@interface CustomEditView : UIView

@property (strong, nonatomic) UILabel     *titleLabel;
@property (strong, nonatomic) UITextField *contentTextField;

@end
