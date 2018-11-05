//
//  XLTextAndPictureAttachment.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/6/20.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLBaseCustomAttachment.h"

@interface XLTextAndPictureAttachment : XLBaseCustomAttachment

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *image;
@property (copy, nonatomic) NSString *subtitle;
@property (copy, nonatomic) NSString *url;

@end
