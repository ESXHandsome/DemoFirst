//
//  DiscoverModel.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/9.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLPublisherModel.h"

@class BannerModel;

@interface DiscoveryModel : NSObject

@property (copy, nonatomic)   NSString *p;
@property (strong, nonatomic) NSArray<XLPublisherModel *> *list;
@property (strong, nonatomic) NSArray<XLPublisherModel *> *card;
@property (strong, nonatomic) NSArray<BannerModel    *> *banner;

@end

@interface BannerModel : NSObject

@property (strong, nonatomic) NSArray<XLPublisherModel *> *authorList;
@property (copy, nonatomic) NSString *h5Url;
@property (copy, nonatomic) NSString *imageUrl;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *intro;
@property (copy, nonatomic) NSString *authorId;
@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) XLPublisherModel *authorInfo;

@end



