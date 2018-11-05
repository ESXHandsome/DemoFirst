//
//  DiscoverModel.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/9.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "DiscoveryModel.h"

@implementation DiscoveryModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"list"   : [XLPublisherModel class],
             @"card"   : [XLPublisherModel class],
             @"banner" : [BannerModel class]
             };
}

@end

@implementation BannerModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"authorList" : [XLPublisherModel class]
             };
}

@end
