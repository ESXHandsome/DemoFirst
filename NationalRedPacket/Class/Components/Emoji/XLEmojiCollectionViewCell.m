//
//  XLEmojiCollectionViewCell.m
//  NationalRedPacket
//
//  Created by Ying on 2018/4/23.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLEmojiCollectionViewCell.h"

@implementation XLEmojiCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIFont* emojiFont = [UIFont fontWithName:@"AppleColorEmoji" size:35.0];
    _label.font = emojiFont;
}

@end
