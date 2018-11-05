//
//  XLShareURLModel.h
//  NationalRedPacket
//
//  Created by Ying on 2018/7/3.
//  Copyright © 2018 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLShareModelObservable.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLShareURLModel : NSObject <XLShareModelDelegate>

@property (copy, nonatomic) NSString *title;   ///标题
@property (copy, nonatomic) NSString *content; ///内容
@property (copy, nonatomic) NSString *url;     ///地址
@property (copy, nonatomic) NSString *image;   ///图像

@end

NS_ASSUME_NONNULL_END
