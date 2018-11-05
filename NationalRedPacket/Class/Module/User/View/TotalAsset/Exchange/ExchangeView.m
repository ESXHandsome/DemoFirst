//
//  ExchangeView.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/23.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "ExchangeView.h"
#import "CustomEditView.h"

@interface ExchangeView ()

@property (assign, nonatomic) ExchangeType exchangeType;
@property (weak, nonatomic) id <ExchangeProtocol>delegate;

@property (strong, nonatomic) UILabel        *titleLabel;
@property (strong, nonatomic) UIView         *backView;
@property (strong, nonatomic) CustomEditView *telephoneView;
@property (strong, nonatomic) CustomEditView *alipayAccountView;
@property (strong, nonatomic) CustomEditView *alipayNameView;
@property (strong, nonatomic) UILabel        *explainLabel;
@property (strong, nonatomic) UIButton       *sureButton;

@end

@implementation ExchangeView

- (instancetype)initWithExchangeType:(ExchangeType)exchangeType delegate:(id<ExchangeProtocol>)delegate
{
    self = [super init];
    if (self) {
        self.exchangeType = exchangeType;
        self.delegate = delegate;
        self.backgroundColor = [UIColor colorWithString:COLORF5F6F9];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT);
        [self setupViews];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)setupViews
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidChangeNotification object:nil];

    NSString *titleText = self.exchangeType == ExchangeTypeTelephone ? @"请输入您的手机号" : @"请输入您的姓名和支付宝账号";
    self.titleLabel = [UILabel labWithText:titleText fontSize:adaptFontSize(28) textColorString:COLOR7B7B7B];
    [self addSubview:self.titleLabel];
    
    self.backView = [UIView new];
    self.backView.backgroundColor = [UIColor whiteColor];
    self.backView.layer.borderWidth = 0.5;
    self.backView.layer.borderColor = [UIColor colorWithString:COLORE6E6E6].CGColor;
    [self addSubview:self.backView];
    
    if (self.exchangeType == ExchangeTypeTelephone) {
        
        self.telephoneView = [CustomEditView new];
        self.telephoneView.titleLabel.text = @"手机号";
        self.telephoneView.contentTextField.placeholder = @"请输入手机号码";
        self.telephoneView.contentTextField.keyboardType = UIKeyboardTypeNumberPad;
        [self.backView addSubview:self.telephoneView];
        
    } else {
        
        self.alipayAccountView = [CustomEditView new];
        self.alipayAccountView.titleLabel.text = @"支付宝";
        self.alipayAccountView.contentTextField.placeholder = @"支付宝账号";
        [self.backView addSubview:self.alipayAccountView];
        
        self.alipayNameView = [CustomEditView new];
        self.alipayNameView.titleLabel.text = @"姓名";
        self.alipayNameView.contentTextField.placeholder = @"用户真实姓名";
        [self.backView addSubview:self.alipayNameView];
    }
    
    NSString *text = self.exchangeType == ExchangeTypeTelephone ? @"注：请正确填写所要充值的手机号码，以免因号码填\n写错误导致损失。" : @"注：支付宝账号必须有实名认证，否则支付宝公司会\n拒绝转账！";
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:adaptHeight1334(6)];//行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithString:COLORFF8100] range:NSMakeRange(self.exchangeType == ExchangeTypeTelephone ? 3 : 10, 4)];
    
    self.explainLabel = [UILabel labWithText:@"" fontSize:adaptFontSize(28) textColorString:COLOR7B7B7B];
    self.explainLabel.numberOfLines = 2;
    [self.explainLabel setAttributedText:attributedString];
    [self addSubview:self.explainLabel];
    
    self.sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sureButton setTitle:@"确认" forState:UIControlStateNormal];
    self.sureButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(40)];
    self.sureButton.backgroundColor = [UIColor colorWithString:COLOREBEBF1];
    [self.sureButton setTitleColor:[UIColor colorWithString:COLORD2D2D2] forState:UIControlStateNormal];
    self.sureButton.layer.cornerRadius = 4;
    self.sureButton.layer.masksToBounds = YES;
    [self.sureButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    self.sureButton.userInteractionEnabled = NO;
    [self addSubview:self.sureButton];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(adaptWidth750(30));
        make.top.equalTo(self).offset(adaptHeight1334(18));
    }];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(adaptHeight1334(20));
        make.left.equalTo(self).offset(-1);
        make.right.equalTo(self).offset(1);
        make.height.mas_equalTo(self.exchangeType == ExchangeTypeTelephone ? kEditViewHeight : kEditViewHeight * 2);
    }];
    
    if (self.exchangeType == ExchangeTypeTelephone) {
        [self.telephoneView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.equalTo(self.backView);
        }];
    } else {
        [self.alipayAccountView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.backView);
            make.height.mas_equalTo(kEditViewHeight);
        }];
        [self.alipayNameView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.backView);
            make.top.equalTo(self.alipayAccountView.mas_bottom);
            make.height.mas_equalTo(kEditViewHeight);
        }];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor colorWithString:COLORE6E6E6];
        [self.backView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(adaptWidth750(30));
            make.right.equalTo(self);
            make.height.mas_equalTo(0.5);
            make.centerY.equalTo(self.backView);
        }];
    }

    [self.explainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.backView.mas_bottom).offset(adaptHeight1334(20));
        make.right.equalTo(self).offset(-adaptWidth750(30));
    }];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.explainLabel);
        make.top.equalTo(self.explainLabel.mas_bottom).offset(adaptHeight1334(32));
        make.height.mas_equalTo(adaptHeight1334(84));
    }];
}

