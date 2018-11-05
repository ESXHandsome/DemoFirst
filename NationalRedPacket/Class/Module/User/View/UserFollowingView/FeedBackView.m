//
//  FeedBackView.m
//  NationalRedPacket
//
//  Created by 王海玉 on 2018/1/2.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "FeedBackView.h"

@interface FeedBackView ()<UITextViewDelegate>

@property (strong, nonatomic) UILabel *placeHolder;
@property (strong, nonatomic) UIButton *commitButton;
@property (strong, nonatomic) UILabel *stringLenghLabel;
@property (strong, nonatomic) UILabel *explainLabel;

@end

@implementation FeedBackView

- (void)setupViews {
    self.backgroundColor = [UIColor colorWithString:COLOREFEFEF];
    
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:headerView];
    
    UILabel *titleLabel = [UILabel labWithText:@"问题和意见" fontSize:adaptFontSize(28) textColorString:COLOR999999];
    [self addSubview:titleLabel];
    
    self.feedbackTextView = [UITextView new];
    self.feedbackTextView.backgroundColor = [UIColor colorWithString:COLORffffff];
    self.feedbackTextView.font = [UIFont systemFontOfSize:adaptFontSize(32)];
    self.feedbackTextView.delegate = self;
    [headerView addSubview:self.feedbackTextView];
    
    UILabel *headerViewTopLabel = [[UILabel alloc]init];
    headerViewTopLabel.backgroundColor = [UIColor colorWithString:COLORD9D9D9];
    [headerView addSubview:headerViewTopLabel];
    
    UILabel *headerViewBottomLabel = [[UILabel alloc]init];
    headerViewBottomLabel.backgroundColor = [UIColor colorWithString:COLORD9D9D9];
    [headerView addSubview:headerViewBottomLabel];
    
    self.placeHolder = [UILabel labWithText:@"请填写10字以上的问题描述" fontSize:adaptFontSize(32) textColorString:COLOR999999];
    self.placeHolder.userInteractionEnabled = NO;
    [self.feedbackTextView addSubview:self.placeHolder];
    
    self.stringLenghLabel = [UILabel labWithText:@"0/200" fontSize:adaptFontSize(28) textColorString:COLORC0C0C0];
    [headerView addSubview:self.stringLenghLabel];
    
    UIView *footerView = [UIView new];
    footerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:footerView];
    
    UILabel *footerViewTopLabel = [[UILabel alloc]init];
    footerViewTopLabel.backgroundColor = [UIColor colorWithString:COLORD9D9D9];
    [footerView addSubview:footerViewTopLabel];
    
    UILabel *footerViewBottomLabel = [[UILabel alloc]init];
    footerViewBottomLabel.backgroundColor = [UIColor colorWithString:COLORD9D9D9];
    [footerView addSubview:footerViewBottomLabel];
    
    self.contactTextField = [UITextField new];
    self.contactTextField.placeholder = @"电话、微信或QQ";
    [self.contactTextField setValue:[UIColor colorWithString:COLOR999999] forKeyPath:@"_placeholderLabel.textColor"];
    self.contactTextField.font = [UIFont systemFontOfSize:adaptFontSize(32)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    self.contactTextField.layer.borderColor = [UIColor colorWithString:COLORCACACA].CGColor;
    self.contactTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, adaptWidth750(20), adaptHeight1334(80))];
    self.contactTextField.leftViewMode = UITextFieldViewModeAlways;
    [footerView addSubview:self.contactTextField];
    
    self.explainLabel = [UILabel labWithText:@"您的联系方式有助于我们沟通和解决问题，仅工作人员可见" fontSize:adaptFontSize(26) textColorString:COLORC0C0C0];
    [footerView addSubview:self.explainLabel];
    
    self.commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commitButton.backgroundColor = [UIColor colorWithString:COLORCCCCCC];
    [self.commitButton setTitleColor:[UIColor colorWithString:COLORffffff] forState:UIControlStateNormal];
    [self.commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.commitButton addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    self.commitButton.userInteractionEnabled = NO;
    [self addSubview:self.commitButton];
    self.commitButton.layer.cornerRadius = adaptHeight1334(8);
    self.commitButton.layer.masksToBounds = YES;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(adaptWidth750(27));
        make.top.equalTo(self).offset(adaptHeight1334(14)+NAVIGATION_BAR_HEIGHT);
    }];
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self).offset(adaptHeight1334(68)+NAVIGATION_BAR_HEIGHT);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(adaptHeight1334(220));
        
    }];
    
    [self.feedbackTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(adaptWidth750(18));
        make.right.equalTo(headerView).offset(-adaptWidth750(18));
        make.top.equalTo(headerView).offset(adaptWidth750(8));
        make.bottom.equalTo(headerView).offset(-adaptWidth750(24));
    }];
    
    [self.placeHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(headerView).offset(adaptWidth750(27));
        make.top.equalTo(headerView).offset(adaptWidth750(24));
        
    }];
    
    [self.stringLenghLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.feedbackTextView).offset(adaptWidth750(620));
        make.top.equalTo(headerView).offset(adaptHeight1334(166));
        
    }];
    
    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self);
        make.top.equalTo(headerView.mas_bottom).offset(adaptHeight1334(20));
        make.height.mas_equalTo(adaptHeight1334(88));
        
    }];
    
    [self.contactTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(footerView);
        make.left.equalTo(self.feedbackTextView).offset(-adaptWidth750(4));
        make.right.equalTo(footerView).offset(-adaptWidth750(18));
        make.height.mas_equalTo(adaptHeight1334(50));
        
    }];
    
    [self.explainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.placeHolder);
        make.top.equalTo(self.contactTextField.mas_bottom).offset(adaptHeight1334(30));
        
    }];
    
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(footerView.mas_bottom).offset(adaptHeight1334(140));
        make.right.equalTo(self).offset(-adaptWidth750(96));
        make.left.equalTo(self).offset(adaptWidth750(96));
        make.height.mas_equalTo(adaptHeight1334(84));
        
    }];
    
    [headerViewTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(adaptWidth750(1));
        make.width.equalTo(self);
        make.top.equalTo(headerView);
        make.left.equalTo(headerView);
    }];
    
    [headerViewBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(adaptWidth750(1));
        make.width.equalTo(self);
        make.bottom.equalTo(headerView);
        make.left.equalTo(headerView);
    }];
    
    [footerViewTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(adaptWidth750(1));
        make.width.equalTo(self);
        make.top.equalTo(footerView);
        make.left.equalTo(footerView);
    }];
    
    [footerViewBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(adaptWidth750(1));
        make.width.equalTo(self);
        make.bottom.equalTo(footerView);
        make.left.equalTo(footerView);
    }];

}

