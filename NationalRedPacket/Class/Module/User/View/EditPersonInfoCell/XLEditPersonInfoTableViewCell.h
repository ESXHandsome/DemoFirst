//
//  XLEditPersonInfoTableViewCell.h
//  NationalRedPacket
//
//  Created by Ying on 2018/7/27.
//  Copyright © 2018 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XLEditPersonInfoTableViewCellDelegate <NSObject>

- (void)textFieldDidBeginEdit;

- (void)textFieldDidFinidh:(NSString *)string;

- (void)nameFieldDidFinish:(NSString *)name;
- (void)introFieldDidFinish:(NSString *)intro;
- (void)changeSexFinish:(NSString *)sex;
@end

NS_ASSUME_NONNULL_BEGIN

@interface XLEditPersonInfoTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *tailLabel;

@property (weak, nonatomic) id<XLEditPersonInfoTableViewCellDelegate> delegate;

- (void)configTableViewCell:(PPSMyInfoModel *)model title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
