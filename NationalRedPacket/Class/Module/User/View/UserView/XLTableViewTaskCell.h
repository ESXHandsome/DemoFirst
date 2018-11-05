//
//  PPSTableViewTaskCell.h
//  NationalRedPacket
//
//  Created by Ying on 2018/3/21.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>


@class XLTableViewTaskCell;
typedef enum{
    TableViewCellSignIn,
    TableViewCellShare
}PPSTableViewStyle;

@protocol PPSTableViewTaskCellDelegate <NSObject>
- (void)taskCellSignInButtonAction:(XLTableViewTaskCell*)cell;
- (void)taskCellShareButtonAction:(XLTableViewTaskCell*)cell;
@end

@interface XLTableViewTaskCell : UITableViewCell
@property (assign, nonatomic) BOOL buttonState;
@property (strong, nonatomic) UIButton *button;
@property (assign, nonatomic) NSInteger days;
@property (assign, nonatomic) PPSTableViewStyle tableViewStyle;
@property (strong, nonatomic) UILabel *shareLabel;
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic)   id<PPSTableViewTaskCellDelegate> delegate;
-(void)buildDailyTaskCell:(PPSTableViewStyle)tableViewStyle;
- (void)setLabelDays:(NSInteger)days;
- (void)signInButtonAction;
- (void)shareButtonAction;
@end
