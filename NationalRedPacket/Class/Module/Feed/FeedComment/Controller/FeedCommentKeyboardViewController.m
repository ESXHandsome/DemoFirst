//
//  FeedCommentKeyboardViewController.m
//  NationalRedPacket
//
//  Created by fensi on 2018/4/24.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "FeedCommentKeyboardViewController.h"
#import "HPGrowingTextView.h"
#import "XLEmojiKeyboard.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/ALAssetsLibrary.h>

static CGFloat const TextViewMinHeight = 34;
static CGFloat const TextViewMaxHeight = 70;
static CGFloat const PicturePreviewWidth = 88;

static NSString *TextViewPreviousText = @"";

@interface FeedCommentKeyboardViewController () <HPGrowingTextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet HPGrowingTextView *textView;
@property (weak, nonatomic) IBOutlet UIView *pictureContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *picturePreviewImageView;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picturePreviewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (assign, nonatomic, getter=isPictureHidden) BOOL pictureHidden;
@property (assign, nonatomic, getter=isSubmitting) BOOL submitting;

@property (strong, nonatomic) UIImage *picture;
@property (strong, nonatomic) NSURL *pictureFileURL;

@end

@implementation FeedCommentKeyboardViewController

+ (instancetype)xibViewController {
    FeedCommentKeyboardViewController *vc = [[FeedCommentKeyboardViewController alloc] initWithNibName:NSStringFromClass(FeedCommentKeyboardViewController.class) bundle:nil];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    return vc;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTextView];
    [self setupPicture];
    
    [NSNotificationCenter. defaultCenter addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    if (self.isShortcutShowPhotos) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self tapPhoto:self.photoButton];
        });
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.textView becomeFirstResponder];
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    TextViewPreviousText = self.textView.text;
    [self.textView resignFirstResponder];
}

- (void)setupTextView {

    if (@available(iOS 11.0, *)) {
        self.textView.internalTextView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.textView.delegate = self;
    self.textView.placeholderColor = [UIColor colorWithString:COLOR9A9A9A];
    self.textView.minHeight = TextViewMinHeight;
    self.textView.maxHeight = TextViewMaxHeight;
    self.textView.font = [UIFont systemFontOfSize:15];
    self.textView.textColor = [UIColor colorWithString:COLOR333333];
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.text = TextViewPreviousText;
    
    if (self.toAuthorName) {
        self.textView.placeholder = [NSString stringWithFormat:@"回复%@：", self.toAuthorName];
        self.textView.returnKeyType = UIReturnKeySend;
        self.textView.enablesReturnKeyAutomatically = YES;
    } else {
        self.textView.placeholder = @"期待你的神评论…";
    }
}

- (void)setupPicture {

    self.pictureHidden = YES;
    self.photoButton.enabled = !self.toAuthorName;
}

#pragma mark - IBActions/Event Response

- (IBAction)tapDeletePicture:(UIButton *)sender {
    
    self.picture = nil;
    self.pictureFileURL = nil;
    self.pictureHidden = YES;
}

- (IBAction)tapPhoto:(UIButton *)sender {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [MBProgressHUD showError:@"设备不支持"];
        return;
    }
    
    @weakify(self);

    void(^showPicker)(void) = ^(void) {
        @strongify(self);
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imagePicker.delegate = self;
        imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    };
    
    if (@available(iOS 11.0, *)) {
        
        showPicker();
        
    } else {
    
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            dispatch_async(dispatch_get_main_queue(),^{
                @strongify(self);
                
                if (status != PHAuthorizationStatusAuthorized) {
                    [self showAlertWithTitle:@"相册访问权限关闭了" message:@"请在iPhone的“设置-隐私-照片”中打开神段子的相册访问权限" actionTitles:@[@"好"] actionHandler:nil];
                    return;
                }
                
                showPicker();
            });
        }];
    }
}

- (IBAction)tapSubmit:(UIButton *)sender {
    
    if (!XLLoginManager.shared.isAccountLogined) {
        [LoginViewController showLoginVCFromSource:LoginSourceTypeArticleComment];
        return;
    }
    
    if (self.completion) {
        
        @weakify(self);
        
        self.submitting = YES;
        
        MBProgressHUD *HUD = [MBProgressHUD showChrysanthemum:@"发送中..."];
        HUD.offset = CGPointMake(0, -50);
        
        NSString *content = self.textView.text;
        
        content = [content stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        self.completion(content, self.picture, self.pictureFileURL, !YES, ^(BOOL isSuccess) {
            @strongify(self);
            
            [HUD hideAnimated:NO];
            
            if (isSuccess) {
                self.textView.text = @"";
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                self.submitting = NO;
            }
        });
    }
}

- (IBAction)tapOutside:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - HPGrowingTextViewDelegate

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height {
    
    self.textViewHeightConstraint.constant = height;
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView {
    
    [self updateSubmitButtonEnable];
}

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView {
    
    if (growingTextView.returnKeyType == UIReturnKeySend) {
        [self tapSubmit:self.submitButton];
    }
    
    return NO;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    @weakify(self);
    
    void(^finish)(NSURL *) = ^(NSURL *imageURL) { @strongify(self);
        
        self.picture = image;
        self.pictureFileURL = imageURL;
        self.pictureHidden = NO;
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    };
    
    if (@available(iOS 11.0, *)) {
        
        finish(info[UIImagePickerControllerImageURL]);
        
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

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.title = @"所有照片";
}

#pragma mark - UIKeyboardNotification

- (void)keyboardWillChangeFrameNotification:(NSNotification *)noti {
    
    CGRect rect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationCurve curve = [noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    self.bottomConstraint.constant = CGRectGetHeight(rect);
    
    [UIView setAnimationCurve:curve];
    [UIView animateWithDuration:duration-0.05 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Public



#pragma mark - Private

- (void)updateSubmitButtonEnable {
    self.submitButton.enabled = (self.picture || ![NSString isBlankString:self.textView.text]) && !self.isSubmitting;
}

#pragma mark - Custom Accessors

- (void)setSubmitting:(BOOL)submitting {
    _submitting = submitting;
    
    [self updateSubmitButtonEnable];
}

- (void)setPicture:(UIImage *)picture {
    _picture = picture;
    
    self.picturePreviewImageView.image = picture;
    [self updateSubmitButtonEnable];
}

- (void)setPictureHidden:(BOOL)pictureHidden{
    _pictureHidden = pictureHidden;
    
    if (pictureHidden) {
        self.picturePreviewWidthConstraint.constant = 0;
        self.textView.minHeight = TextViewMinHeight;
    } else {
        self.picturePreviewWidthConstraint.constant = PicturePreviewWidth;
        self.textView.minHeight = TextViewMaxHeight - 1;
    }
    
    [self.view layoutIfNeeded];
    [self.textView refreshHeight];
}

@end
