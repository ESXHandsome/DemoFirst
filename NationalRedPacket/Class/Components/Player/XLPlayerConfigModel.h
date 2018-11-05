//
//  XLPlayerInfoModel.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/5/3.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLPlayerConfigModel : NSObject

@property (strong, nonatomic) NSURL   *videoURL;
@property (assign, nonatomic) CGFloat videoWidth;
@property (assign, nonatomic) CGFloat videoHeight;
@property (strong, nonatomic) UIView  *videoShowView;
@property (assign, nonatomic) NSInteger watchNum;
@property (copy  , nonatomic) NSString *duration;
@property (assign, nonatomic) double seekToTime;
@property (assign, nonatomic) BOOL shouldCache;
@property (assign, nonatomic) BOOL configNoMuteButton;
@property (strong, nonatomic) UIView  *displayViewFatherView;
/// 全屏时是否需要旋转
@property (assign, nonatomic) BOOL fullScreenShouldRotate;
/// 封面图URL
@property (strong, nonatomic) NSURL *coverImageURL;

@end
