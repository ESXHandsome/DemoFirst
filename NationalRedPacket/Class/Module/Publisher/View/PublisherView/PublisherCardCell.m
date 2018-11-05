//
//  PublisherCardCell.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/8.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "PublisherCardCell.h"
#import "FollowButton.h"
#import "NSString+NumberAdapt.h"
#import "NSString+Height.h"

@interface PublisherCardCell ()<FollowButtonDelegate>

@property (weak, nonatomic) IBOutlet UIImageView        *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel            *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel            *followNumberLabel;
@property (weak, nonatomic) IBOutlet UIView             *placeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarTopLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelWidthLayout;

@property (strong, nonatomic) FollowButton              *followButton;
@property (strong, nonatomic) XLPublisherModel            *tempModel;

@end

@implementation PublisherCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 5;
    self.layer.borderColor = [UIColor colorWithString:COLOREDEDED].CGColor;
    
    self.avatarImageView.layer.cornerRadius = adaptHeight1334(68);
    self.avatarImageView.layer.masksToBounds = YES;
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
    
    if ([NSString heightWithString:model.nickname fontSize:adaptFontSize(30) lineSpacing:adaptHeight1334(6) maxWidth:adaptWidth750(103*2)] < adaptHeight1334(30*2)) {
        model.nickname = [model.nickname stringByAppendingString:@"\n"];
    }
    self.nameLabel.text = model.nickname.length != 0 ? model.nickname : @"我是名字";
    self.followNumberLabel.text = [NSString stringWithFormat:@"%@人关注",[NSString numberAdaptWithInteger:model.fansCount]];
    self.followButton.followed = self.tempModel.isFollowed;
}

- (void)changeSubviewsLayout
{
    self.layer.borderWidth = 0;
    self.layer.cornerRadius = 0;
    self.avatarTopLayout.constant = 30;
    self.nameLabelWidthLayout.constant = 100;
    self.nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:adaptFontSize(30)];
    self.nameLabel.numberOfLines = 2;
    self.followNumberLabel.hidden = YES;
    self.followButton.titleFont = [UIFont boldSystemFontOfSize:adaptFontSize(13*2)];
    
    [self.placeView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(adaptHeight1334(12*2));
    }];
    
    [self.followButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.placeView).offset(adaptHeight1334(10));
        make.width.mas_equalTo(adaptWidth750(58*2));
        make.centerX.equalTo(self.placeView);
        make.bottom.equalTo(self.placeView).offset(adaptHeight1334(10));
    }];
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

@end
