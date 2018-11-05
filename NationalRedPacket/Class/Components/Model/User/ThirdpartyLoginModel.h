//
//  ThirdpartyLoginModel.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/5/16.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThirdpartyLoginModel : NSObject

@property (copy, nonatomic) NSString *openId;
@property (copy, nonatomic) NSString *accessToken;
@property (copy, nonatomic) NSString *platform;
@property (assign, nonatomic) NSInteger code;

@end
