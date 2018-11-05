//
//  LikeParticleEmissionButton.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/2/28.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "LikeParticleEmissionButton.h"
#import "BaseNavigationController.h"

@interface LikeParticleEmissionButton ()


/**
 图片数组
 */
@property (strong, nonatomic) NSMutableArray *emojiImagesArray;

/**
 cell的数组
 */
@property (strong, nonatomic) NSMutableArray *emitterCellArray;

/**
 展示多少个赞的label
 */
@property (strong, nonatomic) UILabel *likeCountLabel;

/**
 长按点赞，每1秒为一个赞
 */
@property (strong, nonatomic) NSTimer *timer;

/**
 赞的个数
 */
@property (assign, nonatomic) NSInteger countNum;

/**
 展示的layer
 */
@property (strong, nonatomic) CAEmitterLayer *emitterLayer;

@end

@implementation LikeParticleEmissionButton

#pragma mark -
#pragma mark - Initialize

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupViews];
    }
    return self;
}

/**
 配置WclEmitterButton
 */
- (void)setupViews {
    // 初始化赞的个数
    self.countNum = 1;
    
    // 点一下手势
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                       action:@selector(pressOnce:)]];
    // 长按手势
    [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(pressLong:)]];
    
    [self setImage:[UIImage imageNamed:@"detail_comment_like"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"detail_comment_like_red"] forState:UIControlStateSelected];
    
    
}

#pragma mark -
#pragma mark Touch Event Response

/**
 点了一下
 
 @param gesture 手势
 */
- (void)pressOnce:(UIGestureRecognizer *)gesture {

    if (!XLLoginManager.shared.isAccountLogined) {
        [LoginViewController showLoginVCFromSource:LoginSourceTypeCommentPraise];
        return;
    }
    [[UIViewController currentViewController].view.layer addSublayer:self.emitterLayer];
    UIButton *sender = (UIButton *)gesture.view;
    sender.selected = !sender.selected;
  
    CGRect rect = [self.superview convertRect:self.frame toView:[UIApplication sharedApplication].keyWindow];
    self.emitterLayer.emitterPosition = CGPointMake(rect.origin.x, rect.origin.y);
    
    if (self.likeButtonDelegate && [self.likeButtonDelegate respondsToSelector:@selector(didClickLikeButtonEvent:)]) {
        [self.likeButtonDelegate didClickLikeButtonEvent:self];
    }
    [self startAnimationWithShouldShowText:NO];

    if (sender.selected == NO) {
        //重置label文字
        self.countNum = 0;
    }
}

/**
 长按
 
 @param gesture 手势
 */
- (void)pressLong:(UIGestureRecognizer *)gesture {
    
    if (!XLLoginManager.shared.isAccountLogined) {
        if (gesture.state == UIGestureRecognizerStateBegan) {
            [LoginViewController showLoginVCFromSource:LoginSourceTypeCommentPraise];
        }
        return;
    }
    [[UIViewController currentViewController].view.layer addSublayer:self.emitterLayer];

    UIButton * sender = (UIButton *)gesture.view;
    CGRect rect = [self.superview convertRect:self.frame toView:[UIApplication sharedApplication].keyWindow];
    self.emitterLayer.emitterPosition = CGPointMake(rect.origin.x, rect.origin.y);

    if (!sender.selected) {
        sender.selected = YES;
        if (self.likeButtonDelegate && [self.likeButtonDelegate respondsToSelector:@selector(didClickLikeButtonEvent:)]) {
            [self.likeButtonDelegate didClickLikeButtonEvent:self];
        }
    }
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self startAnimationWithShouldShowText:YES];
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        [self stopAnimation];
    }
}

#pragma mark -
#pragma mark Animation

/**
 开始动画
 */
- (void)startAnimationWithShouldShowText:(BOOL)shouldShowText {

    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    if (self.selected) {
        animation.values = @[@1.5 ,@0.8, @1.0,@1.2,@1.0];
        animation.duration = 0.3;
        [self startEmissionWithShouldShowText:shouldShowText];

        if (!shouldShowText) {
            [self performSelector:@selector(stopAnimation) withObject:nil afterDelay:0.3];
        }
    } else {
        animation.values = @[@0.8, @1.0];
        animation.duration = 0.4;
    }
    animation.calculationMode = kCAAnimationCubic;
    [self.layer addAnimation:animation forKey:@"transform.scale"];
}

