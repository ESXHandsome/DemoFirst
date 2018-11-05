//
//  FeedSecondaryCommentTopCell.m
//  NationalRedPacket
//
//  Created by fensi on 2018/4/24.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "FeedSecondaryCommentTopCell.h"

@interface FeedSecondaryCommentTopCell ()

@property (strong, nonatomic) UIImageView *topCommentRoundedBackground;

@end

@implementation FeedSecondaryCommentTopCell

- (void)setupViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.topCommentRoundedBackground = [UIImageView new];
    self.topCommentRoundedBackground.backgroundColor = [UIColor colorWithString:COLORF7F7F7];
    self.topCommentRoundedBackground.frame = CGRectMake(adaptWidth750(128), 0, SCREEN_WIDTH - adaptWidth750(64*2) - adaptWidth750(20*2), 8);

    [self.contentView addSubview:self.topCommentRoundedBackground];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.topCommentRoundedBackground.bounds
                                                   byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                         cornerRadii:CGSizeMake(adaptHeight1334(10), adaptHeight1334(10))];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.topCommentRoundedBackground.bounds;
    maskLayer.path = maskPath.CGPath;
    self.topCommentRoundedBackground.clipsToBounds = YES;
    self.topCommentRoundedBackground.layer.mask = maskLayer;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
