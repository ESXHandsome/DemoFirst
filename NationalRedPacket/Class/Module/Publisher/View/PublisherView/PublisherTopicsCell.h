//
//  PublisherTopicsCell.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/10.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "BaseTableViewCell.h"

static NSString *const PublisherTopicsCellID = @"PublisherTopicsCellID";

@interface PublisherTopicsCell : BaseTableViewCell

- (void)configDelegateObject:(id)delegateObject;

/**
 根据数据源计算高度

 @param dataArray 数据源
 @return cell高度
 */
+ (CGFloat)getTopicsCellHeightWithDataArray:(NSArray *)dataArray;

@end
