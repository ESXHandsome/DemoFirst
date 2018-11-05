//
//  PPSDAOBaseModel.h
//  NationalRedPacket
//
//  Created by 张子琦 on 27/01/2018.
//  Copyright © 2018 孙明悦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPSDAOBaseModel : NSObject
/// 映射是数据库内的主键，自增 ID
@property (assign, nonatomic) NSUInteger modelId;
@end
