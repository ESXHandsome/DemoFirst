//
//  PPSPhotoShowView.m
//  NationalRedPacket
//  图片预览模块
//  此模块没有进行cell的复用 （一次性加载了所有的图片，性能消耗较大）
//  Created by Ying on 2018/2/22.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "XLPhotoShowView.h"
#import "PPSPhotoGroupCell.h"
#import "PPSAlertView.h"
#import "ImageCell.h"
#import "CALayer+Add.h"
#import "UIImage+Tool.h"
#include <math.h>
#import "WechatShare.h"
#import "PPSSavePhoto.h"
#define kPadding 20


@interface XLPhotoShowView() <UIScrollViewDelegate, UIGestureRecognizerDelegate,XLPhotoShowViewDelegate>

@property (strong, nonatomic) UIImageView  *background;
@property (strong, nonatomic) UIImageView  *blurBackground;
@property (strong, nonatomic) UIView       *contentView;
@property (strong, nonatomic) UIImageView  *pageView;
@property (strong, nonatomic) UILabel      *pageLabel;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (weak, nonatomic)   UIView       *toContainerView;
@property (assign, nonatomic) NSInteger    page;
@property (strong, nonatomic) NSMutableArray *cells;
@property (strong, nonatomic) PPSPhotoGroupCell *cell;
@property (assign, nonatomic) int contentSizeX;

@end

@implementation XLPhotoShowView
-(instancetype)initWithGroupItems:(NSArray *)groupItems{
    self = [super init];
    
    self.isHaveAlertView = YES;
    if (groupItems.count == 0) return nil;
    _groupItems = groupItems.copy;
    _blurEffectBackground = YES;
    
    self.frame = [UIScreen mainScreen].bounds;
    self.clipsToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tap2.delegate = self;
    tap2.numberOfTapsRequired = 2;
    [tap requireGestureRecognizerToFail: tap2];
    [self addGestureRecognizer:tap2];
    
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    press.delegate = self;
    [self addGestureRecognizer:press];
    
    _background = [UIImageView new];
    _background.frame = self.bounds;
    _background.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _background.backgroundColor = [UIColor blackColor];
    
    _contentView = [UIView new];
    _contentView.frame = self.frame;
    _contentView.clipsToBounds = YES;
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    //一张图不显示页号 页号覆盖也不显示
    if(_groupItems.count>1){
        _pageView = [UIImageView new];
        _pageView.frame = CGRectMake(0, IS_IPHONE_X?STATUS_BAR_HEIGHT:0, self.bounds.size.width, adaptHeight1334(120));
        _pageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.startPoint = CGPointMake(0, 0);
        gradient.endPoint = CGPointMake(0, 1);
        gradient.frame = _pageView.frame;
        UIColor *colorOne = [UIColor colorWithRed:(0/255.0)  green:(0/255.0)  blue:(0/255.0)  alpha:0.15];
        UIColor *colorTwo = [UIColor colorWithRed:(0/255.0)  green:(0/255.0)  blue:(0/255.0)  alpha:0.0];
        NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
        gradient.colors = colors;
        [_pageView.layer insertSublayer:gradient atIndex:0];
                
        _pageLabel = [UILabel new];
        _pageLabel.frame = CGRectMake(0, 0, adaptWidth750(64), adaptHeight1334(56));
        _pageLabel.center = _pageView.center;
        _pageLabel.text = [NSString stringWithFormat:@"%ld/%lu", (long)_page,(unsigned long)_groupItems.count];
        _pageLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:20];
        _pageLabel.textColor = [UIColor colorWithString:COLORffffff];
        _pageLabel.alpha = 1;
        _pageLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        _pageLabel.shadowOffset = CGSizeMake(0, 1);
        _pageLabel.backgroundColor = [UIColor clearColor];
        [_pageLabel sizeToFit];
    }
    
    [self addSubview:self.background];
    [self addSubview:self.contentView];
    [_contentView addSubview:self.scrollView];
    [_contentView addSubview:self.pageView];
    [_contentView addSubview:self.pageLabel];
    
    //隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    
    NSArray *vcArray = [[StatServiceApi sharedService] screenDisplayViewController];
    for (UIViewController *vc in vcArray) {
        [vc viewWillDisappear:NO];
        [vc viewDidDisappear:NO];
    }
    
    [StatServiceApi sharedService].currentVCStr = @"ImageBrowserViewController";
    
}

