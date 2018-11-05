//
//  NSString+Check.m
//  NationalRedPacket
//
//  Created by fensi on 2018/4/10.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "NSString+Check.h"

@implementation NSString (Check)

+ (BOOL)isBlankString:(NSString *)string {
    
    if (string == nil || string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return YES;
    }
    
    return NO;
}

@end