//正在改变
- (void)textViewDidChange:(UITextView *)textView
{
    self.placeHolder.hidden = YES;
    if (self.feedbackTextView.text.length != 0) {
        //允许提交按钮点击操作
        self.commitButton.backgroundColor = [UIColor colorWithString:COLORFE6969];
        [self.commitButton setTitleColor:[UIColor colorWithString:COLOR333333] forState:UIControlStateNormal];
        self.commitButton.userInteractionEnabled = YES;
    }
    
    //实时显示字数
    self.stringLenghLabel.text = [NSString stringWithFormat:@"%lu/200", (unsigned long)textView.text.length];
    
    //字数限制操作
    if (textView.text.length >= 200) {
        
        textView.text = [textView.text substringToIndex:200];
        self.stringLenghLabel.text = @"200/200";
        
    }
    //取消按钮点击权限，并显示提示文字
    if (textView.text.length == 0) {
        
        self.placeHolder.hidden = NO;
        self.commitButton.userInteractionEnabled = NO;
        self.commitButton.backgroundColor = [UIColor colorWithString:COLORCCCCCC];
        [self.commitButton setTitleColor:[UIColor colorWithString:COLORffffff] forState:UIControlStateNormal];
        self.stringLenghLabel.textColor = [UIColor colorWithString:COLORCCCCCC];
    }
}

- (void)textFieldDidChange {
    
}

- (void)commitAction
{
    [self endEditing:YES];
    if (self.backResult) {
        self.backResult(0);
    }
}

@end
