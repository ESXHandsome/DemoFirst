//
//  XLWebShareModel.h
//  NationalRedPacket
//
//  Created by Ying on 2018/6/22.
//  Copyright © 2018 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLWebShareModel : NSObject

/// 分享渠道：wechat_session、wechat_moments、qq_session、qq_zone
@property (copy, nonatomic) NSString *shareMode;
/// 分享内容形式：singleImage、singleLink
@property (copy, nonatomic) NSString *contentType;
/// 调用接口类型
@property (copy, nonatomic) NSString *connector;
/// 分享url
@property (copy, nonatomic) NSString *url;
/// 单图分享图片
@property (copy, nonatomic) NSString *img;
/// 链接分享标题
@property (copy, nonatomic) NSString *title;
/// 链接分享描述
@property (copy, nonatomic) NSString *content;

@end

