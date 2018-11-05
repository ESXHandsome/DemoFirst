//
//  OptionModel.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/26.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "OptionModel.h"

@implementation OptionModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"modeList" : [OptionListModel class]};
}

@end

@implementation OptionListModel

@end
