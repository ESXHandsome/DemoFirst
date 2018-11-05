//
//  PPSPhotoGroupCell.h
//  NationalRedPacket
//
//  Created by Ying on 2018/2/24.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLCirclePieProgressView.h"
#import <FLAnimatedImage/FLAnimatedImage.h>



@protocol XLPhotoShowViewDelegate <NSObject>
- (void)gestureRecognizerStateChanged:(double)percent;
- (void)gestureRecognizerStateCancelled:(BOOL)isOK;
- (void)gestureSpanRecognizerAction;
@end


@interface PPSPhotoGroupCell : UIScrollView <UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (strong, nonatomic) UIView *imageContainerView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) XLCirclePieProgressView *loadingView;
@property (assign, nonatomic) BOOL loadFailed;
@property (strong, nonatomic) UIPanGestureRecognizer *pan;
@property (weak, nonatomic)   id<XLPhotoShowViewDelegate> cellDelegate;
@property (copy, nonatomic)   NSString *gifImageUrlString;
@property (assign, nonatomic) BOOL isGif;
@property (assign, nonatomic) BOOL isLongPhoto;
@property (assign, nonatomic) BOOL isLoading;
@property (assign, nonatomic) BOOL isShowView;

-(void)initWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage;
-(void)restartGif;
-(void)stopGif;
-(void)setPlaceholdImage;
-(void)removeCache;
@end
