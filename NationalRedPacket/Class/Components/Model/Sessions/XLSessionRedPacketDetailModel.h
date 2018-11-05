//
//  RedPacketDetailModel.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/5/29.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLSessionRedPacketDetailModel : NSObject

/// 状态，0：成功(check或detail时是可抢)；2：超时；3：已领取；4:其它错误
@property (assign, nonatomic) NSInteger status;
/// 红包抢完时间,status=1才有意义
@property (assign, nonatomic) NSInteger time;
/// 红包金额数
@property (copy,   nonatomic) NSString *money;
/// 收入类型
@property (copy,   nonatomic) NSString *moneyType;
/// 金币价值
@property (copy,   nonatomic) NSString *moneyValue;
/// 发红包用户昵称
@property (copy,   nonatomic) NSString *name;
/// 发红包用户头像
@property (copy,   nonatomic) NSString *avatar;
/// 红包内容
@property (copy,   nonatomic) NSString *content;
/// 抢到的红包数
@property (assign, nonatomic) NSInteger fetch_num;
/// 总共红包数
@property (assign, nonatomic) NSInteger total_num;
/// 抢到的红包金额
@property (copy, nonatomic) NSString *fetch_money;
/// 总的红包金额
@property (copy, nonatomic) NSString *total_money;
/// 红包被抢的详情
@property (copy, nonatomic) NSArray  *detail;
/// 手气最佳的用户ID
@property (copy, nonatomic) NSString *lucky_uid;

@end
