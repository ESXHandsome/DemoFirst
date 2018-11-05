//
//  XLBaseCustomAttachment.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/5/29.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLBaseCustomAttachment.h"

@implementation XLBaseCustomAttachment

- (NSString *)encodeAttachment {
    
    NSDictionary *dict = @{@"type" : @(self.customMessageType),
                           @"data" : [self yy_modelToJSONObject]
                           };
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:0
                                                     error:nil];
    NSString *content = nil;
    if (data) {
        content = [[NSString alloc] initWithData:data
                                        encoding:NSUTF8StringEncoding];
    }
    return content;
}

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"attachmentId" : @"id"};
}

@end
