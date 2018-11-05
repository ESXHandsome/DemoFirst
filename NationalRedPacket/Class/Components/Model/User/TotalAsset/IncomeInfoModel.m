//
//  IncomeInfoModel.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/22.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "IncomeInfoModel.h"

@implementation IncomeInfoModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSString *value = [NSString stringWithFormat:@"%@", dic[@"coin"]];
    if (![value isKindOfClass:[NSNull class]] && value.length != 0) {
        self.myCoin = value;
    }
    return YES;
}

@end
