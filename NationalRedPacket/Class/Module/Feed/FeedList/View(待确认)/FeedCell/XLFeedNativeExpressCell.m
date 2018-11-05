//
//  XLFeedNativeExpressCell.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/6/22.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLFeedNativeExpressCell.h"
#import "XLFeedAdNativeExpressModel.h"
#import "XLFeedAdNativeExpressModel.h"
#import "GDTNativeExpressAdView+Extention.h"

@interface XLFeedNativeExpressCell ()

@end

@implementation XLFeedNativeExpressCell

- (void)configModelData:(XLFeedModel *)model indexPath:(NSIndexPath *)indexPath {
    XLFeedAdNativeExpressModel *expressModel = model.nativeExpressModel;
    expressModel.expressAdView.frame = CGRectMake(0, 0, self.width, self.height - adaptHeight1334(20));
    [expressModel.expressAdView render];
  
  
    @weakify(self);
    expressModel.expressAdView.deleteBlock = ^{
        @strongify(self);

        if (self.deleteBlock) {
            self.deleteBlock();
        }
    };

    [self.contentView addSubview:expressModel.expressAdView];
}

@end