- (void)viewDidDisAppear:(BOOL)animated {
    
    [StatServiceApi sharedService].lastVCStr = @"ImageBrowserViewController";
    
    NSArray *vcArray = [[StatServiceApi sharedService] screenDisplayViewController];
    for (UIViewController *vc in vcArray) {
        [vc viewWillAppear:NO];
    }
}

-(void)presentFromImageView:(UIView *)fromView toContainer:(UIView *)container animated:(BOOL)animated completion:(void (^)(void))completion{
    
    if (!container) return;
    
    if (!fromView) {
        fromView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2, 1, 1)];
    }
    
    [self viewWillAppear:YES];
    
    _contentSizeX = 0;
    _fromView = fromView;
    _toContainerView = container;
    [_toContainerView addSubview:self];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    _scrollView.contentSize = CGSizeMake((SCREEN_WIDTH + kPadding)*_groupItems.count, 0);
    _scrollView.contentOffset = CGPointMake((SCREEN_WIDTH + kPadding)*_currentPage, 0);
    [self scrollViewDidScroll:_scrollView];//保证页码正确
    _cells = @[].mutableCopy;
    /*配置界面*/
    for (int i = 0; i<self.groupItems.count; i++){
        
        //父视图
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(i * (SCREEN_WIDTH +kPadding), 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        view.userInteractionEnabled = YES;
        view.clipsToBounds = YES;
        [_scrollView addSubview:view];
        
        //图片
        ImageModel *imageModel = _groupItems[i];
        PPSPhotoGroupCell *cell = [[PPSPhotoGroupCell alloc] init];
        cell.cellDelegate = self;
        UIImageView *placeholder = [UIImageView new];
        if (!imageModel.isOnLocal) {
            [placeholder sd_setImageWithURL:[NSURL URLWithString:imageModel.preview]];
            UIImage *image = placeholder.image;
            image = [self scaleToSize:image];
            [cell initWithURL:[NSURL URLWithString:imageModel.originalImage] placeholderImage:image];
        } else {
            if (imageModel.originalImage) {
                UIImage *image = [UIImage imageWithContentsOfFile:imageModel.preview];
                [cell initWithURL:[NSURL URLWithString:imageModel.originalImage] placeholderImage:image];
            } else {
                cell.imageView.image = [UIImage imageWithContentsOfFile:imageModel.imagePath];
            }
           
        }
        
        cell.center = self.center;
        [view addSubview:cell];
        [_cells addObject:cell];
    }
    
    ImageModel *imageModel = _groupItems[_page-1];
    PPSPhotoGroupCell *cell = [self cellForPage:_page];
    cell.isShowView = YES;
    
    /*gif判断*/
    if (cell.isGif){
        [cell restartGif];
    }
    BOOL isLongPhoto = [imageModel.width doubleValue]/[imageModel.height doubleValue]<0.56;
    BOOL isAloneLongPhote = [imageModel.width doubleValue]/[imageModel.height doubleValue]<0.75 && _groupItems.count == 1;
    
    /*非详情页长图*/
    if ( isLongPhoto) {
        cell.imageContainerView.size = CGSizeMake(cell.width, cell.height);
        CGRect fromFrame = [_fromView convertRect:_fromView.bounds toView:cell];
        CGFloat scale = fromFrame.size.width / cell.imageContainerView.width;
        cell.imageContainerView.height = cell.imageContainerView.width;
        cell.imageContainerView.centerX = CGRectGetMidX(fromFrame);
        cell.imageContainerView.centerY = CGRectGetMidY(fromFrame);
        /*单张长图*/
        if (self.groupItems.count == 1) {
            cell.imageContainerView.frame = fromFrame;
        }
        cell.imageContainerView.layer.transformScale = scale;
        cell.imageView.contentMode = UIViewContentModeTop;
        
        float oneTime = animated ? 0.25 : 0;
        [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            cell.imageContainerView.layer.transformScale = 1;
            cell.imageContainerView.frame = [UIScreen mainScreen].bounds;

        }completion:^(BOOL finished) {
            if (cell.isLongPhoto){
                CGFloat height = SCREEN_WIDTH/[imageModel.width floatValue]*[imageModel.height floatValue];
                cell.imageContainerView.size = CGSizeMake(SCREEN_WIDTH, height);
                cell.contentSize = CGSizeMake(SCREEN_WIDTH, height);
                cell.imageView.size = CGSizeMake(SCREEN_WIDTH, height);
            }
        }];
        
    }
    /*判断详情页长图*/
    else if(self.isDetail && isAloneLongPhote && !cell.isGif){
        _fromView = [_delegate dismissAction:_page];
        CGRect frameFrame = [_fromView convertRect:_fromView.bounds toView:cell];
        CGRect originFrame = cell.imageContainerView.frame;
        float oneTime = animated ? 0.25 : 0;
        cell.imageContainerView.frame = frameFrame;
        [UIView animateWithDuration:oneTime animations:^{
            cell.imageContainerView.frame = originFrame;
            cell.imageContainerView.height = [imageModel.height floatValue];
        }];
    }
    /*非详情页*/
    else{
        _fromView = [_delegate dismissAction:_page];
        CGRect fromFrame = [_fromView convertRect:_fromView.bounds toView:[UIApplication sharedApplication].keyWindow];
        CGRect originFrame = cell.imageContainerView.frame;
        CGFloat scale = fromFrame.size.width / cell.imageContainerView.width;
        
        cell.imageContainerView.centerX = CGRectGetMidX(fromFrame);
        cell.imageContainerView.layer.transformScale = scale;
        cell.imageContainerView.centerY = CGRectGetMidY(fromFrame);
        
        float oneTime = animated ? 0.25 : 0;
        [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.imageContainerView.layer.transformScale = 1;
            cell.imageContainerView.frame = originFrame;
            
        }completion:^(BOOL finished) {
            if (cell.isLongPhoto){
                cell.imageContainerView.height = cell.contentSize.height;
            }
        }];
    }
}

