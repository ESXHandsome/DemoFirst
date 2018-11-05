//
//  XLSessionBaseViewModel.h
//  NationalRedPacket
//
//  Created by Ying on 2018/5/28.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLSessionMessageModel.h"

@protocol XLSessionBaseViewModelDelegate <NSObject>


/**
 加载完成
 */
- (void)loadFinish;

/**
 刷新完成
 */
- (void)refreshFinish;

/**
 网络请求数据为空
 */
- (void)emptyDate;

/**
 删除加载视图
 */
- (void)removeLoadView;
- (void)findAuthor:(NSString *) authorId;
- (void)defindAuthor;
@end

@interface XLSessionBaseViewModel : NSObject

@property (weak, nonatomic) id<XLSessionBaseViewModelDelegate> baseDelegate;
@property (strong, nonatomic) NSArray *sessionMessageArray;
@property (assign, nonatomic) NSInteger type;

/**
 加载更多
 */
- (void)loadMore;

/**
 刷新
 */
- (void)refresh;

/**
 是否存在此用户
 */
- (void)isHadAuthor:(NSString *)authorld;


- (BOOL)authorIdFollowedExtra:(NSString *)authorId extra:(NSString *)extra;
@end
