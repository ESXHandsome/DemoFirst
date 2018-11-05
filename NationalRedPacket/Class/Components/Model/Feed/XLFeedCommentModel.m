//
//  XLFeedCommentModel.m
//  NationalRedPacket
//
//  Created by 王海玉 on 2017/11/16.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "XLFeedCommentModel.h"

@implementation XLFeedCommentModel

+(NSDictionary *)modelCustomPropertyMapper{
    return @{@"commentId": @"id",
             @"secondaryCommentTotalCount" : @"secondCommentCount",
             @"secondaryComments" : @"secondComment"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"images" : [ImageModel class],
             @"secondaryComments" : [XLFeedCommentModel class]
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSString *value = dic[@"content"];
    if ([value length] > 100) {
        self.hundredContent = [[value substringToIndex:100] stringByAppendingString:@"...全文"];
    }
    return YES;
}

@end