/**
 开始喷射
 */
- (void)startEmissionWithShouldShowText:(BOOL)shouldShowText {
    
    for (int i = 1; i < 10; i++) {
        //78张图片 随机选9张
        int x = arc4random() % 77 + 1;
        NSString * imageStr = [NSString stringWithFormat:@"emoji_%d",x];
        [self.emojiImagesArray addObject:imageStr];
    }
    
    // 设置展示的cell
    for (NSString *imageStr in self.emojiImagesArray) {
        CAEmitterCell * cell = [self emitterCell:[UIImage imageNamed:imageStr] name:imageStr];
        [self.emitterCellArray addObject:cell];
    }
    self.emitterLayer.emitterCells  = self.emitterCellArray;
    
    // 开启计时器 设置点赞次数的label
    if (shouldShowText) {
        if (!self.likeCountLabel) {
            self.likeCountLabel = [[UILabel alloc] init];
            [[UIViewController currentViewController].view addSubview:self.likeCountLabel];
            [self.likeCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.mas_centerY).mas_offset(-adaptHeight1334(120));
                make.right.equalTo(self.mas_centerX);
            }];
            
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@0.5 ,@1];
            animation.duration = 0.3;
            animation.calculationMode = kCAAnimationCubic;
            [self.likeCountLabel.layer addAnimation:animation forKey:@"transform.scale"];
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.15 target:self
                                                    selector:@selector(changeText)
                                                    userInfo:nil repeats:YES];
    }

    // _emitterLayer开始时间
    self.emitterLayer.beginTime = CACurrentMediaTime();
    for (NSString * imgStr in self.emojiImagesArray) {
        NSString * keyPathStr = [NSString stringWithFormat:@"emitterCells.%@.birthRate",imgStr];
        [self.emitterLayer setValue:@4 forKeyPath:keyPathStr];
    }
}

/**
 创建发射的表情cell
 
 @param image 传入随机的图片
 @param name 图片的名字
 @return cell
 */
- (CAEmitterCell *)emitterCell:(UIImage *)image name:(NSString *)name {
    CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
    emitterCell.birthRate = 0;//每秒出现多少个粒子
    emitterCell.lifetime = 1;// 粒子的存活时间
    emitterCell.scale = 0.45;
    
    emitterCell.alphaSpeed = -0.3;//消失范围
    emitterCell.yAcceleration = 550;//可以有下落的效果
    
    CGImageRef image2 = image.CGImage;
    emitterCell.contents= (__bridge id _Nullable)(image2);
    emitterCell.name = name; //设置这个 用来展示喷射动画 和隐藏
    
    emitterCell.velocity = 700;//速度
    emitterCell.velocityRange = 305;// 平均速度
    emitterCell.emissionLongitude = M_PI * 7/6;
    emitterCell.emissionRange = M_PI_2;//粒子的发散范围
    return emitterCell;
}

/**
 停止喷射
 */
- (void)stopAnimation {
    // 让chareLayer每秒喷射的个数为0个
    for (NSString * imgStr in self.emojiImagesArray) {
        NSString * keyPathStr = [NSString stringWithFormat:@"emitterCells.%@.birthRate",imgStr];
        [self.emitterLayer setValue:@0 forKeyPath:keyPathStr];
    }
    if (self.likeCountLabel) {
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                self.likeCountLabel.alpha = 0;
            } completion: ^(BOOL finished) {
                [self.likeCountLabel removeFromSuperview];
                self.likeCountLabel = nil;
            }];
        });
    }
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [self.emitterLayer  removeAllAnimations];
    [self.emojiImagesArray removeAllObjects];
    [self.emitterCellArray removeAllObjects];
}

/**
 富文本设置label的图片内容
 
 @param num 当前赞的个数
 @return 要显示的富文本
 */
