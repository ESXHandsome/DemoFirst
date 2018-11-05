//
//  XLSessionCommentContentModel.m
//  NationalRedPacket
//
//  Created by Ying on 2018/7/19.
//  Copyright © 2018 XLook. All rights reserved.
//

#import "XLSessionCommentContentModel.h"
#import "XLSessionCommentImageModel.h"

@implementation XLSessionCommentContentModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"image":[XLSessionCommentImageModel class]};
    
}
@end
