//
//  XLTeamSettingModel.h
//  NationalRedPacket
//
//  Created by bulangguo on 2018/7/27.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLTeamSettingModel : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *content;

@property (assign, nonatomic, getter=isNoDisturb) BOOL noDisturb;

@end
