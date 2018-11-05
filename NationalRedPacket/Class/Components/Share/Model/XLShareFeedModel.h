//
//  XLShareVideoModel.h
//  NationalRedPacket
//
//  Created by Ying on 2018/7/3.
//  Copyright © 2018 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLShareModelObservable.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLShareFeedModel : NSObject <XLShareModelDelegate>

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *feedUrl;
@property (copy, nonatomic) NSString *imageUrl;
@property (copy, nonatomic) NSString *feedType;
@property (copy, nonatomic) NSString *position;
//原数据模型
@property (strong, nonatomic) XLFeedModel *originModel;

@end

NS_ASSUME_NONNULL_END
