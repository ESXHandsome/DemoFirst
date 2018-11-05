//
//  ImageCell.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/2/22.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "ImageCell.h"
#import "UIImage+Tool.h"
#import "ContainerImageView.h"
#import "PublisherLatestFeedListViewController.h"
#import "GifPlayManager.h"

@interface ImageCell ()

@property (copy, nonatomic)   Completed   tempCompleted;

@property (strong, nonatomic) UIImage     *placeholderImage;

@property (assign, nonatomic) BOOL        isShowOriginalImage;

@property (strong, nonatomic) UIImageView *shadeImageView;
@property (strong, nonatomic) UIButton    *fullContentButton;
@property (assign, nonatomic) BOOL        isSignAndGif;
@property (assign, nonatomic) BOOL        isFeedDetail;

@end

@implementation ImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setupViews {
    
    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
    self.imageView = imageView;
    self.imageView.runLoopMode = NSRunLoopCommonModes;
    self.imageView.userInteractionEnabled = YES;
    self.imageView.animationRepeatCount = 1;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    imageView.backgroundColor = [UIColor colorWithString:COLOREDECED];
    [self addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"default_image_bg"];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self);
    }];
    
    self.labelImageView = [UIImageView new];
    self.labelImageView.hidden = YES;
    self.labelImageView.image = [UIImage imageNamed:@"piiic_label"];
    [imageView addSubview:self.labelImageView];
    
    [self.labelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.bottom.equalTo(imageView);
    }];
    
    [imageView addSubview:self.loadIndicator];
    [self.loadIndicator addTarget:self action:@selector(loadIndicatorDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.loadIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(imageView);
        make.width.height.mas_equalTo(adaptWidth750(100));
    }];
    
    self.shadeImageView = [UIImageView new];
    self.shadeImageView.image = [UIImage imageNamed:@"chat_activity_bg"];
    [imageView addSubview:self.shadeImageView];
    [self.shadeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(imageView);
    }];
    
    self.fullContentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.fullContentButton.backgroundColor = [UIColor clearColor];
    self.fullContentButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(32)];
    [self.fullContentButton setTitle:@"点击查看全图" forState:UIControlStateNormal];
    [self.fullContentButton setImage:[UIImage imageNamed:@"home_check_pic"] forState:UIControlStateNormal];
    self.fullContentButton.titleEdgeInsets = UIEdgeInsetsMake(0, adaptWidth750(18), 0, 0);
    self.fullContentButton.userInteractionEnabled = NO;
    [self.shadeImageView addSubview:self.fullContentButton];
    
    [self.fullContentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.shadeImageView);
        make.height.mas_equalTo(adaptHeight1334(80));
    }];
    
}

//赋值
- (void)configImageModel:(ImageModel *)model indexPath:(NSIndexPath *)indexPath isMultiImage:(BOOL)isMultiImage isDetail:(BOOL)isDetail
{
    self.imageModel = model;
    self.indexPlace = indexPath.row;
    self.isSignAndGif = !isMultiImage;
    self.isFeedDetail = isDetail;
    
    self.imageView.image = self.placeholderImage;
    self.labelImageView.image = [UIImage imageNamed:self.isGifImageView ? @"gif_label" : @"piiic_label"];
    self.labelImageView.hidden = !self.isGifImageView;
    self.fullContentButton.hidden = isDetail ?: isMultiImage ?: !model.isShowFullButton;
    self.shadeImageView.hidden = self.fullContentButton.hidden;
    if (self.isSignAndGif) {
        self.labelImageView.hidden = self.isSignAndGif;
    }
    self.loadIndicator.hidden = !(self.isGifImageView && self.isSignAndGif);
    
    self.isShowOriginalImage = (isMultiImage == NO && isDetail == YES && self.isGifImageView == NO);
    
    if (isDetail && [[SDImageCache sharedImageCache] imageFromCacheForKey:model.preview]) {
        self.placeholderImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:model.preview];
    }
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.isShowOriginalImage ? model.originalImage : model.preview] placeholderImage:self.placeholderImage options:SDWebImageAvoidAutoSetImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (self.isGifImageView) {
            self.imageView.image = image ? image : self.placeholderImage;
            self.labelImageView.hidden = !self.isGifImageView;
            self.loadIndicator.hidden = !self.isSignAndGif;
            self.isPlayingGif = NO;
            self.labelImageView.hidden = self.isSignAndGif;
        } else {
            if (isMultiImage) {
                self.imageView.image = [UIImage clipMultiImage:image ? image : self.placeholderImage toWidth:self.width toHeight:self.height];
            } else {
                self.imageView.image = [UIImage clipImage:image ? image : self.placeholderImage toWidth:self.width toHeight:self.height];
            }
            if (!isMultiImage) {
                self.labelImageView.hidden = YES;
            } else {
                self.labelImageView.hidden = ![UIImage isPiiicWithImage:image];
            }
        }
    }];
    
}

