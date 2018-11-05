//
//  XLSessionNoPublisherViewController.m
//  NationalRedPacket
//
//  Created by Ying on 2018/5/31.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLSessionNoPublisherViewController.h"

@interface XLSessionNoPublisherViewController ()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIButton *button;

@end

@implementation XLSessionNoPublisherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.label];
    [self.view addSubview:self.button];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_offset(adaptHeight1334(158*2) +NAVIGATION_BAR_HEIGHT);
        make.left.equalTo(self.view).mas_offset(adaptWidth750(106*2));
        make.height.mas_equalTo(adaptHeight1334(130*2));
        make.width.mas_equalTo(adaptWidth750(152*2));
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(adaptWidth750(152*2));
        make.top.equalTo(self.imageView.mas_bottom).mas_offset(adaptHeight1334(17*2));
        
    }];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(adaptWidth750(115*2));
        make.top.equalTo(self.label.mas_bottom).mas_offset(adaptHeight1334(17*2));
        make.height.mas_equalTo(adaptHeight1334(38*2));
        make.width.mas_equalTo(adaptWidth750(154*2));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - button action
- (void)buttonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - lazy load

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"no_existent"];
    }
    return _imageView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [UILabel labWithText:@"用户不存在" fontSize:adaptFontSize(16*2) textColorString:COLOR999999];
    }
    return _label;
}

- (UIButton *)button {
    if (!_button) {
        _button = [[UIButton alloc] init];
        _button.backgroundColor = [UIColor colorWithString:COLORFE6969];
        _button.layer.cornerRadius = adaptHeight1334(19*2);
        _button.layer.masksToBounds = YES;
        [_button setTitle:@"确定" forState:UIControlStateNormal];
        [_button.titleLabel setFont:[UIFont systemFontOfSize:adaptFontSize(16*2)]];
        [_button setTitleColor:[UIColor colorWithString:COLOR333333] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
