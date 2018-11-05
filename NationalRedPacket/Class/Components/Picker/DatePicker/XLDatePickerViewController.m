//
//  XLDatePickerViewController.m
//  NationalRedPacket
//
//  Created by Ying on 2018/7/27.
//  Copyright © 2018 XLook. All rights reserved.
//

#import "XLDatePickerViewController.h"
#import "XLDatePickerViewModel.h"
#import "XLDimmingPresentationController.h"

@interface XLDatePickerViewController () <UIPickerViewDelegate>

@property (strong, nonatomic) UIDatePicker *datePickerView;
@property (strong, nonatomic) XLDatePickerViewModel *viewModel;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *sureButton;
@property (strong, nonatomic) UIViewController *presentController;
@property (copy, nonatomic) NSString *year;
@property (copy, nonatomic) NSString *month;
@property (copy, nonatomic) NSString *day;

@end

@implementation XLDatePickerViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    
    [self.view addSubview:self.datePickerView];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.cancelButton];
    [self.view addSubview:self.sureButton];
    
}

#pragma mark -
#pragma mark - Public Method

- (void)showDatePickerViewForm:(UIViewController *)contentView {
    self.presentController = contentView;
    self.view.height = adaptHeight1334(257*2);
    XLDimmingPresentationController *pc = [[XLDimmingPresentationController alloc] initWithPresentedViewController:self presentingViewController:contentView];
    self.transitioningDelegate = pc;
    [contentView presentViewController:self animated:YES completion:nil];
}

#pragma mark -
#pragma mark - Button Action

- (void)cancelButtonAction {
    [self.presentController dismissViewControllerAnimated:YES completion:nil];
}

- (void)sureButtonAction {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"y-M-d"];
    NSString *value = [dateFormatter stringFromDate:self.datePickerView.date];
    if ([self.delegate respondsToSelector:@selector(finishToChooseDate:)]) {
        [self.delegate finishToChooseDate:value];
    }
    [self.presentController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark - Lazy load

- (UIDatePicker *)datePickerView {
    if (!_datePickerView) {
        _datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, adaptHeight1334(42*2), SCREEN_WIDTH, adaptHeight1334(215*2))];
        _datePickerView.backgroundColor = [UIColor whiteColor];
        _datePickerView.datePickerMode = UIDatePickerModeDate;
        NSDate* maxDate = [NSDate date];
        _datePickerView.maximumDate = maxDate;
    }
    return _datePickerView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, adaptHeight1334(41.5*2))];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, adaptWidth750(64*2), adaptHeight1334(41.5*2))];
        [_cancelButton setTitle:@"取消" forState:normal];
        [_cancelButton setTitleColor:GetColor(COLOR333333) forState:normal];
        [_cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - adaptWidth750(64*2), 0, adaptHeight1334(64*2), adaptHeight1334(41.5*2))];
        [_sureButton setTitle:@"确定" forState:normal];
        [_sureButton setTitleColor:GetColor(COLOR333333) forState:normal];
        [_sureButton addTarget:self action:@selector(sureButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (XLDatePickerViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[XLDatePickerViewModel alloc] init];
    }
    return _viewModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
