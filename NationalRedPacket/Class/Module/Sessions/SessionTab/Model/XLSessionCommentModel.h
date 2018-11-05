//
//  XLSessionCommentModel.h
//  NationalRedPacket
//
//  Created by Ying on 2018/7/19.
//  Copyright © 2018 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLFeedModel.h"
#import "XLSessionCommentContentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLSessionCommentModel : NSObject

@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *icon;
@property (copy, nonatomic) NSString *receiveType;
@property (copy, nonatomic) NSString *commentId;
@property (copy, nonatomic) NSString *secondCommentId;
@property (strong, nonatomic) XLFeedModel *item;
@property (copy, nonatomic) NSString *time;
@property (strong, nonatomic) XLSessionCommentContentModel *comment;



@end

NS_ASSUME_NONNULL_END
