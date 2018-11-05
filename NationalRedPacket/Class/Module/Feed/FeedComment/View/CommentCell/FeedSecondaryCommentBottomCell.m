//
//  FeedSecondaryCommentBottomCell.m
//  NationalRedPacket
//
//  Created by fensi on 2018/4/24.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "FeedSecondaryCommentBottomCell.h"

@interface FeedSecondaryCommentBottomCell ()

@property (strong, nonatomic) UIImageView *bottomCommentRoundedBackground;

@end

@implementation FeedSecondaryCommentBottomCell

- (void)setupViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.bottomCommentRoundedBackground = [UIImageView new];
    self.bottomCommentRoundedBackground.frame = CGRectMake(adaptWidth750(128), 0, SCREEN_WIDTH - adaptWidth750(64*2) - adaptWidth750(20*2), 8);
    self.bottomCommentRoundedBackground.backgroundColor = [UIColor colorWithString:COLORF7F7F7];
    [self.contentView addSubview:self.bottomCommentRoundedBackground];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bottomCommentRoundedBackground.bounds
                                                   byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                         cornerRadii:CGSizeMake(adaptHeight1334(10), adaptHeight1334(10))];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bottomCommentRoundedBackground.bounds;
    maskLayer.path = maskPath.CGPath;
    self.bottomCommentRoundedBackground.clipsToBounds = YES;
    self.bottomCommentRoundedBackground.layer.mask = maskLayer;
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
