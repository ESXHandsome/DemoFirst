//
//  XLPostViewModel.m
//  NationalRedPacket
//
//  Created by Ying on 2018/7/11.
//  Copyright © 2018 XLook. All rights reserved.
//

#import "XLPostAlertViewModel.h"

@implementation XLPostAlertViewModel

- (void)chooseToOpen:(NSString *)sign {
    if ([sign isEqualToString:@"图片"]) {
        [self.delegate openPhotoLibrary];
    } else if ([sign isEqualToString:@"视频"]) {
        [self.delegate openVideoLibrary];
    } else {
        
    }
}


@end
