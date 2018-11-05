//
//  XLTeamSettingCell.h
//  NationalRedPacket
//
//  Created by bulangguo on 2018/7/27.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "XLTeamSettingModel.h"

@interface XLTeamSettingCell : BaseTableViewCell

@property (strong, nonatomic) UILabel  *titleLabel;
@property (strong, nonatomic) UILabel  *contentLabel;
@property (strong, nonatomic) UISwitch *switchButton;

@property (strong, nonatomic) UIView   *lineView;

@end
