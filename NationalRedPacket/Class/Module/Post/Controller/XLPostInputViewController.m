//
//  XLPostInputViewController.m
//  NationalRedPacket
//
//  Created by Ying on 2018/7/12.
//  Copyright © 2018 XLook. All rights reserved.
//

#import "XLPostInputViewController.h"
#import "XLPostInputViewModel.h"
#import "HPGrowingTextView.h"
#import "XLMyUploadViewController.h"

@interface XLPostInputViewController () <HPGrowingTextViewDelegate, XLPostInputViewModelDelegate, XLMyUploadViewControllerDelegate>
@property (weak, nonatomic) IBOutlet HPGrowingTextView *textField;
@property (weak, nonatomic) IBOutlet UIImageView *videoSign;
@property (strong, nonatomic) XLPostInputViewModel *viewModel;

@end

@implementation XLPostInputViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [StatServiceApi sharedService].lastVCStr = self.isImage ? @"XLPublishImageViewController" : @"XLPublishVideoViewController";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [StatServiceApi sharedService].currentVCStr = self.isImage ? @"XLPublishImageViewController" : @"XLPublishVideoViewController";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = self.image;
   
    
    if (@available(iOS 11.0, *)) {
        self.textField.internalTextView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self configTextField];
    
    if (self.isImage) {
        self.videoSign.hidden = YES;
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:GetImage(@"popup_delete") style:normal target:self action:@selector(cancelButtonAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:normal target:self action:@selector(sendButtonAction)];
    self.navigationItem.rightBarButtonItem.tintColor = GetColor(COLORFE6969);
}

- (void)configTextField {
    self.textField.delegate = self;
    self.textField.placeholderColor = [UIColor colorWithString:COLOR9A9A9A];
    self.textField.minHeight = adaptHeight1334(34*2);
    self.textField.maxHeight = adaptHeight1334(132*2);
    self.textField.font = [UIFont systemFontOfSize:16];
    self.textField.textColor = [UIColor colorWithString:COLOR333333];
    self.textField.backgroundColor = [UIColor clearColor];
    self.textField.text = @"";
    self.textField.placeholder = @"更多段子等你发现";
    
}

#pragma mark -
#pragma mark - Button Action

- (void)cancelButtonAction {
    if ([self.delegate respondsToSelector:@selector(dissmissInputView)]) {
        [self.delegate dissmissInputView];
    }
}

- (void)sendButtonAction {
    if (self.isImage) {
        [self.viewModel uploadPicture:self.image url:self.url item:self.textField.text];
    } else {
        if (self.size/1024/1024 > 100) {
            [MBProgressHUD showError:@"上传视频不能大于100M"];
        } else {
            [self.viewModel uploadVideo:self.image url:self.url title:self.textField.text size:self.size];
        }
    }
    [StatServiceApi statEvent:USER_PUBLISH_SEND_CLICK model:nil otherString:self.isImage ? @"image" : @"video"];
}

#pragma mark -
#pragma mark - ViewModel delegate

- (void)showMyUploadViewController {
    
    XLMyUploadViewController *controller = [XLMyUploadViewController new];
    controller.isUploadAlertPush = YES;
    controller.delegate = self;
    [self showViewController:controller sender:nil];
    
    [StatServiceApi statEvent:USER_PUBLISH_SUCCESS model:nil otherString:self.isImage ? @"image" : @"video"];
}

#pragma mark -
#pragma mark - XLMyUploadViewControllerDelegate

- (void)didClickCancelButton {
    if ([self.delegate respondsToSelector:@selector(dissmissInputView)]) {
        [self.delegate dissmissInputView];
    }
}

#pragma mark -
#pragma mark - Lazy load

- (XLPostInputViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[XLPostInputViewModel alloc] init];
        _viewModel.delegate = self;
    }
    return _viewModel;
}

@end
