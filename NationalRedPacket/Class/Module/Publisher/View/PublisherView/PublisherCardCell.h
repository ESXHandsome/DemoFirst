//
//  PublisherCardCell.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/8.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChoicenessInfoHeaderView.h"
#import "XLPublisherProtocol.h"

@class PublisherCardCell;

@protocol PublisherCellDelegate <NSObject>

/**
 选择了发布者
 
 @param publisherCell 选中的cell
 @param model 发布者model
 */
- (void)didSelectPublisherCell:(id<XLPublisherProtocol>)publisherCell publisherModel:(XLPublisherModel *)model;

/**
 点击了发布者的关注按钮
 
 @param publisherCell cell
 @param model 发布者model
 */
- (void)didSelectPublisherCellFollowButton:(id<XLPublisherProtocol>)publisherCell publisherModel:(XLPublisherModel *)model;

@end

@interface PublisherCardCell : UICollectionViewCell<XLPublisherProtocol>

@property (weak, nonatomic) id<PublisherCellDelegate>delegate;

- (void)configModelData:(id)model indexPath:(NSIndexPath *)indexPath;

- (void)changeSubviewsLayout;

@end
