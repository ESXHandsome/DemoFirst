//
//  GifPlayManager.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/2.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedImagesCell.h"

@interface GifPlayManager : NSObject

@property (strong, nonatomic) FeedImagesCell *playingGifCell;

@property (strong, nonatomic) UITableView *currentTableView;

//设置target和action来时tableView滚动时，对应target方法执行
@property (weak, nonatomic)    id scrollTarget;
@property (assign, nonatomic) SEL scrollAction;

+ (instancetype)sharedManager;

//开始播放
- (void)playGifCell;

//暂停
- (void)pauseGifCell;

//重启（重新启动）
- (void)rebootGifCell;

//目前的tableView正在滚动
- (void)currentTableViewDidScroll;

- (void)statImagesCell;

- (void)statEndImageCell;

@end
