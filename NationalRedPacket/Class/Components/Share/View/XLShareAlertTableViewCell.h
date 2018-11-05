//
//  XLShareAlertTableViewCell.h
//  NationalRedPacket
//
//  Created by Ying on 2018/7/2.
//  Copyright © 2018 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLShareAlertCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol XLShareAlertTableViewCellDelegate <NSObject>

- (void)didClickItem:(XLShareAlertCollectionViewCell *)item;

@end

@interface XLShareAlertTableViewCell : UITableViewCell

@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) NSArray *iconArray;
@property (weak, nonatomic) id<XLShareAlertTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
