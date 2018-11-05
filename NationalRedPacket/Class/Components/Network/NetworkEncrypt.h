//
//  NetworkEncrypt.h
//  NationalRedPacket
//
//  Created by 孙明悦 on 2017/6/15.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkEncrypt : NSObject

+ (NSString *_Nonnull)encryptData:(NSDictionary *_Nonnull)data
                          withKey:(NSString *_Nonnull)key;

+ (NSDictionary *_Nonnull)decryptData:(NSString *_Nullable)data
                              withKey:(NSString *_Nonnull)key;

@end
