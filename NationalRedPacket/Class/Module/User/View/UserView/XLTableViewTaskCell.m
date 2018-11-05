//
//  PPSTableViewTaskCell.m
//  NationalRedPacket
//
//  Created by Ying on 2018/3/21.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "XLTableViewTaskCell.h"
#import "PPSSuccessFloatView.h"


@interface XLTableViewTaskCell()
@property (copy, nonatomic) NSString *buttonTitle;
@end

@implementation XLTableViewTaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.height = adaptHeight1334(52*2);
    self.button = [[UIButton alloc] init];
    self.button.frame = CGRectMake(adaptWidth750(299*2), adaptHeight1334(12*2), adaptWidth750(63*2), adaptHeight1334(28*2));
    self.button.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(14*2)];
    [self addSubview:self.button];
    
    self.shareLabel = [UILabel labWithText:@"最高80金币" fontSize:adaptFontSize(14*2) textColorString:@"#F3494F"];
    CGSize size = [self.shareLabel.text sizeWithAttributes:@{NSFontAttributeName:self.shareLabel.font}];
    self.shareLabel.frame = CGRectMake(adaptWidth750(123.6*2), adaptHeight1334(16.5*2), size.width, size.height);
    self.shareLabel.centerY = self.height/2;
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(17*2)];
    [self addSubview:self.titleLabel];
    
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.frame = CGRectMake(adaptWidth750(13.6*2), adaptHeight1334(16*2), adaptWidth750(21*2), adaptHeight1334(21*2));
    [self addSubview:self.iconImageView];
    return self;
}

-(void)buildDailyTaskCell:(PPSTableViewStyle)tableViewStyle{
    if (tableViewStyle == TableViewCellSignIn) {
        UIImage *image = [UIImage imageNamed:@"my_sign"];
        self.iconImageView.size = CGSizeMake(image.size.width, image.size.height);
        self.iconImageView.image = image;
        self.titleLabel.text = [NSString stringWithFormat:@"已连续签到 %ld 天",_days];
        _buttonTitle = @"签到";
        [self layoutButtonState];
        [self.button addTarget:self action:@selector(signInButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }else if(tableViewStyle == TableViewCellShare){
        _tableViewStyle = TableViewCellShare;
        UIImage *image = [UIImage imageNamed:@"my_camera"];
        self.iconImageView.size = CGSizeMake(image.size.width, image.size.height);
        self.iconImageView.image = image;
        self.titleLabel.text = @"晒朋友圈";
        _buttonTitle = @"分享";
        if(_buttonState)
            [self addSubview:_shareLabel];
        [self layoutButtonState];
        [self.button addTarget:self action:@selector(shareButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    CGSize sizeNew = [ self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
    self.titleLabel.frame = CGRectMake(adaptWidth750(48.6*2), adaptHeight1334(15.5*2), sizeNew.width, sizeNew.height);
}

- (void)setLabelDays:(NSInteger)days{
    _days = days;
    
    if (days > 0) {
        NSString *string = [NSString stringWithFormat:@"已连续签到 %ld 天",_days];
        NSRange range = [string rangeOfString:[NSString stringWithFormat:@"%ld",_days]];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]initWithString:string];
        NSDictionary *dic = @{NSForegroundColorAttributeName:[UIColor colorWithString:@"#F3494F"]};
        [attri setAttributes:dic range:range];
        self.titleLabel.attributedText = attri;
    }else{
        self.titleLabel.text = [NSString stringWithFormat:@"已连续签到 %ld 天",_days];
    }
    CGSize size = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    self.titleLabel.size = size;
}

- (void)setButtonState:(BOOL)buttonState{
    _buttonState = buttonState;
    [self layoutButtonState];
}


- (void)layoutButtonState{
    if (_buttonState){
        [self.button setTitle:_buttonTitle forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
        [self.button.layer setBorderColor:[UIColor colorWithString:@"#FCD953"].CGColor];
        self.button.backgroundColor = [UIColor colorWithString:@"#FCD953"];
        [self.button.layer setCornerRadius:adaptFontSize(4*2)];
        [self.button.layer setBorderWidth:adaptFontSize(1.04*2)];
        self.button.layer.masksToBounds = YES;
    }else{
        [self.button.layer setBorderWidth:0];
        self.button.backgroundColor = [UIColor clearColor];
        [self.button setTitle:[NSString stringWithFormat:@"已%@",_buttonTitle] forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor colorWithString:@"#8C8C8C"] forState:UIControlStateNormal];
    }
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:NO];
}

- (void)signInButtonAction{
    if(_buttonState){
        [_delegate taskCellSignInButtonAction:self];
    }else{
        [MBProgressHUD showError:@"已签到"];
    }
}
- (void)shareButtonAction{
    if(_buttonState){
        [_delegate taskCellShareButtonAction:self];
    }else
        [MBProgressHUD showError:@"已分享"];
}
@end
