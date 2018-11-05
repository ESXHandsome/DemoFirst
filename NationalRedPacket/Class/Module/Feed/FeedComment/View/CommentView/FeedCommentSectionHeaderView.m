//
//  ArticleSectionHeaderView.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/1/10.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "FeedCommentSectionHeaderView.h"

@interface FeedCommentSectionHeaderView ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIView  *lineView;

@end

@implementation FeedCommentSectionHeaderView

- (void)setupViews
{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, kSectionHeight);
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *specView = [UIView new];
    specView.backgroundColor = [UIColor colorWithString:COLORF7F7F7];
    [self addSubview:specView];
    
    UILabel *titleLabel = [UILabel labWithText:@"" fontSize:adaptFontSize(28) textColorString:COLOR999999];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    [specView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(adaptHeight1334(12));
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(adaptWidth750(32));
        make.top.equalTo(specView.mas_bottom);
        make.bottom.equalTo(self);
    }];
    
}

- (void)setSectionTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
