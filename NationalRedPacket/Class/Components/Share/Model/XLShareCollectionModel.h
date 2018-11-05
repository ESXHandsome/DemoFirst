//
//  XLShareCollectionModel.h
//  NationalRedPacket
//
//  Created by Ying on 2018/7/4.
//  Copyright © 2018 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLShareCollectionModel : NSObject

@property (copy, nonatomic) NSString *itemID;
@property (copy, nonatomic) NSString *type;
@property (assign, nonatomic) BOOL isCollection;

//原数据模型
@property (strong, nonatomic) XLFeedModel *originModel;

@end

NS_ASSUME_NONNULL_END
