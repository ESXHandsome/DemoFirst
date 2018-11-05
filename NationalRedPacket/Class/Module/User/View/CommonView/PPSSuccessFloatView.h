//
//  PPSSuccessFloatView.h
//  NationalRedPacket
//
//  Created by Ying on 2018/3/22.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPSSuccessFloatView : UIView
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *moneyLabel;
-(void)pushView:(NSString *)title money:(NSString *)money;
@end
