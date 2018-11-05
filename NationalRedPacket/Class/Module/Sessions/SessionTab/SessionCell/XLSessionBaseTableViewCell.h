//
//  XLSessionBaseTableViewCell.h
//  NationalRedPacket
//
//  Created by Ying on 2018/5/28.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FollowButton.h"
@protocol XLSessionBaseTableViewCellDelegate <NSObject>
- (void)didSelectFollowButton;
@end

@interface XLSessionBaseTableViewCell : UITableViewCell

@property (copy, nonatomic) NSString *authorID;
@property (weak, nonatomic) id<XLSessionBaseTableViewCellDelegate> delegate;

/**
 隐藏分割线
 */
- (void)hiddenShadow;

/**
 配置cell

 @param imageUrlString 显示的头像
 @param authorName 用户名称
 @param tailString 追加字符串
 @param buttonTitle 按钮的显示状态
 @param dateLabel 显示日期
 */
- (void)cellSetImage:(NSString *)imageUrlString authorName:(NSString *)authorName tailString:(NSString *)tailString buttonTitle:(NSString *)buttonTitle dateLabel:(NSString *)dateLabel;

- (void)changeButtonState;
@end
