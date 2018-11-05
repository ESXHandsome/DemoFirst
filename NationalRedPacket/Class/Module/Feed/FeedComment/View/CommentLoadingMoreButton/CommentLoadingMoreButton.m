//
//  CommentLoadingMoreButton.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/4/26.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "CommentLoadingMoreButton.h"
#import "UIButton+XLEdgeInsetsButton.h"

@interface CommentLoadingMoreButton ()

@property (strong, nonatomic) CABasicAnimation *videoLoadingAnimation;

@end

@implementation CommentLoadingMoreButton

#pragma mark - Public

- (void)startLoading {
    [self setImage:[UIImage imageNamed:@"secondary_coment_loading"] forState:UIControlStateNormal];
    [self layoutButtonWithEdgeInsetsStyle:XLButtonEdgeInsetsStyleLeft imageTitleSpace:6];
    self.userInteractionEnabled = NO;
    [self setTitle:@"评论加载中..." forState:UIControlStateNormal];
    [self.imageView.layer addAnimation:self.videoLoadingAnimation forKey:@"ransform.rotation"];
}

- (void)stopLoading {
    [self setImage:nil forState:UIControlStateNormal];
    self.userInteractionEnabled = YES;
}

#pragma mark - Custom

- (CABasicAnimation *)videoLoadingAnimation {
    if (!_videoLoadingAnimation) {
        _videoLoadingAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        _videoLoadingAnimation.toValue = [NSNumber numberWithFloat:M_PI*4];
        _videoLoadingAnimation.duration = 2.0f;
        _videoLoadingAnimation.repeatCount = HUGE_VALF;
    }
    return _videoLoadingAnimation;
}

@end
