//
//  XLSessionBaseTableViewCell.m
//  NationalRedPacket
//
//  Created by Ying on 2018/5/28.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLSessionBaseTableViewCell.h"

@interface XLSessionBaseTableViewCell()
@property (strong, nonatomic) UILabel *tailLabel;
@property (strong, nonatomic) UILabel *shadowLabel;
@property (strong, nonatomic) UIImageView *authorView;
@property (strong, nonatomic) UILabel *authorNameLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) FollowButton *button;
@end

@implementation XLSessionBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)cellSetImage:(UIImage *)image authorName:(NSString *)authorName tailString:(NSString *)tailString buttonTitle:(NSString *)buttonTitle {
    /*添加视图到cell*/
    [self addSubview:self.authorView];
    [self addSubview:self.authorNameLabel];
    [self addSubview:self.button];
    [self addSubview:self.dateLabel];
    [self addSubview:self.shadowLabel];
    
    /*拼接字符串*/
    NSString *authorString = [authorName stringByAppendingString:@" "];
    authorString = [authorString stringByAppendingString:tailString];
    /*赋值*/
    self.authorView.image = image;
    /*这不是要一段字符串两个色吗!*/
    self.authorNameLabel.attributedText = [self changeStringFont:authorString];
  
    /*调整布局*/
    [self.authorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).mas_offset(adaptHeight1334(16*2));
        make.left.equalTo(self.mas_left).mas_offset(adaptWidth750(17*2));
    }];
    
    [self.authorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.authorView.mas_right).mas_offset(adaptWidth750(13*2));
        make.top.equalTo(self).mas_offset(adaptHeight1334(20*2));
        make.right.equalTo(self).mas_equalTo(-adaptWidth750(76*2));
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.authorNameLabel);
        make.top.equalTo(self.authorNameLabel.mas_bottom).mas_offset(adaptHeight1334(7*2));
    }];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).mas_offset(adaptHeight1334(19*2));
        make.right.equalTo(self).mas_offset(adaptWidth750(-12*2));
        make.height.mas_equalTo(adaptHeight1334(25*2));
        make.width.mas_equalTo(adaptWidth750(60*2));
    }];
    
    [self.shadowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self);
        make.left.equalTo(self).mas_offset(adaptWidth750(72*2));
        make.height.mas_equalTo(0.5);
    }];
}

/*把拼出的字符串,调整一下格式*/
- (NSMutableAttributedString *)changeStringFont:(NSString *)string {
    NSRange range = [string rangeOfString:@" "];
    NSInteger startIndex = range.location;
    NSInteger endIndex = string.length - range.location;
    range = NSMakeRange(startIndex, endIndex);
    NSMutableAttributedString *returnString = [[NSMutableAttributedString alloc] initWithString:string];
    [returnString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithString:COLOR151515] range:range];
    UIFont *labelFont = [UIFont systemFontOfSize:adaptFontSize(15*2)];
    [returnString addAttribute:NSFontAttributeName value:labelFont range: range];
    return returnString;
}

/*这个是tableView的分割线,最后一个需要隐藏一下*/
- (void)hiddenShadow {
    self.shadowLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - lazy load
- (UIImageView *)authorView {
    if (!_authorView) {
        _authorView = [[UIImageView alloc] init];
        _authorView.layer.cornerRadius = adaptHeight1334(40*2);
    }
    return _authorView;
}

- (UILabel *)authorNameLabel {
    if (!_authorNameLabel) {
        _authorNameLabel = [UILabel labWithText:@"IEif即将" fontSize:adaptFontSize(15*2) textColorString:COLOR406599];
        _authorNameLabel.font = [UIFont boldSystemFontOfSize:adaptFontSize(15*2)];
        _authorNameLabel.numberOfLines = 0;
    }
    return _authorNameLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [UILabel labWithText:@"20:15" fontSize:adaptFontSize(12*2) textColorString:COLORA7A7A7];
    }
    return _dateLabel;
}

- (FollowButton *)button {
    if (!_button) {
        _button = [FollowButton buttonWithType:FollowButtonTypePersonal];
    }
    return _button;
}

- (UILabel *)shadowLabel {
    if (!_shadowLabel) {
        _shadowLabel = [[UILabel alloc] init];
        _shadowLabel.backgroundColor = [UIColor colorWithString:COLORE6E6E6];
    }
    return _shadowLabel;
}
@end
