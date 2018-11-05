//
//  NSString+Check.h
//  NationalRedPacket
//
//  Created by sunmingyue on 17/7/13.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ReplaceNil)

+ (NSString *)replaceNil:(NSString *)content;

+ (BOOL)verificatePhoneNumber:(NSString *)phoneNumber;

@end
