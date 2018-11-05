//
//  LaunchTool.h
//  NationalRedPacket
//
//  Created by Ying on 2018/4/12.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol LaunchViewModelDelegate <NSObject>
- (void)finishToFetchData;
- (void)pushRecommendViewController;
@end

@interface LaunchViewModel : NSObject
@property (weak, nonatomic) id<LaunchViewModelDelegate> delegate;

/**
 重置window的RootViewController
 */
- (void)resetWindowRootViewController;

/**
 开始启动配置
 */
- (void)startConfig;

/**
 重置RootViewController之前的操作
 */
- (void)prepareToResetRootViewController;
@end
