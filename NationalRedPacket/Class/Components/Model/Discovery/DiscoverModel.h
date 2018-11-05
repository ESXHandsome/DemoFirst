//
//  DiscoverModel.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/9.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PublisherModel, BannerModel;

@interface DiscoveryModel : NSObject

@property (copy, nonatomic)   NSString *p;
@property (strong, nonatomic) NSArray<PublisherModel *> *list;
@property (strong, nonatomic) NSArray<PublisherModel *> *card;
@property (strong, nonatomic) NSArray<BannerModel    *> *banner;

@end

@interface PublisherModel : NSObject

@property (copy, nonatomic) NSString *icon;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *fansCount;
@property (copy, nonatomic) NSString *authorId;

@end

@interface BannerModel : NSObject

@property (strong, nonatomic) NSArray<PublisherModel *> *authorList;
@property (copy, nonatomic) NSString *h5Url;
@property (copy, nonatomic) NSString *imageUrl;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *intro;
@property (copy, nonatomic) NSString *authorId;

@end



