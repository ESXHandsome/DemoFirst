//
//  UseInfoModel.m
//  LovePlayNews
//
//  Created by 刘永杰 on 2017/6/28.
//  Copyright © 2017年 sail. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"loginIncome":@"newLoginIncome",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"screenAd" : [ScreenAdModel class],
             @"attentionPageAd" : [AttentionPageAdModel class],
             @"hotPageAd" : [HotPageAdModel class],
             };
}

@end

@implementation ExchangePeopleNumModel

@end

@implementation LuckymoneyconfigModel

@end



@implementation CommonluckyModel

@end


@implementation LuckywaveModel

@end


@implementation LottertluckyModel

@end


@implementation Share_UrlModel

@end

@implementation ShareMode

@end

@implementation NewLoginIncome

@end

@implementation ScreenAdModel

@end

@implementation AttentionPageAdModel

@end

@implementation HotPageAdModel

@end


