//
//  PublisherInfoCell.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/8.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "PublisherInfoCell.h"
#import "FollowButton.h"
#import "NSString+NumberAdapt.h"

@interface PublisherInfoCell () <FollowButtonDelegate>

@property (weak, nonatomic) IBOutlet UIImageView  *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel      *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel      *followNumberLabel;
@property (weak, nonatomic) IBOutlet UIView       *placeView;

@property (strong, nonatomic) XLPublisherModel      *tempModel;
@property (strong, nonatomic) FollowButton        *followButton;

@end

@implementation PublisherInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.avatarImageView.layer.cornerRadius = adaptHeight1334(52);
    self.avatarImageView.layer.masksToBounds = YES;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:@"http://crawler.lingyongqian.cn/2ed1e68c772711c6b2e1e394982fb9ce.png"]];
    self.avatarImageView.layer.borderWidth = 0.5;
    self.avatarImageView.layer.borderColor = [UIColor colorWithString:COLORE8E8E8].CGColor;
    
    self.followButton = [FollowButton buttonWithType:FollowButtonTypePersonal];
    self.followButton.delegate = self;
    self.followButton.titleFont = [UIFont boldSystemFontOfSize:adaptFontSize(12*2)];
    [self.contentView addSubview:self.followButton];
    [self.followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.placeView);
    }];
}

- (void)configModelData:(XLPublisherModel *)model indexPath:(NSIndexPath *)indexPath
{
    self.tempModel = model;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"my_avatar"]];
    self.avatarImageView.backgroundColor = [UIColor whiteColor];
    self.nameLabel.text = model.nickname;
    self.followNumberLabel.text = [NSString stringWithFormat:@"%@人关注",[NSString numberAdaptWithInteger:model.fansCount]];
    self.followButton.followed = self.tempModel.isFollowed;
}

/**
 更新关注按钮状态及关注数UI
 */
- (void)updateFollowInfo
{
    self.followButton.followed = self.tempModel.isFollowed;
    [self.followButton stopAnimation];
    self.followNumberLabel.text = [NSString stringWithFormat:@"%@人关注",[NSString numberAdaptWithInteger:self.tempModel.fansCount]];
}

- (void)followButtonClick:(FollowButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectPublisherCellFollowButton:publisherModel:)]) {
        [self.delegate didSelectPublisherCellFollowButton:self publisherModel:self.tempModel];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
