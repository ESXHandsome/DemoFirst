//
//  LoginViewController.m
//  NationalRedPacket
//
//  Created by 王海玉 on 2018/1/26.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "LoginViewController.h"
#import "PrivacyAndTermsViewController.h"
#import "BaseNavigationController.h"
#import "UIImage+Tool.h"
#import "AppDelegate.h"
#import "XLBadgeManager.h"

@interface LoginViewController () <LoginViewModelDelegate>

@property (strong, nonatomic) UIButton *logInButton;
@property (strong, nonatomic) UIButton *dismissButton;
@property (strong, nonatomic) UIImageView *logoImageView;
@property (strong, nonatomic) UILabel *describeLabel;
@property (strong, nonatomic) UILabel *termsLabel;

@end

@implementation LoginViewController

+ (LoginViewController *)showLoginVCFromSource:(LoginSourceType)sourceType {
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    loginVC.viewModel = [[LoginViewModel alloc] initWithSourceType:sourceType];
    
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
    
    [UIViewController.currentViewController presentViewController:nav animated:YES completion:nil];
    
    return loginVC;
}

#pragma mark -
#pragma mark Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewModel.delegate = self;
    
    [self initUI];
}

#pragma mark -
#pragma mark - UI Initialize

- (void)initUI {
    self.view.backgroundColor = [UIColor colorWithString:COLORffffff];
    self.navigationController.navigationBar.hidden = YES;
    [self setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self.view addSubview:self.dismissButton];
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.describeLabel];
    [self.view addSubview:self.logInButton];
    [self.view addSubview:self.termsLabel];
    
    [self configLoginButton];
    [self addContraint];
}

- (void)configLoginButton {
    
    @weakify(self)
    [self loginButtonParameter:^(NSString *title, UIImage *image, UIImage *backgroundImage, UIImage *backgroundHighlightedImage) {
        @strongify(self)
        [self.logInButton setTitle:title forState:UIControlStateNormal];
        [self.logInButton setImage:image forState:UIControlStateNormal];
        [self.logInButton setImage:image forState:UIControlStateHighlighted];
        [self.logInButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        [self.logInButton setBackgroundImage:backgroundHighlightedImage forState:UIControlStateHighlighted];
    }];

}

- (void)loginButtonParameter:(void (^)(NSString *title, UIImage *image, UIImage *backgroundImage, UIImage *backgroundHighlightedImage))parameter {
    
    NSString *title = self.viewModel.platformType == LoginPlatformTypeWechat ? @"微信登录" : @" QQ登录";
    UIImage  *image = [UIImage imageNamed:self.viewModel.platformType == LoginPlatformTypeWechat ? @"login_weixin" : @"login_qq"];
    UIImage  *backgroundImage = [UIImage createImageWithColor:[UIColor colorWithString:self.viewModel.platformType == LoginPlatformTypeWechat ? COLOR08AF2B : COLOR189CEE] size:CGSizeMake(1, 1)];
    UIImage  *backgroundHighlightedImage = [UIImage createImageWithColor:[UIColor colorWithString:self.viewModel.platformType == LoginPlatformTypeWechat ? COLOR079d26 : COLOR0084D6] size:CGSizeMake(1, 1)];
    
    if (parameter) {
        parameter(title, image, backgroundImage, backgroundHighlightedImage);
    }
}

- (void)addContraint {
    [self.dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(adaptHeight1334(STATUS_BAR_HEIGHT + 54));
        make.right.equalTo(self.view).offset(- adaptWidth750(22));
        make.height.mas_equalTo(adaptHeight1334(44));
    }];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(adaptHeight1334(312));
        make.width.height.mas_equalTo(adaptWidth750(176));
    }];
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.logoImageView.mas_bottom).offset(adaptHeight1334(26));
    }];
    [self.logInButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-adaptHeight1334(244));
        make.width.mas_equalTo(adaptWidth750(560));
        make.height.mas_equalTo(adaptHeight1334(100));
    }];
    [self.termsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(adaptHeight1334(-36));
    }];
}

#pragma mark -
#pragma mark ThirdpartyLogin

