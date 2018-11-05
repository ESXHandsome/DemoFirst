//
//  XLSaveVideoModel.h
//  NationalRedPacket
//
//  Created by Ying on 2018/7/11.
//  Copyright © 2018 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLSaveVideoModel : NSObject

@property (copy, nonatomic) NSString *videoURLString;

//原数据模型
@property (strong, nonatomic) XLFeedModel *originModel;

@end

NS_ASSUME_NONNULL_END
