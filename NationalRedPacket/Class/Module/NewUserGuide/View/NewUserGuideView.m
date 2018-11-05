//
//  NewUserGuideView.m
//  NationalRedPacket
//
//  Created by Ying on 2018/4/8.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "NewUserGuideView.h"

@interface NewUserGuideView()

@property (assign, nonatomic) BOOL buttonState;

@end

@implementation NewUserGuideView
- (instancetype)init {
    self = [super init];
    if(self){
        self.size = CGSizeMake(adaptWidth750(68*2), adaptHeight1334(145*2));
        _imageView = [[UIImageView alloc] init];
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(13*2)];
        _titleLabel.textColor = [UIColor colorWithString:@"#343434"];
        _titleLabel.numberOfLines = 2;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _button = [[UIButton alloc] init];
        _button.backgroundColor = [UIColor colorWithString:@"#FCD953"];
        _button.layer.cornerRadius = adaptFontSize(2.08*2);
        _button.layer.masksToBounds = YES;
        [_button setTitle:@"关注" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont boldSystemFontOfSize:adaptFontSize(11*2)];
        [_button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside
         ];
        _buttonState = YES;
    }
    return self;
}

- (void)setImage:(NSString *)imageUrl title:(NSString *)title authorld:(NSString *)authorld {
    self.authorld = authorld;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"edit_avatar_big"]];
    self.imageView.frame = CGRectMake(adaptWidth750(3*2), 0, adaptWidth750(62*2),  adaptHeight1334(62*2));
    self.imageView.layer.cornerRadius = _imageView.height/2;
    self.imageView.layer.masksToBounds = YES;
    [self addSubview:self.imageView];
    
    self.titleLabel.frame = CGRectMake(0, adaptHeight1334(71*2), self.width, adaptHeight1334(45*2));
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:title];
    self.titleLabel.attributedText = string;
    self.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.titleLabel sizeToFit];
    self.titleLabel.centerX = self.width/2;
    [self addSubview:self.titleLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    [self addGestureRecognizer:tap];
    [self addSubview:self.button];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(adaptWidth750(5));
        make.bottom.equalTo(self.mas_bottom);
        make.width.mas_equalTo(adaptWidth750(63*2));
        make.height.mas_equalTo(adaptHeight1334(21*2));
    }];
}

- (void)tapView:(UITapGestureRecognizer *)sender {
    [self buttonAction];
}

- (void)buttonAction {
    if (self.buttonState) {
        self.button.backgroundColor = [UIColor clearColor];
        [self.button setTitle:@"已关注" forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor colorWithString:COLORCFCFCF] forState:UIControlStateNormal];
    } else {
        self.button.backgroundColor = [UIColor colorWithString:COLORFE6969];
        [self.button setTitle:@"关注" forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor colorWithString:COLOR333333] forState:UIControlStateNormal];
    }
    self.buttonState = !self.buttonState;
    [self.delegate cellButtonClicked:[_authorld copy] state:self.buttonState];
}

@end
