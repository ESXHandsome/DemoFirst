//
//  XLRedPacketDetailUserModel.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/5/29.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLRedPacketDetailUserModel : NSObject

@property (copy,   nonatomic) NSString *uid;
@property (assign, nonatomic) NSInteger time;
@property (copy,   nonatomic) NSString *money;
@property (copy,   nonatomic) NSString *name;
@property (copy,   nonatomic) NSString *avatar;

@end
