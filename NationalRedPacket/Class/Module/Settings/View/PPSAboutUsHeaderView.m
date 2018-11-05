//
//  PPSAboutUsHeaderView.m
//  NationalRedPacket
//
//  Created by Ying on 2018/3/23.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "PPSAboutUsHeaderView.h"

@implementation PPSAboutUsHeaderView

- (instancetype)init{
    self = [super init];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, adaptHeight1334(163*2));
    self.backgroundColor = [UIColor colorWithString:COLORF7F7F7];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"login_icon_logo"];
    imageView.size = imageView.image.size;
    imageView.centerX = self.centerX;
    imageView.y = adaptHeight1334(21*2);
    
    UILabel* bundlelabel = [UILabel labWithText:[NSString stringWithFormat:@"版本号%@",NSBundle.appVersion] fontSize:adaptFontSize(28) textColorString:COLORBDBDBD];
    bundlelabel.size = [bundlelabel.text sizeWithAttributes:@{NSFontAttributeName:bundlelabel
                                                              .font}];
    bundlelabel.y = adaptHeight1334(126*2);
    bundlelabel.centerX = self.centerX;
    [self addSubview:imageView];
    [self addSubview:bundlelabel];
    return self;
}
@end
