//
//  XLEditPersonInfoViewController.m
//  NationalRedPacket
//
//  Created by Ying on 2018/7/26.
//  Copyright © 2018 XLook. All rights reserved.
//

#import "XLEditPersonInfoViewController.h"
#import "XLEditPersonInfoViewModel.h"
#import "XLEditPersonInfoTableViewCell.h"
#import "XLCityPickerViewController.h"
#import "XLDatePickerViewController.h"
#import "XLClipViewController.h"

@interface XLEditPersonInfoViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource, XLDatePickerDelegate, XLCityPickerDelegate ,ClipViewControllerDelegate ,XLEditPersonInfoTableViewCellDelegate, XLEditPersonInfoViewModelDelegate>

@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *iconUnderLabel;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) XLEditPersonInfoViewModel *viewModel;

@property (copy, nonatomic) UIImage *avatar;
@property (copy, nonatomic) NSString *birthDateString;
@property (copy, nonatomic) NSString *cityString;
@property (copy, nonatomic) NSString *provinceString;
@property (copy, nonatomic) NSString *sexString;
@property (copy, nonatomic) NSString *introduceString;
@property (copy, nonatomic) NSString *nameString;

@end

@implementation XLEditPersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"个人资料";
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];
    [self.viewModel configDataSource];
    [self configUI];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideKeyboard];
}

- (void)hideKeyboard {
    //隐藏cell中的键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
}

#pragma mark -
#pragma mark - Picker delegate

- (void)finishToChooseDate:(NSString *)timeString {
    XLEditPersonInfoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    cell.tailLabel.text = timeString;
    self.birthDateString = timeString;
}

- (void)finishToChoose:(NSString *)province city:(NSString *)city {
    XLEditPersonInfoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    cell.tailLabel.text = [province stringByAppendingString:city];
    self.provinceString = province;
    self.cityString = city;
}
#pragma mark -
#pragma mark - 相册 delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage * image = info[@"UIImagePickerControllerOriginalImage"];
    XLClipViewController * clipView = [[XLClipViewController alloc]initWithImage:image];
    clipView.delegate = self;
    [picker pushViewController:clipView animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark - Clip View delegate
- (void)ClipViewController:(XLClipViewController *)clipViewController FinishClipImage:(UIImage *)editImage {
    self.iconImageView.image = editImage;
    self.avatar = editImage;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark - Gesture Action

- (void)tapGesAction {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self showViewController:controller sender:nil];
}

#pragma mark -
#pragma mark - Public Method

- (void)configUI {
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishButtonAction)];
    [barButton setTintColor:GetColor(COLORFB3958)];
    self.navigationItem.rightBarButtonItem = barButton;
    
    [self.view addSubview:self.iconImageView];
    [self.view addSubview:self.iconUnderLabel];
    [self.view addSubview:self.tableView];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(adaptHeight1334(40*2)+NAVIGATION_BAR_HEIGHT);
        make.height.mas_equalTo(adaptHeight1334(80*2));
        make.width.mas_equalTo(adaptWidth750(80*2));
    }];
    
    [self.iconUnderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(adaptHeight1334(8*2));
        make.centerX.equalTo(self.iconImageView);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconUnderLabel.mas_bottom).offset(adaptHeight1334(15*2));
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.dataSource.avatar] placeholderImage:GetImage(@"my_avatar")];
}

#pragma mark -
#pragma mark - viewModel delegate

- (void)finishToUploadPersonInfo {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - Cell delegate

- (void)textFieldDidBeginEdit {
    [UIView animateWithDuration:0.2 animations:^{
        self.tableView.y = self.tableView.y - adaptHeight1334(120*2);
    }];
}

- (void)textFieldDidFinidh:(NSString *)string {
    [UIView animateWithDuration:0.2 animations:^{
        self.tableView.y = self.tableView.y + adaptHeight1334(120*2);
    }];
}

- (void)nameFieldDidFinish:(NSString *)name {
    self.nameString = name;
}

- (void)introFieldDidFinish:(NSString *)intro {
    self.introduceString = intro;
}

- (void)changeSexFinish:(NSString *)sex {
    self.sexString = sex;
}

#pragma mark -
#pragma mark - TableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 3) {
        XLCityPickerViewController *controller = [[XLCityPickerViewController alloc] init];
        controller.delegate = self;
        [controller showCityPickerViewForm:self];
    } else if (indexPath.row == 2){
        XLDatePickerViewController *controller = [[XLDatePickerViewController alloc] init];
        [controller showDatePickerViewForm:self];
        controller.delegate = self;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XLEditPersonInfoTableViewCell *cell = [[XLEditPersonInfoTableViewCell alloc]
                                           initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:@"cell"];
    [cell configTableViewCell:self.viewModel.dataSource
                        title:self.viewModel.items[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        return adaptHeight1334(82*2);   
    }
    return adaptHeight1334(54*2);
}

#pragma mark -
#pragma mark - Button Action

- (void)finishButtonAction {

    XLPersonInfoModel *model = [[XLPersonInfoModel alloc] init];
    model.avatar = self.avatar;
    model.nickname = self.nameString;
    model.sex = self.sexString;
    model.birth = self.birthDateString;
    model.province = self.provinceString;
    model.city = self.cityString;
    model.intro = self.introduceString;
    [self.viewModel uploadPersonInfo:model];
    
}

#pragma mark -
#pragma mark - lazy load

- (UIImageView *)iconImageView {
    
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.userInteractionEnabled = YES;
        _iconImageView.image = GetImage(@"my_avatar");
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesAction)];
        [_iconImageView addGestureRecognizer:tapGesture];
        _iconImageView.layer.cornerRadius = adaptHeight1334(80);
        _iconImageView.layer.masksToBounds = YES;
    }
    return _iconImageView;

}

- (UILabel *)iconUnderLabel {
    if (!_iconUnderLabel) {
        _iconUnderLabel = [UILabel labWithText:@"点击修改头像"
                                     fontSize:adaptFontSize(12*2)
                              textColorString:COLOR999999];
    }
    return _iconUnderLabel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = GetColor(COLORF7F7F7);
    }
    return _tableView;
}

- (XLEditPersonInfoViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[XLEditPersonInfoViewModel alloc] init];
        _viewModel.delegate = self;
    }
    return _viewModel;
}

@end
