//
//  LikeParticleEmissionButton.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/2/28.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LikeParticleEmissionButtonDelegate <NSObject>

- (void)didClickLikeButtonEvent:(UIButton *)sender;

@end

@interface LikeParticleEmissionButton : UIButton

@property (weak, nonatomic) id<LikeParticleEmissionButtonDelegate> likeButtonDelegate;

@end
