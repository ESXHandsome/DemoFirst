//
//  XLIncomeNoticeAttachment.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/5/29.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLBaseCustomAttachment.h"

/*
statusTxt = "到账成功;
money = 500;
title = 零钱收入;
content = 昨日金币到账;
url = www.baidu.com;
moneyType = coin;
 */

@interface XLIncomeNoticeAttachment : XLBaseCustomAttachment

@property (copy, nonatomic) NSString *statusTxt;
@property (copy, nonatomic) NSString *money;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *moneyType;

@end
