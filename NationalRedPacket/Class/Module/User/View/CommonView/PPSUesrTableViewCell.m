//
//  PPSUesrTableViewCell.m
//  NationalRedPacket
//
//  Created by Ying on 2018/3/21.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "PPSUesrTableViewCell.h"
@interface PPSUesrTableViewCell()
@property (strong, nonatomic) UILabel *label;
@end

@implementation PPSUesrTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.height = adaptHeight1334(46*2);
    self.titleLabel = [UILabel new];
    self.iconImageView = [UIImageView new];
    self.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(17*2)];
    self.iconImageView.frame = CGRectMake(adaptWidth750(13.6*2), adaptHeight1334(16*2), adaptWidth750(21*2), adaptHeight1334(21*2));
    self.titleLabel.frame = CGRectMake(adaptWidth750(49*2), adaptHeight1334(14*2), adaptWidth750(200*2),adaptHeight1334(24*2) );
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.tailImageView];
    [self.tailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).mas_offset(adaptHeight1334(15*2));
        make.right.equalTo(self.mas_right).mas_offset(-adaptWidth750(13.6*2));
        make.width.mas_equalTo(adaptWidth750(8.4*2));
        make.height.mas_equalTo(adaptHeight1334(14.4*2));
    }];
    return self;
}

- (void)initWithImageName:(NSString *)imageName labelText:(NSString *)labelText addRedPoint:(BOOL)addRedPoint{
    self.titleLabel.text = labelText;       
    CGSize sizeNew = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
    self.titleLabel.frame = CGRectMake(adaptWidth750(49*2), adaptHeight1334(14*2), sizeNew.width, sizeNew.height);
    self.titleLabel.centerY = self.height/2;
    UIImage *image  = [UIImage imageNamed:imageName];
    self.iconImageView.size = CGSizeMake(image.size.width, image.size.height);
    self.iconImageView.image = image;
    self.iconImageView.centerY = self.height/2;
    self.iconImageView.centerX = adaptWidth750(24.5*2);

    if(addRedPoint)
        [self addRedPoint];
}

- (void)noInvited{
    _label = [UILabel labWithText:@"今日邀请已达到上限" fontSize:adaptFontSize(14*2) textColorString:@"#8C8C8C"];
    CGSize size = [_label.text sizeWithAttributes:@{NSFontAttributeName:_label.font}];
    _label.size = size;
    _label.y = adaptHeight1334(17*2);
    _label.x = adaptWidth750(205*2);
    [self addSubview:_label];
}
- (void)chageState{
    [_label removeFromSuperview];
    [_moneyLabel removeFromSuperview];
    [_packetView removeFromSuperview];
    [_point removeFromSuperview];
    
}
- (void)addRedPacketView:(BOOL)redPoint{
    _label = [UILabel labWithText:@"邀请好友，赚" fontSize:adaptFontSize(13*2) textColorString:@"#8C8C8C"];
    CGSize size = [_label.text sizeWithAttributes:@{NSFontAttributeName:_label.font}];
    _label.frame = CGRectMake(adaptWidth750(196*2), adaptHeight1334(14*2), size.width, size.height);
    _label.centerY = self.height/2;
    [self addSubview:_label];
    
    _moneyLabel = [UILabel labWithText:[NSString stringWithFormat:@"3元"] fontSize:adaptFontSize(13*2) textColorString:@"#F3494F"];
    CGSize moneyLabelSize = [_moneyLabel.text sizeWithAttributes:@{NSFontAttributeName:_moneyLabel.font}];
    _moneyLabel.frame = CGRectMake(adaptWidth750(275*2), adaptWidth750(14*2), moneyLabelSize.width, moneyLabelSize.height);
    _moneyLabel.centerY = self.height/2;
    [self addSubview:_moneyLabel];
    
    _packetView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chai"]];
    _packetView.frame = CGRectMake(adaptWidth750(302*2), adaptHeight1334(9.5*2), _packetView.image.size.width, _packetView.image.size.height);
    _packetView.centerY = self.height/2;
    [self addSubview:_packetView];
    
    if(redPoint){
        _point = [[PPSRedPoint alloc] init];
        _point.center = CGPointMake(_packetView.x+_packetView.width + adaptWidth750(7), _packetView.y-adaptHeight1334(7));
        [self addSubview:_point];
    }
//    [self redPacketViewShake];
}

- (void)redPacketViewShake{
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    shake.fromValue = [NSNumber numberWithFloat:0];
    shake.toValue = [NSNumber numberWithFloat:-M_PI/6];
    shake.duration = 0.3;
    shake.autoreverses = YES;
    shake.repeatCount = 2;
    [_packetView.layer addAnimation:shake forKey:@"shakeAnimation"];
}

- (void)addRedPoint{
    _point = [[PPSRedPoint alloc] init];
    _point.center = CGPointMake(self.titleLabel.x + self.titleLabel.width + adaptWidth750(7*2), self.titleLabel.y);
    [self addSubview:_point];
}

- (void)removeRedPoint{
    [_point removePoint];
}

- (void)initWithImage:(NSString*)imageName title:(NSString*)title{
    self.iconImageView.image = [UIImage imageNamed:imageName];
    self.titleLabel.text = title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIImageView *)tailImageView {
    if (!_tailImageView) {
        _tailImageView = [[UIImageView alloc] init];
        _tailImageView.image = [UIImage imageNamed:@"my_return"];
    }
    return _tailImageView;
}

@end
