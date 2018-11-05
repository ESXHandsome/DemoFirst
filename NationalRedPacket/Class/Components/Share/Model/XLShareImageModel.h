//
//  XLShareImageModel.h
//  NationalRedPacket
//
//  Created by Ying on 2018/7/3.
//  Copyright © 2018 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLShareModelObservable.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLShareImageModel : NSObject <XLShareModelDelegate>

@property (copy, nonatomic) NSString *image; ///图片地址
@property (copy, nonatomic) NSString *url;   ///跳转地址

@end

NS_ASSUME_NONNULL_END
