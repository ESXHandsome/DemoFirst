//
//  FollowHeaderView.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/1/26.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "NavigationBarFollowView.h"
#import "NSString+NumberAdapt.h"

@interface NavigationBarFollowView ()

@property (strong, nonatomic) UIImageView  *iconImageView;
@property (strong, nonatomic) UILabel      *nameLabel;
@property (strong, nonatomic) UILabel      *followLabel;

@end

@implementation NavigationBarFollowView

- (void)setupViews
{
    self.frame = CGRectMake(adaptWidth750(88), 0, SCREEN_WIDTH-adaptWidth750(88)*2, 44);

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
    
    self.iconImageView = [UIImageView new];
    self.iconImageView.layer.cornerRadius = 37/2.0;
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [backButton addSubview:self.iconImageView];
    
    self.nameLabel = [UILabel labWithText:@"小小娱乐世界" fontSize:14 textColorString:COLOR333333];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:14];
    [backButton addSubview:self.nameLabel];
    
    self.followLabel = [UILabel labWithText:@"827粉丝" fontSize:12 textColorString:COLOR999999];
    [backButton addSubview:self.followLabel];
    
    self.followButton = [FollowButton buttonWithType:FollowButtonTypePersonal];
    self.followButton.titleFont = [UIFont fontWithName:@"PingFang-SC-Medium" size:adaptFontSize(25)];
    
    [self addSubview:self.followButton];
    
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.height.mas_equalTo(37);
        make.centerY.equalTo(self);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(adaptWidth750(18));
        make.top.equalTo(self).offset(7);
        make.right.equalTo(backButton);
    }];
    
    [self.followLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.right.equalTo(backButton);
    }];
    
    [self.followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-adaptWidth750(18));
        make.width.mas_equalTo(adaptWidth750(48*2));
        make.height.mas_equalTo(25);
        make.centerY.equalTo(self);
    }];
    
}

- (void)buttonAction:(UIButton *)sender
{
    if (self.backResult) {
        self.backResult(0);
    }
}

- (void)setTransparency:(BOOL)transparency {
    _transparency = transparency;
    
    self.nameLabel.textColor = [UIColor colorWithString:transparency ? COLORffffff : COLOR333333];
    self.followLabel.textColor = [UIColor colorWithString:transparency ? COLORffffff : COLOR212221];
    self.followButton.followedTitleColor = [UIColor colorWithString:transparency ? COLORffffff : COLORCFCFCF];
    self.followButton.followedActivityColor = transparency ? [UIColor whiteColor] : [UIColor grayColor];
}

- (void)setModel:(XLFeedModel *)model
{
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"my_avatar"]];
    self.nameLabel.text = model.nickname;
    self.followLabel.text = [NSString stringWithFormat:@"%@粉丝",[NSString numberAdaptWithInteger:model.fansCount]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