- (NSMutableAttributedString *)getAttributedString:(NSInteger)num {
    //先把num 拆成个十百
    NSInteger ge = num % 10;
    NSInteger shi = num % 100 / 10;
    NSInteger bai = num % 1000 / 100;
    
    //大于1000则隐藏
    if (num >= 1000) {
        return nil;
    }
    
    NSMutableAttributedString * mutStr = [[NSMutableAttributedString alloc]init];
    
    //创建百位显示的图片
    if (bai != 0) {
        NSTextAttachment *b_attch = [[NSTextAttachment alloc] init];
        b_attch.image = [UIImage imageNamed:[NSString stringWithFormat:@"multi_digg_num_%ld",bai]];
        b_attch.bounds = CGRectMake(0, 0, b_attch.image.size.width, b_attch.image.size.height);
        NSAttributedString *b_string = [NSAttributedString attributedStringWithAttachment:b_attch];
        [mutStr appendAttributedString:b_string];
    }
    
    //创建十位显示的图片
    if (!(shi == 0 && bai == 0)) {
        NSTextAttachment *s_attch = [[NSTextAttachment alloc] init];
        s_attch.image = [UIImage imageNamed:[NSString stringWithFormat:@"multi_digg_num_%ld",shi ]];
        s_attch.bounds = CGRectMake(0, 0, s_attch.image.size.width, s_attch.image.size.height);
        NSAttributedString *s_string = [NSAttributedString attributedStringWithAttachment:s_attch];
        [mutStr appendAttributedString:s_string];
    }
    
    //创建个位显示的图片
    if (ge >= 0) {
        NSTextAttachment *g_attch = [[NSTextAttachment alloc] init];
        g_attch.image = [UIImage imageNamed:[NSString stringWithFormat:@"multi_digg_num_%ld",ge]];
        g_attch.bounds = CGRectMake(0, 0, g_attch.image.size.width, g_attch.image.size.height);
        NSAttributedString *g_string = [NSAttributedString attributedStringWithAttachment:g_attch];
        [mutStr appendAttributedString:g_string];
    }
    
    if (num <= 3) {
        //鼓励
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        attch.image = [UIImage imageNamed:@"multi_digg_word_level_1"];
        attch.bounds = CGRectMake(0, 0, attch.image.size.width, attch.image.size.height);
        NSAttributedString *z_string = [NSAttributedString attributedStringWithAttachment:attch];
        [mutStr appendAttributedString:z_string];
    } else if (num <= 6) {
        //加油
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        attch.image = [UIImage imageNamed:@"multi_digg_word_level_2"];
        attch.bounds = CGRectMake(0, 0, attch.image.size.width, attch.image.size.height);
        NSAttributedString *z_string = [NSAttributedString attributedStringWithAttachment:attch];
        [mutStr appendAttributedString:z_string];
    } else {
        //太棒了
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        attch.image = [UIImage imageNamed:@"multi_digg_word_level_3"];
        attch.bounds = CGRectMake(0, 0, attch.image.size.width, attch.image.size.height);
        NSAttributedString *z_string = [NSAttributedString attributedStringWithAttachment:attch];
        [mutStr appendAttributedString:z_string];
    }
    return mutStr;
}

/**
 更改点赞个数label的文字
 */
- (void)changeText {
    self.countNum ++;
    [self touchFeedback];
    self.likeCountLabel.attributedText = [self getAttributedString:self.countNum];
    self.likeCountLabel.textAlignment = NSTextAlignmentCenter;
}

/**
 点赞触感反馈
 */
- (void)touchFeedback {
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *impactFeedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        [impactFeedback impactOccurred];
    }
}

#pragma mark -
#pragma mark Setters and Getters

- (NSMutableArray *)emojiImagesArray {
    if (_emojiImagesArray == nil) {
        _emojiImagesArray = [NSMutableArray array];
    }
    return _emojiImagesArray;
}

- (NSMutableArray *)emitterCellArray {
    if (_emitterCellArray == nil) {
        _emitterCellArray = [NSMutableArray array];
    }
    return _emitterCellArray;
}

- (CAEmitterLayer *)emitterLayer
{
    if (!_emitterLayer) {
        _emitterLayer               = [CAEmitterLayer layer];
        _emitterLayer.emitterSize   = CGSizeMake(30, 30);
        _emitterLayer.emitterShape = kCAEmitterLayerCircle;  // 发射源的形状 是枚举类型
        _emitterLayer.emitterMode = kCAEmitterLayerPoints; // 发射模式 枚举类型
    }
    return _emitterLayer;
}

@end