- (void)thirdpartyLoginDidSuccess {
    
    if (self.loginSuccess) {
        self.loginSuccess(YES);
    }
    
    [XLBadgeManager.sharedManager registProfile];

    [MBProgressHUD hideHUD];
    self.view.userInteractionEnabled = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)thirdpartyLoginDidFailure:(NSInteger)errorCode {
    
    [MBProgressHUD hideHUD];
    [MBProgressHUD showError:@"登录失败"];
    self.view.userInteractionEnabled = YES;
    self.logInButton.userInteractionEnabled = YES;
}

#pragma mark -
#pragma mark Event Response

/**
 第三方登录按钮点击事件
 */
- (void)didClickThirdpartyLoginButtonEvent:(UIButton *)sender {
    
    sender.userInteractionEnabled = NO;
    sender.backgroundColor = [UIColor colorWithString:COLOR08AF2B];
    
    [MBProgressHUD hideHUD];
    [MBProgressHUD showChrysanthemum:@"登录中..."];
    self.view.userInteractionEnabled = NO;
    @weakify(self);
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        @strongify(self);
        [self.viewModel thirdpartyLogin];
    });
}

/**
 取消按钮点击事件
 */
- (void)didClickCancelButtonEvent:(UIButton *)sender {
    
    sender.enabled = NO;
    
    @weakify(self);
    
    if (self.viewModel.sourceType == LoginSourceTypeNetworkError) {
        
        [XLLoginManager.shared logoutWithIsEnforce:YES success:^(id responseDict) {
            
            [AppDelegate.shared resetToRootTabViewController];
            
        } failure:nil];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
        
        if (self.loginSuccess) {
            self.loginSuccess(NO);
        }
    }];
}

/**
 许可协议点击事件
 */
- (void)didClickTermsLabelEvent {
    [self.navigationController pushViewController:[PrivacyAndTermsViewController new] animated:YES];
}

#pragma mark -
#pragma mark Setters and Getters

- (UIButton *)dismissButton {
    if (!_dismissButton) {
        _dismissButton = [[UIButton alloc]init];
        [_dismissButton setTitle:@"取消" forState:UIControlStateNormal];
        [_dismissButton setTitleColor:[UIColor colorWithString:COLOR333333] forState:UIControlStateNormal];
        [_dismissButton addTarget:self action:@selector(didClickCancelButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissButton;
}

- (UIButton *)logInButton {
    if (!_logInButton) {
        _logInButton = [[UIButton alloc]init];
        _logInButton.layer.cornerRadius = adaptHeight1334(50);
        _logInButton.layer.masksToBounds = YES;
        [_logInButton addTarget:self action:@selector(didClickThirdpartyLoginButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        _logInButton.titleEdgeInsets = UIEdgeInsetsMake(0, adaptWidth750(20), 0, 0);
        _logInButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _logInButton;
}

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_icon_logo"]];
    }
    return _logoImageView;
}

- (UILabel *)describeLabel {
    if (!_describeLabel) {
        _describeLabel = [[UILabel alloc]init];
        _describeLabel.textColor = [UIColor colorWithString:COLOR999999];
        _describeLabel.font = [UIFont systemFontOfSize:adaptFontSize(30.8)];
        _describeLabel.text = @"『神奇的不只是段子』";
    }
    return _describeLabel;
}

- (UILabel *)termsLabel {
    if (!_termsLabel) {
        _termsLabel = [[UILabel alloc] init];
        _termsLabel.font = [UIFont systemFontOfSize:adaptFontSize(24)];
        
        NSString *str = @"登录代表你同意「神段子」软件许可使用协议";
        NSRange rangeA = [str rangeOfString:@"登录代表你同意"];
        NSRange rangeB = [str rangeOfString:@"「神段子」软件许可使用协议"];
        NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc] initWithString:str];
        [aStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithString:COLOR999999] range:rangeA];
        [aStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithString:COLORFE6969] range:rangeB];
        _termsLabel.attributedText = aStr;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickTermsLabelEvent)];
        _termsLabel.userInteractionEnabled = YES;
        [_termsLabel addGestureRecognizer:tapGesture];
    }
    return _termsLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
