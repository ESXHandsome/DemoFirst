//
//  XLCityPickerViewController.m
//  NationalRedPacket
//
//  Created by Ying on 2018/7/27.
//  Copyright © 2018 XLook. All rights reserved.
//

#import "XLCityPickerViewController.h"
#import "XLDimmingPresentationController.h"
#import "XLCityPickerViewModel.h"

@interface XLCityPickerViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIPickerView *cityPickerView;
@property (strong, nonatomic) XLCityPickerViewModel *viewModel;
@property (strong, nonatomic) XLPickerItem *currentItem;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *sureButton;
@property (strong, nonatomic) UIViewController *presentController;
@property (copy, nonatomic) NSString *province;
@property (copy, nonatomic) NSString *city;

@end

@implementation XLCityPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    
    [self.view addSubview:self.cityPickerView];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.cancelButton];
    [self.view addSubview:self.sureButton];
    
}

#pragma mark -
#pragma mark - PickerView delegate and dataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) {
        
        return self.viewModel.dataSource.count;
    } else {
        return self.currentItem.datas.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return self.viewModel.dataSource[row].name;
    } else {
        return self.currentItem.datas[row].name;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.currentItem = self.viewModel.dataSource[row];
        self.province = self.viewModel.dataSource[row].name;
        [self.cityPickerView reloadComponent:1];
    } else {
        self.city = self.currentItem.datas[row].name;
    }
}

#pragma mark -
#pragma mark - Public Method

- (void)showCityPickerViewForm:(UIViewController *)contentView {
    self.presentController = contentView;
    self.view.height = adaptHeight1334(257*2);
    XLDimmingPresentationController *pc = [[XLDimmingPresentationController alloc] initWithPresentedViewController:self presentingViewController:contentView];
    self.transitioningDelegate = pc;
    [contentView presentViewController:self animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Button Action

- (void)cancelButtonAction {
    [self.presentController dismissViewControllerAnimated:YES completion:nil];
}

- (void)sureButtonAction {
    if ([self.delegate respondsToSelector:@selector(finishToChoose:city:)]) {
        [self.delegate finishToChoose:self.province city:self.city];
    }
    [self.presentController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark - Lazy load

- (UIPickerView *)cityPickerView {
    if (!_cityPickerView) {
        _cityPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, adaptHeight1334(42*2), SCREEN_WIDTH, adaptHeight1334(215*2))];
        _cityPickerView.backgroundColor = [UIColor whiteColor];
        _cityPickerView.delegate = self;
        _cityPickerView.dataSource = self;
    }
    return _cityPickerView;
}

- (XLCityPickerViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[XLCityPickerViewModel alloc] init];
    }
    return _viewModel;
}

- (XLPickerItem *)currentItem {
    if (!_currentItem) {
        _currentItem = self.viewModel.dataSource.firstObject;
    }
    return _currentItem;
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

- (NSString *)province {
    if (!_province) {
        _province = @"湖南省";
    }
    return _province;
}

- (NSString *)city {
    if (!_city) {
        _city = self.currentItem.datas.firstObject.name;
    }
    return _city;
}

@end