- (PPSPhotoGroupCell *)cellForPage:(NSInteger)page {
    PPSPhotoGroupCell *cell;
    if(_page<1){
        cell = _cells.firstObject;
    }else{
        cell = _cells[page-1];
    }
    return cell;
}

//页码逻辑
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat width = SCREEN_WIDTH+kPadding;
    CGFloat contentOfSize = _scrollView.contentOffset.x;
    double result = fmod(contentOfSize,width);
    if(result == 0){
        int num = contentOfSize/width;
        if (_contentSizeX != num){
            _contentSizeX = num;
            for (PPSPhotoGroupCell *cell in _cells) {
                cell.zoomScale = 1;
                cell.contentOffset = CGPointMake(0, 0);
            }
        }
    }
    
    if(_pageLabel){
        NSInteger page = _page;
        CGFloat pageWidth = _scrollView.frame.size.width;
        _page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 2;
        if (page != _page) {
            PPSPhotoGroupCell *cell = [self cellForPage:page];
            [cell stopGif];
            [cell removeCache];
            _fromView.hidden = NO;
            _fromView = [_delegate dismissAction:_page];
            _pageLabel.text = [NSString stringWithFormat:@"%ld/%lu", (long)_page,(unsigned long)_groupItems.count];
            _fromView.hidden = YES;
            if(_scrollView.subviews.count>0){
                PPSPhotoGroupCell *cell = [self cellForPage:_page];
                if (cell.isGif){
                    [cell restartGif];
                }
            }
        }
    }else{
        _page = 1;
        _fromView.hidden = YES;
    }
}