- (BOOL)isGifImageView
{
    if ([self.imageModel.originalImage hasSuffix:@".gif"]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)loadIndicatorDidClick {
    [self startGifImageViewCompleted:nil];
}

#pragma mark - 外部方法

//播放gif
- (void)startGifImageViewCompleted:(Completed)completed{
    
    if (!self.isGifImageView) {
        return;
    }
    self.isPausePlayGif = NO;
    self.tempCompleted = completed;
    
    if (self.isSignAndGif) {
        self.loadIndicator.hidden = NO;
    } else {
        if (![[SDImageCache sharedImageCache] diskImageDataExistsWithKey:self.imageModel.previewGif]) {
            self.loadIndicator.hidden = NO;
            [self.loadIndicator setTitle:@"" forState:UIControlStateNormal];
        } else {
            self.loadIndicator.hidden = YES;
        }
    }
    
    
    GifPlayManager.sharedManager.scrollTarget = self;
    GifPlayManager.sharedManager.scrollAction = @selector(currentTableViewDidScrolling);
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopGifAndCompletedBlock) object:nil];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageModel.previewGif] placeholderImage:self.imageView.image ? self.imageView.image : self.placeholderImage options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            float currentProgress = (float)receivedSize/(float)expectedSize;
            self.loadIndicator.progress = currentProgress;
            self.isPlayingGif = YES;
        });
        
    } completed:^(UIImage * _Nullable gifImage, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        self.loadIndicator.hidden = YES;
        [self.loadIndicator reset];
        
        self.isPlayingGif = YES;
        self.labelImageView.hidden = YES;
        
        if (gifImage.duration > 2) {
            [self performSelector:@selector(stopGifAndCompletedBlock) withObject:nil afterDelay:gifImage.duration];
        } else {  //避免服务端范围的.gif文件不是gif图，导致死递归
            [self performSelector:@selector(stopGifAndCompletedBlock) withObject:nil afterDelay:2];
        }
    }];
    
}

//停止播放gif
- (void)stopGifImageView
{
    self.isPlayingGif = NO;
    
    [self.imageView sd_cancelCurrentAnimationImagesLoad];
    if ([self isGifImageView]) {
        if (self.isSignAndGif) {
            [self.loadIndicator reset];
            self.loadIndicator.hidden = NO;
        } else {
            self.labelImageView.hidden = NO;
            self.loadIndicator.hidden = YES;
        }
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageModel.preview] placeholderImage:self.placeholderImage];  //注：这个方法耗时严重
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopGifAndCompletedBlock) object:nil];
    if (((ContainerImageView *)self.superview.superview).isOneGif) {
        if (![self isConfineToPlayArea]) {
            [[SDImageCache sharedImageCache] removeImageForKey:self.imageModel.previewGif fromDisk:NO withCompletion:nil];
            [[SDImageCache sharedImageCache] removeImageForKey:self.imageModel.originalImage fromDisk:NO withCompletion:nil];
        }
    } else {
        [[SDImageCache sharedImageCache] removeImageForKey:self.imageModel.previewGif fromDisk:NO withCompletion:nil];
        [[SDImageCache sharedImageCache] removeImageForKey:self.imageModel.originalImage fromDisk:NO withCompletion:nil];
    }
}

//是否在播放范围内
- (BOOL)isConfineToPlayArea
{
    //注：这个系统方法耗时严重
    CGRect rect = [self.superview convertRect:self.frame toView:[UIApplication sharedApplication].keyWindow]; //将当前cell由所在视图转换到window视图中
    CGFloat topHeight = 0.0;
    BaseFeedListViewController *newsVC = (BaseFeedListViewController *)[GifPlayManager sharedManager].currentTableView.viewController;
    if ([newsVC isKindOfClass:[PublisherLatestFeedListViewController class]]) {
        topHeight = adaptHeight1334(80);
    }
    if (rect.origin.y - NAVIGATION_BAR_HEIGHT - topHeight + self.height / 2.0 <= 0) {
        return NO;
    } else {
        CGFloat bottomHeight = 0.0;
        if ([[((UITabBarController *)UIApplication.sharedApplication.keyWindow.rootViewController) tabBar] isHidden]) {
            bottomHeight = 0;
        } else {
            bottomHeight = TAB_BAR_HEIGHT;
        }
        if (SCREEN_HEIGHT - bottomHeight - rect.origin.y < self.height / 2.0) {
            return NO;
        }
        return YES;
    }
}

//停止并播放下一个
- (void)stopGifAndCompletedBlock
{
    [self stopGifImageView];
    
    if (self.isPausePlayGif) {
        return;  //如果正在播放的cell被打断，不用播放下一个了
    }
    if (self.tempCompleted) {
        self.tempCompleted(NO);
    }
}

- (void)currentTableViewDidScrolling {
    if (![self isConfineToPlayArea]) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopGifAndCompletedBlock) object:nil];
        if (self.isPlayingGif) { //表示正在播放
            
            if (self.superview.height - self.y - self.height < 10.0 || self.y == 0) {
                if (((ContainerImageView *)self.superview.superview).isAllCellCanNotPlay) {
                    self.isPausePlayGif = YES;
                    [self stopGifImageView];
                    ((ContainerImageView *)self.superview.superview).isPlaying = NO;
                    return;
                }
            }
            [self stopGifImageView];
            if (self.tempCompleted) {
                self.tempCompleted(YES);
            }
        }
    }
}

- (XLLoadIndicator *)loadIndicator {
    if (!_loadIndicator) {
        self.loadIndicator = [[XLLoadIndicator alloc] initWithFrame:CGRectMake(0, 0, adaptWidth750(96), adaptWidth750(96))];
        self.loadIndicator.center = self.center;
        self.loadIndicator.borderWidth = 2;
        self.loadIndicator.lineWidth = adaptWidth750(96);
        self.loadIndicator.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        self.loadIndicator.fillColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        self.loadIndicator.strokeColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
        self.loadIndicator.hidden = YES;
    }
    return _loadIndicator;
}

- (UIImage *)placeholderImage
{
    if (!_placeholderImage) {
        self.placeholderImage = [UIImage imageNamed:@"default_image_bg"];
    }
    return _placeholderImage;
}

@end
