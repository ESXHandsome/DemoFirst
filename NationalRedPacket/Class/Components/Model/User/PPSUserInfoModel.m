//
//  PPSUserInfoMode.m
//  NationalRedPacket
//
//  Created by Ying on 2018/3/22.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "PPSUserInfoModel.h"

@implementation PPSMyInfoModel

@end

@implementation PPSUserInfoModel

@end

@implementation PPSUserBalanceModel

@end
@implementation PPSShareConfigModel

@end
@implementation PPSinvitationLuckyMoneyModel

@end
@implementation PPSShareLuckyMoneyModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"shareConfig" : [PPSShareConfigModel class]};
}
@end
@implementation PPSTimeLuckyMoneyModel

@end
@implementation PPSSignLuckyMoneyModel

@end
