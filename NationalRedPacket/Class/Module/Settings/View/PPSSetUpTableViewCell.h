//
//  PPSSetUpTableViewCell.h
//  NationalRedPacket
//
//  Created by Ying on 2018/3/23.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPSSetUpTableViewCell : UITableViewCell
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *tailLabel;
-(void)setLabelLocation;
-(void)setTitleLabelText:(NSString *)title;
-(void)setTailLabelText:(NSString *)title;
-(void)setNewEditionLogo;
@end
