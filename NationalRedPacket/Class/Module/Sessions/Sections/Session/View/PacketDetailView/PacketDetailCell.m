//
//  XLRedPacketDetailViewController.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/5/29.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "PacketDetailCell.h"
#import "UIImageView+WebCache.h"
#import "NSDate+Timestamp.h"

@interface PacketDetailCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userAvator;
@property (weak, nonatomic) IBOutlet UILabel *userNickName;
@property (weak, nonatomic) IBOutlet UILabel *userGrabTime;
@property (weak, nonatomic) IBOutlet UILabel *userIncome;
@property (weak, nonatomic) IBOutlet UIButton *packetTypeButton;

@end

@implementation PacketDetailCell

- (void)awakeFromNib {
    _userAvator.layer.cornerRadius = 5;
    _userAvator.clipsToBounds = YES;
    [super awakeFromNib];
}

- (void)configModelData:(XLRedPacketDetailUserModel *)detailModel indexPath:(NSIndexPath *)indexPath {
    [_userAvator sd_setImageWithURL:[NSURL URLWithString:detailModel.avatar] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageProgressiveDownload];
    _userNickName.text = detailModel.name;
    _userGrabTime.text = [NSDate switchTimestamp:detailModel.time toFormatStr:@"HH:mm"] ;
    _userIncome.text = [NSString stringWithFormat:@"%@金币",detailModel.money];

    self.packetTypeButton.hidden = YES;
}

- (void)configBestOfLuckShow {
    self.packetTypeButton.hidden = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
