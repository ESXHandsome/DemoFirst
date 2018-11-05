//
//  XLGroupPicturesAttachment.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/6/20.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLBaseCustomAttachment.h"
#import "XLActivityLinkModel.h"

@interface XLGroupPicturesAttachment : XLBaseCustomAttachment

@property (strong, nonatomic) NSArray<XLActivityLinkModel *> *list;

@end
