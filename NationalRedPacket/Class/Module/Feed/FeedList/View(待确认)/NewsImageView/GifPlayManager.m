//
//  GifPlayManager.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/2.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "GifPlayManager.h"
#import "XLPlayer.h"

@interface GifPlayManager ()

@property (strong, nonatomic) NSIndexPath *tempIndexPath;
@property (strong, nonatomic) XLFeedModel *tempModel;

@end

@implementation GifPlayManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static GifPlayManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [GifPlayManager new];
    });
    return manager;
}

//播放
- (void)playGifCell
{
    if (XLPlayer.sharedInstance.isPlaying) {
        return;
    }
    FeedImagesCell *playCell = [self getWillPlayGifCell:self.currentTableView];
    if (playCell && !playCell.containerView.isPlaying) {
        playCell.containerView.isPlaying = YES;
        [playCell.containerView playGifImageViewWithNumber:0];
    }
}

//暂停
- (void)pauseGifCell
{
    [self.playingGifCell.containerView stopPlayGifImageView];
}

//重启（重新启动）
- (void)rebootGifCell
{
    if (XLPlayer.sharedInstance.isPlaying) {
        return;
    }
    if (self.playingGifCell != nil && !self.playingGifCell.containerView.isAllCellCanNotPlay && self.playingGifCell.containerView.isPlaying) {
        [self.playingGifCell.containerView rebootPlayGifImageView];
    }
    
}

#pragma mark - private methods

- (FeedImagesCell *)getWillPlayGifCell:(UITableView *)tableView;
{
    //如果正在目前的cell在可播放范围内就返回当前cell
    if (self.playingGifCell != nil && !self.playingGifCell.containerView.isAllCellCanNotPlay) {
        return self.playingGifCell;
    } else {
        self.playingGifCell.containerView.isPlaying = NO;
        [self.playingGifCell.containerView stopPlayGifImageView];
    }
    
    NSMutableArray *visiableCells = [NSMutableArray arrayWithArray:[tableView visibleCells]];
    if (visiableCells.count == 0) return nil;
    
    for (int i = 0; i < visiableCells.count; i++) {
        
        FeedImagesCell *cell = visiableCells[i];
        
        if ([cell isKindOfClass:[FeedImagesCell class]] && !cell.containerView.isAllCellCanNotPlay) {
            cell.containerView.isPlaying = NO;
            self.playingGifCell = cell;
            return cell;
        }
    }
    return nil;
}

#pragma mark - StatMethods
//获取 屏幕占比最大的 Cell
- (FeedImagesCell *)getHightestProportionImagesCell:(UITableView *)tableView
{
    NSMutableArray *visiableCells = [NSMutableArray arrayWithArray:[tableView visibleCells]];
    if (visiableCells.count == 0) return nil;
    
    FeedImagesCell *tempCell;
    CGFloat tempScale = 0;
    for (int i = 0; i < visiableCells.count; i++) {
        
        FeedImagesCell *imageCell = visiableCells[i];
        CGRect imageCellRect = [imageCell.superview convertRect:imageCell.frame toView:[UIApplication sharedApplication].keyWindow];
        
        CGFloat cellHeight = 0.0;
        if (imageCellRect.origin.y < 0) {
            cellHeight = imageCellRect.size.height + imageCellRect.origin.y;
        } else if (imageCellRect.origin.y + imageCellRect.size.height > SCREEN_HEIGHT) {
            cellHeight = SCREEN_HEIGHT - imageCellRect.origin.y;
        } else {
            cellHeight = imageCellRect.size.height;
        }
        CGFloat scale = cellHeight / SCREEN_HEIGHT;
        if (scale > tempScale) {
            tempCell = imageCell;
            tempScale = scale;
        }
    }
    return tempCell;
}

- (void)statImagesCell
{
    FeedImagesCell *imagesCell = [self getHightestProportionImagesCell:self.currentTableView];

    if (self.tempIndexPath == nil) {
        if ([imagesCell isKindOfClass:[FeedImagesCell class]]) {
            self.tempIndexPath = [self.currentTableView indexPathForCell:imagesCell];
            self.tempModel = imagesCell.tempModel;
            [StatServiceApi statEventBegin:IMAGE_STAY_DURATION model:self.tempModel];
        } else {
            self.tempIndexPath = nil;
        }
    } else {
        if ([self.currentTableView indexPathForCell:imagesCell] != self.tempIndexPath) {
            [StatServiceApi statEventEnd:IMAGE_STAY_DURATION model:self.tempModel];
            if ([imagesCell isKindOfClass:[FeedImagesCell class]]) {
                self.tempIndexPath = [self.currentTableView indexPathForCell:imagesCell];
                self.tempModel = imagesCell.tempModel;
                [StatServiceApi statEventBegin:IMAGE_STAY_DURATION model:self.tempModel];
            } else {
                self.tempIndexPath = nil;
            }
        }
    }
}

- (void)statEndImageCell {
    if (self.tempModel && self.tempIndexPath) {
        [StatServiceApi statEventEnd:IMAGE_STAY_DURATION model:self.tempModel];
        self.tempIndexPath = nil;
    }
}

- (void)currentTableViewDidScroll {
    
    if ([self.scrollTarget respondsToSelector:self.scrollAction]) {
        MJRefreshMsgSend(MJRefreshMsgTarget(self.scrollTarget), self.scrollAction, self.currentTableView);
    }
}

@end
