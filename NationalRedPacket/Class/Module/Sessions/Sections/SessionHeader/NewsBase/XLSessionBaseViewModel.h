//
//  XLSessionBaseViewModel.h
//  NationalRedPacket
//
//  Created by Ying on 2018/5/28.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XLSessionBaseViewModelDelegate <NSObject>


/**
 加载完成
 */
- (void)loadFinish;

/**
 刷新完成
 */
- (void)refreshFinish;

@end

@interface XLSessionBaseViewModel : NSObject

@property (weak, nonatomic) id<XLSessionBaseViewModelDelegate> baseDelegate;

/**
 加载更多
 */
- (void)loadMore;

/**
 刷新
 */
- (void)refresh;

@end
