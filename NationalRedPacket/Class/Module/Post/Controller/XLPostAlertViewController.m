//
//  XLPostViewController.m
//  NationalRedPacket
//
//  Created by Ying on 2018/7/11.
//  Copyright © 2018 XLook. All rights reserved.
//

#import "XLPostAlertViewController.h"
#import "XLDimmingPresentationController.h"
#import "XLPostAlertTableViewCell.h"
#import "XLPostAlertViewModel.h"
#import "XLPosrPhotoTools.h"
#import "XLPostInputViewController.h"
#import "BaseNavigationController.h"
#import <Photos/Photos.h>


@interface XLPostAlertViewController () <UITableViewDelegate, UITableViewDataSource ,XLPostAlertTableViewCellDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, XLPostAlertViewModelDelegate ,XLPostInputViewControllerDelegate>

@property (strong, nonatomic) UIButton *cancelButton;

@property (strong, nonatomic) NSArray *titleArray;  ///标题
@property (strong, nonatomic) NSArray *iconArray;   ///图标

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) XLPostAlertViewModel *viewModel;

@property (strong, nonatomic) UIViewController *presentedController;

@property (assign, nonatomic) BOOL isEnterNextPage;

@end

@implementation XLPostAlertViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleArray = @[@[@"图片",@"视频"]];
        self.iconArray = @[@[@"post_picture",@"post_video"]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (!self.isEnterNextPage) {
        for (UIViewController *vc in self.currentArray) {
            [vc viewWillAppear:YES];
            [vc viewDidAppear:YES];
        }
    }
}

- (void)presentPostAlertViewController:(UIViewController *)contentView {
    self.presentedController = contentView;
    self.view.height = adaptHeight1334(48*2 + 113*2*self.titleArray.count);
    XLDimmingPresentationController *pc = [[XLDimmingPresentationController alloc] initWithPresentedViewController:self presentingViewController:contentView];
    self.transitioningDelegate = pc;
    [contentView presentViewController:self animated:YES completion:nil];
}

#pragma mark -
#pragma mark - Private Method

- (void)configUI {
    [self.view addSubview:self.cancelButton];
    [self.view addSubview:self.tableView];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(adaptHeight1334(48*2));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.cancelButton.mas_top);
        make.height.mas_equalTo(adaptHeight1334(226*self.titleArray.count));
    }];
}

- (void)dismiss {
    [self.presentedController dismissViewControllerAnimated:YES completion:nil];
}

- (void)openPhotoAlbum {
    //调用系统相册的类
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    pickerController.allowsEditing = NO;
    pickerController.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    pickerController.delegate = self;
    [self presentViewController:pickerController animated:YES completion:^{
        self.isEnterNextPage = NO;
    }];
}

- (void)openVideoAlbum {
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    pickerController.allowsEditing = YES;
    pickerController.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    pickerController.mediaTypes = @[(NSString *)kUTTypeMovie];
    pickerController.delegate = self;

    [self presentViewController:pickerController animated:YES completion:^{
        self.isEnterNextPage = NO;
    }];

}


#pragma mark -
#pragma mark - Button Action

- (void)cancelButtonAction {
    [self dismiss];
}

#pragma mark -
#pragma mark - UITableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XLPostAlertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(XLPostAlertTableViewCell.class)];
    cell.delegate = self;
    cell.titleArray = self.titleArray[indexPath.row];
    cell.iconArray = self.iconArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return adaptHeight1334(113*2);
}

#pragma mark -
#pragma mark - XLPostAlertViewDelegate

- (void)didClickItem:(XLPostAlertCollectionViewCell *)item {
    [self.viewModel chooseToOpen:item.title];
}

