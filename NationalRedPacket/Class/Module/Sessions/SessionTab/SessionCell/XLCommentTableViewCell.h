//
//  XLCommentTableViewCell.h
//  NationalRedPacket
//
//  Created by Ying on 2018/7/19.
//  Copyright © 2018 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
#import "XLSessionCommentModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol XLCommentTableViewCellDelegate <NSObject>
@optional;
- (void)clickShowPictureText:(XLSessionCommentImageModel *)model imageView:(UIImageView *)imageView;

- (void)pushPublisherController:(XLSessionCommentModel *)model;

@end

@interface XLCommentTableViewCell : BaseTableViewCell
@property (weak, nonatomic) id<XLCommentTableViewCellDelegate> delegate;
- (void)configHigh:(id)model;
@property (assign, nonatomic) BOOL isLikedView;
@end

NS_ASSUME_NONNULL_END
