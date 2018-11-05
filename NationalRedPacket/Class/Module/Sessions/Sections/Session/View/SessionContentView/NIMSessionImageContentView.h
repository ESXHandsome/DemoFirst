//
//  NIMSessionImageContentView.h
//  NIMKit
//
//  Created by chris on 15/1/28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NIMSessionMessageContentView.h"
#import <FLAnimatedImage/FLAnimatedImage.h>

@interface NIMSessionImageContentView : NIMSessionMessageContentView

@property (nonatomic,strong,readonly) FLAnimatedImageView * imageView;

@end
