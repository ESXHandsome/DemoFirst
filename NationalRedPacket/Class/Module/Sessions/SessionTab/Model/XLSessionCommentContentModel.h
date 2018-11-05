//
//  XLSessionCommentContentModel.h
//  NationalRedPacket
//
//  Created by Ying on 2018/7/19.
//  Copyright © 2018 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLSessionCommentImageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XLSessionCommentContentModel : NSObject

@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSArray *image;
@end

NS_ASSUME_NONNULL_END
