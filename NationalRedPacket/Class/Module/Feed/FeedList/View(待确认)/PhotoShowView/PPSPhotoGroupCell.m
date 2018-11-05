//
//  PPSPhotoGroupCell.m
//  NationalRedPacket
//
//  Created by Ying on 2018/2/24.
//  Copyright © 2018年 孙明悦. All rights reserved.
//


#import "PPSPhotoGroupCell.h"
#import "UIImageView+PlayGIF.h"


@interface PPSPhotoGroupCell()
@property (strong, nonatomic) UIImage *image;
@property (copy, nonatomic) NSString *url;
@property (assign, nonatomic) BOOL isGifLoaded;
@property (strong, nonatomic) UIImage *placeholderImage;
@end

@implementation PPSPhotoGroupCell
- (instancetype)init {
    self = [super init];
    self.delegate = self;
    self.bouncesZoom = YES;
    self.maximumZoomScale = 3;
    self.multipleTouchEnabled = YES;
    self.alwaysBounceVertical = NO;
    self.showsHorizontalScrollIndicator = self;
    self.frame =[UIScreen mainScreen].bounds;
    
    //图像容器
    _imageContainerView = [UIView new];
    _imageContainerView.clipsToBounds = YES;
    _imageContainerView.frame = self.frame;
    _imageContainerView.center = self.center;
    [self addSubview:_imageContainerView];
    
    //图像
    _imageView = [[UIImageView alloc] init];
    _imageView.frame = CGRectMake(0, 0, self.size.width,self.size.height);
    _imageView.center = self.center;
    _imageView.userInteractionEnabled = YES;
    _imageView.clipsToBounds = YES;
    _imageView.userInteractionEnabled = YES;
    [_imageContainerView addSubview:_imageView];
    
    return self;
}

-(void)initWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage {
    if (placeholderImage == nil) {
        UIImage *failedImage = [UIImage imageNamed:@"image_failure"];
        _imageView.image = failedImage;
        _imageView.size = failedImage.size;
        _imageView.center = self.center;
        _loadFailed = YES;
    } else {
        self.imageView.image = _placeholderImage;
        
    }
    
    [[SDWebImageManager sharedManager] diskImageExistsForURL:url completion:^(BOOL isInCache) {
        if(!isInCache) {
            //进度条
            self->_loadingView = [[XLCirclePieProgressView alloc] init];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self addSubview:self->_loadingView];
            });
        }
    }];
    
    //判断缩略图是否是长图  改变显示状态
    if((placeholderImage.size.width/ placeholderImage.size.height)<0.56){
        _isLongPhoto = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }else{
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    _url = url.absoluteString;
    _placeholderImage = placeholderImage;
    
    self.isLoading = YES;
    if([url.absoluteString containsString:@".gif"]){
        _gifImageUrlString = url.absoluteString;
        _isGif = YES;
        self.imageView.image = _placeholderImage;
        return;
    }
    
    [self loadImage];

}

