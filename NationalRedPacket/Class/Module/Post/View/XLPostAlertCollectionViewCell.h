//
//  XLPostAlertCollectionViewCell.h
//  NationalRedPacket
//
//  Created by Ying on 2018/7/11.
//  Copyright © 2018 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol  XLPostAlertCollectionViewCellDelegate <NSObject>

- (void)didSelectButton:(NSString *)sign;

@end

@interface XLPostAlertCollectionViewCell : UICollectionViewCell


@property (strong, nonatomic) UIButton *button;
@property (assign, nonatomic) BOOL hasLabel;
@property (copy, nonatomic) NSString *title;
@property (weak, nonatomic) id<XLPostAlertCollectionViewCellDelegate> delegate;

- (void)configCell:(UIImage *)image labelTitle:(NSString *)titleText;

@end

NS_ASSUME_NONNULL_END
