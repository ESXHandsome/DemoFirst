//
//  XLGroupBigPictureCell.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/6/21.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLGroupBigPictureCell.h"
#import "XLActivityLinkModel.h"

@interface XLGroupBigPictureCell ()

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation XLGroupBigPictureCell

- (void)configModelData:(XLActivityLinkModel *)model indexPath:(NSIndexPath *)indexPath {
    
    self.titleLabel.text = model.title;
    self.titleLabel.numberOfLines = 2;
    [self.titleLabel setLineSpacing:adaptHeight1334(4)];
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    
}

@end
