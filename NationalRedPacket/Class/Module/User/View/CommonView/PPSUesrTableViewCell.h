//
//  PPSUesrTableViewCell.h
//  NationalRedPacket
//
//  Created by Ying on 2018/3/21.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPSRedPoint.h"
@interface PPSUesrTableViewCell : UITableViewCell
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) PPSRedPoint *point;
@property (strong, nonatomic) UILabel *moneyLabel;
@property (strong, nonatomic) UIImageView *packetView;
@property (strong, nonatomic) UIImageView *tailImageView;
- (void)addRedPoint;
- (void)removeRedPoint;
- (void)addRedPacketView:(BOOL)redPoint;
- (void)redPacketViewShake;
- (void)initWithImageName:(NSString *)imageName labelText:(NSString *)labelText addRedPoint:(BOOL)addRedPoint;
- (void)initWithImage:(NSString*)imageName title:(NSString*)title;
- (void)noInvited;
- (void)chageState;
@end
