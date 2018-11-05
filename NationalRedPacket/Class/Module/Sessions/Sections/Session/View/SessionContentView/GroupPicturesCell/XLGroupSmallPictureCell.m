//
//  XLGroupSmallPictureCell.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/6/21.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLGroupSmallPictureCell.h"
#import "XLActivityLinkModel.h"

@interface XLGroupSmallPictureCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIView *specLine;

@end

@implementation XLGroupSmallPictureCell

- (void)configModelData:(XLActivityLinkModel *)model indexPath:(NSIndexPath *)indexPath {
    
    self.titleLabel.text = model.title;
    self.titleLabel.numberOfLines = 2;
    [self.titleLabel setLineSpacing:adaptHeight1334(6)];
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    
}

@end
