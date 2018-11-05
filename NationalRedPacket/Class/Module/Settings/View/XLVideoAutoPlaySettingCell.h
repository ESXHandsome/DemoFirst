//
//  XLVideoAutoPlaySettingCell.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/8/6.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"


@interface XLVideoAutoPlaySettingCell : BaseTableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UISwitch *autoPlaySettingSwitch;
@property (nonatomic, copy) void (^switchChangedBlock)(BOOL isOn);

- (void)setTitleLabelText:(NSString *)title isSwitch:(BOOL)isSwitch;

@end
