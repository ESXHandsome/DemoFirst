//
//  PPSSetUpTableViewCell.m
//  NationalRedPacket
//
//  Created by Ying on 2018/3/23.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "PPSSetUpTableViewCell.h"

@implementation PPSSetUpTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.height = adaptHeight1334(52*2);
    self.titleLabel = [UILabel new];
    self.titleLabel.textColor = [UIColor colorWithString:@"#333333"];
    self.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(17*2)];
    self.titleLabel.frame = CGRectMake(adaptWidth750(12*2), adaptHeight1334(14*2), adaptWidth750(200*2), adaptHeight1334(24*2));
    [self addSubview:_titleLabel];
    return self;
}
-(void)setLabelLocation{
    CGSize size = [_titleLabel.text sizeWithAttributes:@{NSFontAttributeName:_titleLabel.font}];
    _titleLabel.frame = CGRectMake(adaptWidth750(196*2), adaptHeight1334(14*2), size.width, size.height);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.centerX = SCREEN_WIDTH/2;
    self.titleLabel.centerY = self.height/2;
}
-(void)setTitleLabelText:(NSString *)title{
    _titleLabel.text = title;
    CGSize size = [_titleLabel.text sizeWithAttributes:@{NSFontAttributeName:_titleLabel.font}];
    _titleLabel.size = size;
      self.titleLabel.centerY = self.height/2;
}
-(void)setTailLabelText:(NSString *)title{
    _tailLabel = [[UILabel alloc] init];
    _tailLabel.text = title;
    _tailLabel.font = [UIFont systemFontOfSize:adaptFontSize(28)];
    CGSize size = [_tailLabel.text sizeWithAttributes:@{NSFontAttributeName:_tailLabel.font}];
    _tailLabel.size = size;
    _tailLabel.textColor = [UIColor colorWithString:@"#999999"];
    self.tailLabel.x = adaptWidth750(260*2);
    self.tailLabel.centerY = self.height/2;
    [self addSubview:_tailLabel];
}
-(void)setNewEditionLogo{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithString:@"#F43530"];
    view.frame = CGRectMake(adaptWidth750(90*2), adaptHeight1334(16*2), adaptWidth750(44*2), adaptHeight1334(18*2));
    view.layer.cornerRadius = adaptFontSize(18);
    [self addSubview:view];
    UILabel *label = [UILabel labWithText:@"新版本" fontSize:adaptFontSize(10*2) textColorString:@"#FFFFFF"];
    label.size = CGSizeMake(adaptWidth750(30*2), adaptHeight1334(14*2));
    CGSize size = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
    label.size = size;
    label.center = CGPointMake(view.size.width/2, view.size.height/2);
    [view addSubview:label];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