- (void)becomeCanEditState
{
    if (self.exchangeType == ExchangeTypeTelephone) {
        [self.telephoneView.contentTextField becomeFirstResponder];
    } else {
        [self.alipayAccountView.contentTextField becomeFirstResponder];
    }
}

- (NSMutableDictionary *)exchangeRequestDictionary
{
    if (self.exchangeType == ExchangeTypeTelephone) {
        return @{@"exchangeMode" : @"TELEPHONE",
                 @"exchangeAccount" : self.telephoneView.contentTextField.text}.mutableCopy;
    } else {
        return @{@"exchangeMode" : @"ALIPAY_NATIVE",
                 @"exchangeAccount" : self.alipayAccountView.contentTextField.text,
                 @"realname" : self.alipayNameView.contentTextField.text}.mutableCopy;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

- (void)buttonAction
{
    [self endEditing:YES];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didClickExchangeSureButton)]) {
        [self.delegate didClickExchangeSureButton];
    }
}

/**
 TextField正在编辑

 @param textField textField
 */
- (void)textFieldChange:(UITextField *)textField
{
    if (self.exchangeType == ExchangeTypeTelephone) {
        if (self.telephoneView.contentTextField.text.length >= 11) {
            self.telephoneView.contentTextField.text = [self.telephoneView.contentTextField.text substringToIndex:11];
            [self changeSureButtonCanClick:YES];
        } else {
            [self changeSureButtonCanClick:NO];
        }
    } else {
        if (self.alipayAccountView.contentTextField.text.length != 0 && self.alipayNameView.contentTextField.text.length != 0) {
            [self changeSureButtonCanClick:YES];
        } else {
            [self changeSureButtonCanClick:NO];
        }
    }
}

/**
 button是否可点击

 @param canClick bool
 */
- (void)changeSureButtonCanClick:(BOOL)canClick
{
    self.sureButton.userInteractionEnabled = canClick;
    self.sureButton.backgroundColor = [UIColor colorWithString:canClick ? COLOR108EE9 : COLOREBEBF1];
    [self.sureButton setTitleColor:[UIColor colorWithString:canClick ? COLORffffff : COLORD2D2D2] forState:UIControlStateNormal];
}

@end
