//
//  XLDeleteFeedModel.h
//  NationalRedPacket
//
//  Created by Ying on 2018/7/11.
//  Copyright © 2018 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLDeleteFeedModel : NSObject

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSString *itemId;
@property (assign, nonatomic) NSInteger type;

@end

NS_ASSUME_NONNULL_END
