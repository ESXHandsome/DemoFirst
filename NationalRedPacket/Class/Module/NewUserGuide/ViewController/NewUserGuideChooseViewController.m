//
//  NewUserGuideChooseViewController.m
//  NationalRedPacket
//
//  Created by Ying on 2018/4/8.
//  Copyright © 2018年 XLook. All rights reserved.
//


#import "NewUserGuideChooseViewController.h"
#import "NewUserGuideView.h"
#import "NewUserGuideViewModel.h"
#import "NewUserGuideModel.h"
#import "NewUserGuideViewController.h"
#import "XLLoginManager.h"
#import "LaunchViewModel.h"

@interface NewUserGuideChooseViewController ()
<NewUserGuideViewModelDelegate, NewUserGuideViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView       *scrollView;
@property (weak, nonatomic) IBOutlet UIButton           *beginButton;
@property (weak, nonatomic) IBOutlet UIImageView        *backgroundView;

@property (strong, nonatomic) NewUserGuideViewModel      *viewModel;
@property (strong, nonatomic) UISwipeGestureRecognizer   *rightSwipeGestureRecognizer;
@property (strong, nonatomic) UIView                     *loadingView;
@property (strong, nonatomic) LaunchViewModel            *launchViewModel;

@end

@implementation NewUserGuideChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewModel = [[NewUserGuideViewModel alloc] init];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(0, 1);
    gradient.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, _backgroundView.height);
    UIColor *colorBegin = [UIColor colorWithRed:(0/255.0)  green:(0/255.0)
                                           blue:(0/255.0)  alpha:0.0];
    UIColor *colorEnd = [UIColor colorWithRed:(0/255.0)  green:(0/255.0)
                                         blue:(0/255.0)  alpha:0.1];
    NSArray *colors = [NSArray arrayWithObjects:(id)colorBegin.CGColor,
                       colorEnd.CGColor, nil];
    gradient.colors = colors;
    [self.backgroundView.layer addSublayer:gradient];
    [self buildTitleLabel];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc]
                                        initWithTarget:self
                                                action:@selector(handleSwipes:)];
    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
    [XLLoadingView showLoadingInView:_loadingView];
    XLLoadingView *loadingView = [XLLoadingView loadingForView:_loadingView];
    loadingView.backgroundColor = [UIColor clearColor];
    _viewModel.delegate = self;
    [_viewModel uploadSex:_sex];
    
    _launchViewModel = [[LaunchViewModel alloc] init];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [StatServiceApi statEvent:NEW_USER_FOLLOW_PAGE_PV];
    });
}

/**
 加一个Label Xib上加ScrollView不动
 */
- (void)buildTitleLabel { 
    UILabel *label = [UILabel labWithText:@"关注你感兴趣的账号"
                                 fontSize:adaptFontSize(46)
                          textColorString:COLOR333333];
    label.font = [UIFont boldSystemFontOfSize:adaptFontSize(46)];
    label.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_top).offset(adaptHeight1334(14));
        make.centerX.equalTo(self.scrollView.mas_centerX);
    }];
    self.loadingView = [[UIView alloc] init];
    self.loadingView.frame = CGRectMake(0, adaptHeight1334(80), SCREEN_WIDTH,adaptHeight1334(490*2));
    [self.scrollView addSubview:self.loadingView];
}

/**
 上传性别回调
 */
- (void)uploadSexSucceed:(NSArray *)array {
    [_loadingView removeFromSuperview];
    for (int i=0; i<array.count; i++) {
        NewUserGuideModel *startPageModel = array[i];
        NewUserGuideView *cell = [[NewUserGuideView alloc] init];
        cell.delegate = self;
        cell.origin = CGPointMake(([UIScreen mainScreen].bounds.size.width-adaptWidth750(11*2))/4*(i%4)+adaptWidth750(40),
                                  adaptHeight1334(150)+(i/4*adaptWidth750(177*2)));
        [cell setImage:startPageModel.icon
                 title:startPageModel.name
              authorld:startPageModel.authorId];
        [_scrollView addSubview:cell];
        if(i == 0){
            [cell buttonAction];
        }
        if(i == array.count-1){
              [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH,cell.y+cell.height)];
        }
    }
}

- (void)uploadSexFailed {
    __weak typeof(self) weakSelf = self;
    [XLLoadingView hideLoadingForView:_loadingView];
    [XLReloadFailView showReloadFailInView:_loadingView reloadAction:^{
        [XLLoadingView showLoadingInView:weakSelf.loadingView];
        [weakSelf.viewModel uploadSex:weakSelf.sex];
    }];
}

/**
开始使用按钮点击事件
 */
- (IBAction)beginButtonAction:(UIButton *)sender {
    self.beginButton.userInteractionEnabled = NO;
    [_viewModel uploadAuthorldArray];
//    [self dismissViewControllerAnimated:NO completion:nil];
    [self.viewModel prepareToLogin];
}

/**
右滑返回
 */
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender {
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        NewUserGuideViewController *viewController = [[NewUserGuideViewController alloc] init];
        [viewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

/**
cell的按钮被点击
给viewModel去维护需要上传的数组
 */
- (void)cellButtonClicked:(NSString *)authorld state:(BOOL)buttonState {
    [_viewModel maintenanceUpLoadAuthorldArray:authorld state:buttonState];
}

- (void)changeStartButtonState:(BOOL)state {
    if(state){
        _beginButton.userInteractionEnabled = YES;
        _beginButton.backgroundColor = [UIColor colorWithString:COLORFE6969];
    }else{
        _beginButton.userInteractionEnabled = NO;
        _beginButton.backgroundColor = [UIColor colorWithString:COLORC8C8C8];
    }
}

/**
上传关注作者的回调
 */
- (void)uploadAuthorldSucceed {
    [StatServiceApi statEvent:USER_GUIDEPAGE_CHOOSE_GENDER model:nil otherString:[NSString stringWithFormat:@"%ld", (long)_sex]];
}

- (void)uploadAuthorldFailed {
    [MBProgressHUD showError:@"服务器暂时出现故障"];
}

@end
