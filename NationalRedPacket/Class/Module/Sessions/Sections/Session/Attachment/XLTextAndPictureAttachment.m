//
//  XLTextAndPictureAttachment.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/6/20.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLTextAndPictureAttachment.h"

@implementation XLTextAndPictureAttachment

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"subtitle" : @"description"};
}

@end