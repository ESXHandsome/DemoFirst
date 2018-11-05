//
//  ShareImageTool.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/13.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImage+YJExtension.h"
@interface ShareImageTool : NSObject

+ (UIImage *)createShareImageWithUrl:(NSString *)urlStr image:(UIImage *)sourceImage;

+ (UIImage *)createSuccessShareImageWithUrl:(NSString *)urlStr isFiftyMoney:(BOOL)isFiftyMoney;

@end
