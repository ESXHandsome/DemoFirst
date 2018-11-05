//
//  XLPublishApi.h
//  NationalRedPacket
//
//  Created by Ying on 2018/7/12.
//  Copyright © 2018 XLook. All rights reserved.
//

#import "BaseNetApi.h"

NS_ASSUME_NONNULL_BEGIN

#define URL_UPLOAD_PERSON_ITEM        URL_BASE@"/Item/itemUpload"
#define URL_DELETE_PERSON_ITEN        URL_BASE@"/Item/deleteMyUpload"

@interface XLPublishApi : BaseNetApi

+ (void)uploadPersonItem:(NSDictionary *)info success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)deletePersionItem:(NSDictionary *)info success:(SuccessBlock)success failure:(FailureBlock)failure;

@end

NS_ASSUME_NONNULL_END