//关闭
-(void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion{
    _fromView.hidden = NO;
    _fromView = [_delegate dismissAction:_page];
    _fromView.hidden = YES;
    
    //显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    PPSPhotoGroupCell *cell = [self cellForPage:_page];
    cell.zoomScale = 1;

    ImageModel *imageModel = _groupItems[_page-1];
    BOOL isAloneLongDetailPhoto = _cells.count == 1 ? YES : NO;
    isAloneLongDetailPhoto = isAloneLongDetailPhoto && _isDetail ? YES : NO;
    if (_groupItems.count == 1 && !cell.isGif && !_isDetail){
        if([imageModel.width doubleValue]/[imageModel.height doubleValue]<0.75 ){
            //单图长图
            [self scaleSquareAnimated];
        }else if([imageModel.width doubleValue]/[imageModel.height doubleValue]<1.33 && [imageModel.width doubleValue]/[imageModel.height doubleValue] >1){
            [self scaleUpAndDownAnimated];
        }else{
            [self shortPhotoDismissAnimated];
        }
    }
    else if (cell.isLongPhoto && !isAloneLongDetailPhoto){
        if (![UIImage isPiiicWithImage:cell.imageView.image]){
            //类长图
            [self middlePhotoDismissAnimated];
        }
        else{
            //长图
            [self longPhotoDismissAnimated];
        }
    }else{
        //非长图
        [self shortPhotoDismissAnimated];
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (ImageModel *model in self.groupItems){
            [[SDImageCache sharedImageCache] removeImageForKey:model.originalImage fromDisk:NO withCompletion:nil];
        }
    });
    
}
-(void)scaleSquareAnimated{
    PPSPhotoGroupCell *cell = [self cellForPage:_page];
    self.background.hidden = YES;
    self.pageLabel.hidden = YES;
    self.pageView.hidden = YES;
    cell.contentOffset = CGPointMake(0, 0);
    if(cell.imageView.height>SCREEN_HEIGHT){
       cell.imageContainerView.frame = self.frame;
    }else{
        cell.imageContainerView.frame = [cell.imageView convertRect:cell.imageView.bounds toView:cell];
        cell.imageView.origin = CGPointMake(0, 0);
    }
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect fromFrame = [self.fromView convertRect:self.fromView.bounds toView:cell];
        CGFloat scale = fromFrame.size.width / cell.imageContainerView.width * cell.zoomScale;
        cell.imageContainerView.height = fromFrame.size.height/scale;
        UIView *view = [[UIView alloc] initWithFrame:fromFrame];
        cell.imageContainerView.center = view.center;
        cell.imageContainerView.layer.transformScale = scale;
    }completion:^(BOOL finished) {
        [self.delegate dismissAtCurrentPage:self.page];
        [self removeFromSuperview];
        self.fromView.hidden = NO;
        
    }];
}

-(void)scaleUpAndDownAnimated{
    PPSPhotoGroupCell *cell = [self cellForPage:self.page];
    CGRect fromFrame = [_fromView convertRect:_fromView.bounds toView:cell];
    self.background.backgroundColor = [UIColor clearColor];
    self.pageView.hidden = YES;
    self.pageLabel.hidden = YES;
    cell.loadingView .hidden = YES;
    cell.contentOffset = CGPointMake(0, 0);
    [UIView animateWithDuration:0.25 animations:^{
        cell.imageView.frame = fromFrame;
        cell.y+=adaptWidth750(20*2);
    } completion:^(BOOL finished) {
        self.fromView.hidden = NO;
        [self.delegate dismissAtCurrentPage:self.page];
        [self removeFromSuperview];
    }];
}

