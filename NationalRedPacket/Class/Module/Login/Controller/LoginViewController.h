//
//  LoginViewController.h
//  NationalRedPacket
//
//  Created by 王海玉 on 2018/1/26.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewModel.h"

@interface LoginViewController : UIViewController

@property (strong, nonatomic) LoginViewModel *viewModel;
@property (copy, nonatomic) void (^loginSuccess)(BOOL success);

/**
 显示登录控制器
 
 @param sourceType 界面来源
 @return 登录控制器实例
 */
+ (LoginViewController *)showLoginVCFromSource:(LoginSourceType)sourceType;

@end