#pragma mark -
#pragma mark - 相册代理

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    __block UIImage *resultImage = [[UIImage alloc] init];
    NSInteger fileSize = 0;
    XLPostInputViewController *controller = [[XLPostInputViewController alloc] init];
    
    @weakify(self);
    
    void(^finish)(NSURL *) = ^(NSURL *url) { @strongify(self);
        
        BaseNavigationController *nagivation = [[BaseNavigationController alloc] init];
        nagivation.viewControllers = @[controller];
        controller.url = url;
        controller.image = resultImage;
        controller.delegate = self;
        controller.size = fileSize;
        [[UIViewController currentViewController] presentViewController:nagivation animated:YES completion:^{}];
    };
    
    
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.movie"]) {
        NSURL *url = [[NSURL alloc] init];
        resultImage = [XLPosrPhotoTools getImage:[info objectForKey:UIImagePickerControllerMediaURL]];
        url = [info objectForKey:UIImagePickerControllerMediaURL];
        
        
        NSURL *referenceURL = [info objectForKey:UIImagePickerControllerReferenceURL];
        PHFetchResult *fetchResult = [PHAsset fetchAssetsWithALAssetURLs:[NSArray arrayWithObject:referenceURL] options:nil];
        if (!(PHAsset*)fetchResult.firstObject) return;
        PHAsset *videoAsset = (PHAsset*)fetchResult.firstObject;
        PHAssetResource *resource = [[PHAssetResource assetResourcesForAsset:videoAsset] firstObject];
        long long originFileSize = [[resource valueForKey:@"fileSize"] longLongValue];
        fileSize = (NSInteger)originFileSize;
        finish(url);
    } else {
        controller.isImage = YES;
        NSURL *url = [[NSURL alloc] init];
        resultImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        if (@available(iOS 11.0, *)) {
            url = [info objectForKey:UIImagePickerControllerImageURL];
            finish(url);
        } else {
           
            NSURL *imageRefURL = [info valueForKey:UIImagePickerControllerReferenceURL];
            
            PHAsset *asset = [[PHAsset fetchAssetsWithALAssetURLs:@[imageRefURL] options:nil] lastObject];
            
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.synchronous = YES;
            options.networkAccessAllowed = NO;
            options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
            
            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                
                NSNumber * isError = [info objectForKey:PHImageErrorKey];
                NSNumber * isCloud = [info objectForKey:PHImageResultIsInCloudKey];
                
                if ([isError boolValue] || [isCloud boolValue] || ! imageData) {
                    finish(nil);
                    return;
                }
                
                NSString *tempPath = [NSTemporaryDirectory() stringByAppendingString:imageRefURL.lastPathComponent];
                
                NSURL *tempURL = [NSURL fileURLWithPath:tempPath];
                
                [imageData writeToURL:tempURL atomically:YES];
                
                finish(tempURL);
            }];
        
        }
    }
    

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismiss];
}

#pragma mark -
#pragma mark - inputAlert delegate

- (void)dissmissInputView {
    [self dismiss];
}

#pragma mark -
#pragma mark - PostAlert delegate

- (void)openPhotoLibrary {
    self.isEnterNextPage = YES;
    [self openPhotoAlbum];
}

- (void)openVideoLibrary {
    self.isEnterNextPage = YES;
    [self openVideoAlbum];
}


#pragma mark -
#pragma mark - Lazy load

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(32)];
        [_cancelButton setTitleColor:[UIColor colorWithString:COLOR060606] forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithString:COLORB5B5B5] forState:UIControlStateHighlighted];
        CGSize size = CGSizeMake(SCREEN_WIDTH, adaptHeight1334(98));
        [_cancelButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:size] forState:UIControlStateNormal];
        [_cancelButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithString:COLORECECEB] size:size] forState:UIControlStateHighlighted];
        [_cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:XLPostAlertTableViewCell.class forCellReuseIdentifier:NSStringFromClass(XLPostAlertTableViewCell.class)];
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, adaptHeight1334(226 * self.titleArray.count));
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_tableView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(adaptHeight1334(10), adaptHeight1334(10))];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _tableView.bounds;
        maskLayer.path = maskPath.CGPath;
        _tableView.layer.mask = maskLayer;
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                        initWithTarget:self
                                                        action:@selector(handlePan:)];
        [_tableView addGestureRecognizer:panGestureRecognizer];
        
    }
    return _tableView;
}

- (XLPostAlertViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[XLPostAlertViewModel alloc] init];
        _viewModel.delegate = self;
    }
    return _viewModel;
}

#pragma mark -
#pragma mark - Gseture

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self.tableView];
    if (translation.y > 0) {
        self.tableView.frame = CGRectMake(0, translation.y, SCREEN_WIDTH, self.tableView.height);
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [recognizer velocityInView:self.tableView];
        if (self.tableView.frame.origin.y > self.view.height*0.6 || velocity.y > 500) {
            [self dismiss];
        } else {
            [UIView animateWithDuration:0.1f animations:^{
                self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.tableView.height);
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}
@end
