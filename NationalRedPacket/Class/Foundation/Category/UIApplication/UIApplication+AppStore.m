//
//  UIApplication+AppStore.m
//  NationalRedPacket
//
//  Created by fensi on 2018/4/4.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "UIApplication+AppStore.h"
#import <StoreKit/StoreKit.h>

@implementation UIApplication (AppStore)

+ (void)commentInAppStore:(NSString *)AppStoreAppID {
    NSString *str = nil;
    if (@available(iOS 10.3, *)) {
        if([SKStoreReviewController respondsToSelector:@selector(requestReview)]){
            [SKStoreReviewController requestReview];
        }else{
            str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/twitter/id%@?mt=8&action=write-review", AppStoreAppID];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    } else {
        str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", AppStoreAppID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    
}

@end