-(void)longPhotoDismissAnimated{
    PPSPhotoGroupCell *cell = [self cellForPage:_page];
    self.background.hidden = YES;
    self.pageLabel.hidden = YES;
    self.pageView.hidden = YES;
    cell.contentOffset = CGPointMake(0, 0);
    cell.imageContainerView.frame = self.frame;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect fromFrame = [self.fromView convertRect:self.fromView.bounds toView:cell];
        
        CGFloat scale = fromFrame.size.width / cell.imageContainerView.width * cell.zoomScale;
        if(fromFrame.size.width != fromFrame.size.height){
            cell.imageContainerView.height = cell.imageContainerView.width/fromFrame.size.height*fromFrame.size.width;
        }else{
            cell.imageContainerView.height = cell.imageContainerView.width;
        }
        
        UIView *view = [[UIView alloc] initWithFrame:fromFrame];
        cell.imageContainerView.center = view.center;
        cell.imageContainerView.layer.transformScale = scale;
    }completion:^(BOOL finished) {
        [self.delegate dismissAtCurrentPage:self.page];
        [self removeFromSuperview];
        self.fromView.hidden = NO;
        
    }];
}
-(void)shortPhotoDismissAnimated{
    PPSPhotoGroupCell *cell = [self cellForPage:self.page];
    CGRect fromFrame = [_fromView convertRect:_fromView.bounds toView:nil];
    self.background.backgroundColor = [UIColor clearColor];
    self.pageView.hidden = YES;
    self.pageLabel.hidden = YES;
    cell.contentOffset = CGPointMake(0, 0);
    cell.loadingView.hidden = YES;
    [UIView animateWithDuration:0.25 animations:^{
        cell.imageView.frame = fromFrame;
    } completion:^(BOOL finished) {
        self.fromView.hidden = NO;
        [self.delegate dismissAtCurrentPage:self.page];
        [self removeFromSuperview];
    }];
}
-(void)middlePhotoDismissAnimated{
    PPSPhotoGroupCell *cell = [self cellForPage:self.page];
    CGRect fromFrame = [_fromView convertRect:_fromView.bounds toView:cell];
    self.background.backgroundColor = [UIColor clearColor];
    self.pageView.hidden = YES;
    self.pageLabel.hidden = YES;
    cell.loadingView .hidden = YES;
    cell.contentOffset = CGPointMake(0, 0);
    [UIView animateWithDuration:0.25 animations:^{
        cell.imageView.frame = fromFrame;
    } completion:^(BOOL finished) {
        self.fromView.hidden = NO;
        [self.delegate dismissAtCurrentPage:self.page];
        [self removeFromSuperview];
    }];
}

-(void)dismiss{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    PPSPhotoGroupCell *cell = [self cellForPage:self.page];
    if (cell.zoomScale != 1) {
        [UIView animateWithDuration:0.2 animations:^{
            cell.zoomScale = 1 ;
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissAnimated:YES completion:nil];
        });
        return;
    }
    
    if (cell.loadingView) {
        cell.loadingView.hidden = YES;
    }
    
    [self dismissAnimated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self viewDidDisAppear:YES];
    });
    
}

