//
//  XLH5AlertView.m
//  NationalRedPacket
//
//  Created by Ying on 2018/6/20.
//  Copyright © 2018 XLook. All rights reserved.
//

#import "XLH5AlertView.h"
#import "XLH5WebViewController.h"

@interface XLH5AlertView()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *cancelButton;
@property (copy, nonatomic) NSString *openString;
@property (strong, nonatomic) UIViewController *controller;
@property (copy, nonatomic) NSString *ID;
@end

@implementation XLH5AlertView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = UIScreen.mainScreen.bounds;
        self.backgroundColor = [[UIColor colorWithString:COLOR000000] colorWithAlphaComponent:0.6];
        [self configUI];
    }
    return self;
}

+ (void)showH5GudieAlert:(NSString *)imageUrlString open:(NSString *)urlString target:(UIViewController *)target ID:(NSString  *)ID{
    XLH5AlertView *alertView = [[self alloc] init];
    alertView.imageUrlString = imageUrlString;
    alertView.openString = urlString;
    alertView.controller = target;
    alertView.ID = ID;
    [KeyWindow addSubview:alertView];
    [StatServiceApi statEvent:POP_H5_LOOK model:nil otherString:ID];
}

- (void)configUI {
    [self addSubview:self.imageView];
    [self addSubview:self.cancelButton];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(adaptWidth750(38*2));
        make.top.equalTo(self).mas_offset(adaptHeight1334(134*2));
        make.width.mas_equalTo(adaptWidth750(300*2));
        make.height.mas_equalTo(adaptHeight1334(400*2));
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(adaptWidth750(180*2));
        make.top.equalTo(self).mas_offset(adaptHeight1334(574*2));
        make.width.mas_equalTo(adaptWidth750(17*2));
        make.height.mas_equalTo(adaptHeight1334(17*2));
    }];
}

#pragma mark -
#pragma mark - action

- (void)cancelButtonAction {
    [self removeFromSuperview];
}

- (void)tapGesture {
    XLH5WebViewController *controller = [[XLH5WebViewController alloc] init];
    controller.urlString = self.openString;
    [self removeFromSuperview];
    [self.controller.navigationController pushViewController:controller animated:YES];
    [StatServiceApi statEvent:POP_H5_CLICK model:nil otherString:self.ID];
}

#pragma mark -
#pragma mark - lazy load

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        _imageView.userInteractionEnabled = YES;
        [_imageView addGestureRecognizer:tapGesture];
    }
    return _imageView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setImage:[UIImage imageNamed:@"popup_close"] forState:UIControlStateNormal];
    }
    return _cancelButton;
}

#pragma mark -
#pragma mark - setter

- (void)setImageUrlString:(NSString *)imageUrlString {
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString]];
}

@end
