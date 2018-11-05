//
//  XLPostTableViewCell.h
//  NationalRedPacket
//
//  Created by Ying on 2018/7/11.
//  Copyright © 2018 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLPostAlertCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol XLPostAlertTableViewCellDelegate <NSObject>

- (void)didClickItem:(XLPostAlertCollectionViewCell *)item;

@end


@interface XLPostAlertTableViewCell : UITableViewCell

@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) NSArray *iconArray;
@property (weak, nonatomic) id<XLPostAlertTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