/*截屏 用于长图作为消失动画*/
- (UIImage *)viewSnapshot:(UIView *)view withInRect:(CGRect)rect;
{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef resultCGImage = CGImageCreateWithImageInRect(image.CGImage,rect);
    UIImage *resultImage = [UIImage imageWithCGImage:resultCGImage];
    CGImageRelease(resultCGImage);
    return resultImage;
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress {
    if([longPress state] == UIGestureRecognizerStateBegan){
        PPSAlertView *alert = [[PPSAlertView alloc] init];
        if (self.isHaveAlertView) { /**他就提这种需求 没办法我只能这么写*/
            [alert addCellForAlerView:@"发送给微信好友" style:AlertActionStyleDefault Action:^{
                [self wechatShare];
            }];
            [alert addCellForAlerView:@"发送至微信朋友圈" style:AlertActionStyleDefault Action:^{
                [self timeLineShare];
            }];
        }
        [alert addCellForAlerView:@"保存图片" style:AlertActionStyleDefault Action:^(){
            [self savePhoto];
        }];
        [alert addCellForAlerView:@"取消" style:AlertActionStyleCancel Action:nil];
        [alert showWithAnimation:YES];
    }
    
}
#pragma mark 照片展示窗
//微信好友分享
- (void)wechatShare{
    self.newsModel.shareCompleteURL = [XLFeedModel completeShareURL:self.newsModel withRefrence:WX_SESSION];
    @weakify(self);
    [[WechatShare sharedInstance] shareNewsDetail:self.newsModel to:WechatSceneSession sendReqCallback:^(int code) {
        @strongify(self);
        if (code == 0) {
            [StatServiceApi statEvent:IMAGE_FORWARDED model:self.newsModel otherString:WECHAT_SESSION_CHANNEL];
        }
    }];
    //分享朋友
    [StatServiceApi statEvent:IMAGE_FORWARD model:self.newsModel otherString:WECHAT_SESSION_CHANNEL];
    [StatServiceApi statEvent:IMAGE_FORWARD_TYPE model:self.newsModel otherString:WECHAT_SESSION_CHANNEL];
    [TalkingData trackEvent:WECHAT_SESSION_CHANNEL];
}

//微信朋友圈分享
- (void)timeLineShare{
    self.newsModel.shareCompleteURL = [XLFeedModel completeShareURL:self.newsModel withRefrence:WX_MOMENT];
    
    @weakify(self);
    [[WechatShare sharedInstance] shareNewsDetail:self.newsModel to:WechatSceneTimeline sendReqCallback:^(int code) {
        @strongify(self);
        if (code == 0) {
            [StatServiceApi statEvent:IMAGE_FORWARDED model:self.newsModel otherString:WECHAT_MOMENTS_CHANNEL];
        }
    }];
    //分享朋友圈
    [StatServiceApi statEvent:IMAGE_FORWARD model:self.newsModel otherString:WECHAT_MOMENTS_CHANNEL];
    [StatServiceApi statEvent:IMAGE_FORWARD_TYPE model:self.newsModel otherString:WECHAT_MOMENTS_CHANNEL];
    [TalkingData trackEvent:WECHAT_MOMENTS_CHANNEL];
}

//保存图片
- (void)savePhoto{
    [StatServiceApi statEvent:IMAGE_SAVE model:self.newsModel];
    __block ImageModel *imageModel = self.groupItems[_page-1];
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:imageModel.originalImage] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if(!error){
            NSString *photoTypeString = [imageModel.originalImage substringFromIndex:imageModel.originalImage.length- 3];
            if ([photoTypeString isEqualToString:@"gif"]){
                [[PPSSavePhoto alloc] saveGIFImageWithFileURL:imageURL albumName:@"神段子动图"];
            }else{
                [[PPSSavePhoto alloc] saveImage:image albumName:@"神段子"];
            }
        }else{
            [MBProgressHUD showError:@"保存失败"];
        }
    }];
}

//双击放大
- (void)doubleTap:(UITapGestureRecognizer *)gesture {
    PPSPhotoGroupCell *cell = [self cellForPage:self.page];
    if (cell) {
        if (cell.zoomScale > 1) {
            [cell setZoomScale:1 animated:YES];
        } else {
            CGPoint touchPoint = [gesture locationInView:cell];
            CGFloat newZoomScale = cell.maximumZoomScale;
            CGFloat xsize = self.width / newZoomScale;
            CGFloat ysize = self.height / newZoomScale;
            [cell zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
        }
    }
}

-(void)gestureRecognizerStateCancelled:(BOOL)isOK{
    if(isOK){
        [self dismissAnimated:YES completion:nil];
    }else{
        _background.backgroundColor = [UIColor blackColor];
        _background.alpha = 1;
        self.pageLabel.hidden = NO;
        self.pageView.hidden = NO;
    }
}
-(void)gestureRecognizerStateChanged:(double)percent{
    self.background.backgroundColor = [UIColor colorWithWhite:0 alpha:percent];
    _background.alpha = percent;
    self.pageLabel.hidden = YES;
    self.pageView.hidden = YES;
}

- (void)gestureSpanRecognizerAction{
    _fromView.hidden = NO;
    _fromView = [_delegate dismissAction:_page];
    _fromView.hidden = YES;

}

- (UIImage *)scaleToSize:(UIImage *)img {
    CGFloat width = SCREEN_WIDTH;
    CGFloat height = img.size.height/img.size.width*width;
    CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

#pragma mark -
#pragma mark - lazy load 给默认值

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = UIScrollView.new;
        _scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH + kPadding , SCREEN_HEIGHT);
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.alwaysBounceHorizontal = self.groupItems.count > 1;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.maximumZoomScale = 3.0;
        _scrollView.minimumZoomScale = 0.2;
        _scrollView.alwaysBounceHorizontal = YES;
    }
    return _scrollView;
}

@end

