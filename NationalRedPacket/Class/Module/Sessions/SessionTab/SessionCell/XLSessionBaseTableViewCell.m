//
//  XLSessionBaseTableViewCell.m
//  NationalRedPacket
//
//  Created by Ying on 2018/5/28.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLSessionBaseTableViewCell.h"
#import "NewsApi.h"

@interface XLSessionBaseTableViewCell() <FollowButtonDelegate>
@property (strong, nonatomic) UILabel *tailLabel;
@property (strong, nonatomic) UILabel *shadowLabel;
@property (strong, nonatomic) UIImageView *authorView;
@property (strong, nonatomic) UILabel *authorNameLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) FollowButton *button;
@property (copy, nonatomic) NSString *buttonTitle;

@end

@implementation XLSessionBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)changeButtonState {
    self.button.followed = !self.button.followed;
}

- (void)cellSetImage:(NSString *)imageUrlString
          authorName:(NSString *)authorName
          tailString:(NSString *)tailString
         buttonTitle:(NSString *)buttonTitle
           dateLabel:(NSString *)dateLabel{
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
    [self.authorView sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:@"my_avatar"]];
    /*这不是要一段字符串两个色吗!*/
    self.authorNameLabel.attributedText = [self changeStringFont:authorString];
    self.dateLabel.text = dateLabel;
    [self.button.button.titleLabel setFont:[UIFont systemFontOfSize:adaptFontSize(25)]];
    [self.button changeButtonState:[buttonTitle integerValue]];
  
    /*调整布局*/
    [self.authorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).mas_offset(adaptHeight1334(16*2));
        make.left.equalTo(self.mas_left).mas_offset(adaptWidth750(17*2));
        make.height.mas_equalTo(adaptHeight1334(40*2));
        make.width.mas_equalTo(adaptWidth750(40*2));
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

#pragma mark -
#pragma mark - FollowButton delegate
- (void)followButtonClick:(FollowButton *)sender {
    /**button 点击后的回调*/
    /**按我的思路这里应该button自带网络请求,因为这是他应该有的属性,但是我估计没有*/

    @weakify(self);
    [NewsApi followWithAuthorId:self.authorID action:!self.button.followed success:^(id responseDict) {
        @strongify(self);
        if ([responseDict[@"result"] isEqualToString:@"3"]) {
            [MBProgressHUD showError:@"关注失败"];
            [sender stopAnimation];
            return ;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectFollowButton)]) {
            [self.delegate didSelectFollowButton];
        }
        if (self.button.followed) {
            self.button.followed = NO;
            ((FollowButton *)sender).followed = NO;
        } else {
            self.button.followed = YES;
            ((FollowButton *)sender).followed = YES;
            
            XLPublisherModel *model = [XLPublisherModel new];
            model.authorId = self.authorID;
            [StatServiceApi statEvent:FOLLOW_CLICK model:model];
            
        }
    } failure:^(NSInteger errorCode) {
        [sender stopAnimation];
        [MBProgressHUD showError:@"网络繁忙!"];
    }];
    
}

#pragma mark - lazy load
- (UIImageView *)authorView {
    if (!_authorView) {
        _authorView = [[UIImageView alloc] init];
        _authorView.layer.cornerRadius = adaptHeight1334(40);
        _authorView.layer.masksToBounds = YES;
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
        _button.delegate = self;
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