- (void)loadImage{
    /*这里清理内存防止SDWebImage娶不到Data*/
    [[SDImageCache sharedImageCache] removeImageForKey:_url fromDisk:NO withCompletion:nil];
    __weak typeof (self) weakself = self;
    if(!self.loadFailed)
        self.imageView.image = self.placeholderImage;
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:self.url] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        float currentProgress = (float)receivedSize/(float)expectedSize;
        weakself.loadingView.progress = currentProgress;
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        //加载失败弹窗
        if (error){
            [MBProgressHUD showError:@"图片加载失败" time:1.5];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself.loadingView removeFromSuperview];
            });
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself.loadingView removeFromSuperview];
            });
            weakself.loadFailed = NO;
            weakself.imageView.contentMode = UIViewContentModeTop;
            if(weakself.isGif){
                weakself.imageView.gifData = data;
                [weakself.imageView startGIF];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakself.imageView.image = image;
                });
            }
            
            //根据图片的宽高比进行计算
            if((image.size.width/ image.size.height)<0.56){
                //显示长图
                weakself.imageView.contentMode = UIViewContentModeScaleAspectFill;
                weakself.imageView.clipsToBounds = YES;
                weakself.isLongPhoto = YES;
                CGFloat height = weakself.size.width/image.size.width*image.size.height;
                weakself.contentSize = CGSizeMake(weakself.size.width,height);
                if(!weakself.isShowView){
                    weakself.imageContainerView.size = CGSizeMake(weakself.size.width, height);
                }
                weakself.imageView.size = CGSizeMake(weakself.size.width, height);
                weakself.imageView.origin = CGPointMake(0, 0);
            }else{
                weakself.imageView.contentMode = UIViewContentModeScaleAspectFill;
                weakself.imageView.size = CGSizeMake(weakself.size.width, weakself.size.width/image.size.width*image.size.height);
                weakself.imageView.center = weakself.center;
                weakself.pan=[[UIPanGestureRecognizer alloc]initWithTarget:weakself action:@selector(panAction:)];
                weakself.pan.delegate = weakself;
                [weakself addGestureRecognizer:weakself.pan];
            }
        }
        weakself.isLoading = NO;
        [[SDImageCache sharedImageCache] removeImageForKey:weakself.url fromDisk:NO withCompletion:nil];
    }];
    
}

//双指缩放
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageContainerView;
}

//缩放时再中心
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIView *subView = self.imageContainerView;
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}
- (void)panAction:(UIPanGestureRecognizer *)pan{
    if(self.imageView.size.height>SCREEN_HEIGHT) return;
    CGPoint point = [pan translationInView:self];
    CGPoint velocity = [pan velocityInView:self];
    UIImageView *photoView = self.imageView;
    switch (pan.state) {
            break;
        case UIGestureRecognizerStateChanged: {
            [self.cellDelegate gestureSpanRecognizerAction];
            double percent = 1 - fabs(point.y) / self.frame.size.height;
            percent = MAX(percent, 0);
            double s = MAX(percent, 0.5);
            CGAffineTransform translation = CGAffineTransformMakeTranslation(point.x/s, point.y/s);
            CGAffineTransform scale = CGAffineTransformMakeScale(s, s);
            photoView.transform = CGAffineTransformConcat(translation, scale);
            double alphaPercent = 1 - fabs(point.y) / adaptHeight1334(100);
            [self.cellDelegate gestureRecognizerStateChanged:alphaPercent];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            if (fabs(point.y) > 100 || fabs(velocity.y) > 500) {
                [self.cellDelegate gestureRecognizerStateCancelled:YES];
            } else {
                [UIView animateWithDuration:0.1 animations:^{
                    photoView.transform = CGAffineTransformIdentity;
                    [self.cellDelegate gestureRecognizerStateCancelled:NO];
                }];
            }
        }
            break;
        default:
            break;
    }
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer == self.pan) {
        if(_imageView.size.height>SCREEN_HEIGHT) return NO;
        CGPoint translation = [self.pan translationInView:self];
        CGFloat absX = fabs(translation.x);
        CGFloat absY = fabs(translation.y);
        if (absY > absX && self.zoomScale == 1.000000) {
            if (translation.y<0) {
                return YES;
                //向上滑动
            }else
                return YES;
                //向下滑动
        }else
            return NO;
    }else
        return YES;
}
-(void)restartGif{
    [self.imageView stopAnimating];
    if(self.isGif){
        if(!self.isLoading){
            [self.imageView startGIF];
        }else [self loadImage];
    }
}

-(void)setPlaceholdImage{
    self.imageView.image = _placeholderImage;
}

-(void)removeCache{
     [[SDImageCache sharedImageCache] removeImageForKey:self.url fromDisk:NO withCompletion:nil];
}

-(void)stopGif{
    [self.imageView stopGIF];
}

- (UIImage *)scaleToSize:(UIImage *)img {
    CGFloat width = SCREEN_WIDTH;
    CGFloat height = img.size.height/img.size.width*width;
    CGSize size = CGSizeMake(width, height);
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}
@end

