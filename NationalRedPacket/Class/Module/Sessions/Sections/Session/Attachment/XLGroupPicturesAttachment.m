//
//  XLGroupPicturesAttachment.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/6/20.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLGroupPicturesAttachment.h"

@implementation XLGroupPicturesAttachment

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"list" : [XLActivityLinkModel class]};
}

@end