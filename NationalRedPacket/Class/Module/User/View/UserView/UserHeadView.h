//
//  UserHeadView.h
//  NationalRedPacket
//
//  Created by 王海玉 on 2018/1/3.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BackResult)(NSInteger index);

@interface UserHeadView : UIView

@property (copy, nonatomic) BackResult headBackResult;

//- (void)setUserIsLogin:(BOOL)isLogin;

@end
