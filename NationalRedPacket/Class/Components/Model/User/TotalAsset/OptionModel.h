//
//  OptionModel.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/26.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OptionListModel;

@interface OptionModel : NSObject

@property (copy, nonatomic) NSString *exchangeMode;
@property (strong, nonatomic) NSArray<OptionListModel *> *modeList;

@end

@interface OptionListModel : NSObject

@property (copy, nonatomic) NSString *money;
@property (copy, nonatomic) NSString *available;
@property (copy, nonatomic) NSString *exchangeMode;

@end
