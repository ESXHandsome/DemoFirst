//
//  ShareConfigModel.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/3/26.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareConfigModel : NSObject

/// 分享渠道
@property (copy, nonatomic) NSString *shareMode;
/// 分享接口类型
@property (copy, nonatomic) NSString *connector;
/// 分享内容类型
@property (copy, nonatomic) NSString *contentType;
/// 分享图片地址
@property (copy, nonatomic) NSString *img;
/// 分享链接地址
@property (copy, nonatomic) NSString *url;
/// 分享文案
@property (copy, nonatomic) NSString *content;

@end
