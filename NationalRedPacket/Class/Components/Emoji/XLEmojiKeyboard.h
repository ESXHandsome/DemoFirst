//
//  XLEmojiKeyboard.h
//  NationalRedPacket
//
//  Created by Ying on 2018/4/23.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XLEmojiKeyboard;
@protocol XLEmojiKeyBoardDelegate <NSObject>


/*
 调用方法
 XLEmojiKeyboard *borad = [[XLEmojiKeyboard alloc] init];
 borad.backgroundColor = [UIColor whiteColor];
 [self.view addSubview:borad];
 [borad mas_makeConstraints:^(MASConstraintMaker *make) {
 make.left.equalTo(self.view.mas_left);
 make.right.equalTo(self.view.mas_right);
 make.height.mas_equalTo(adaptHeight1334(258*2));
 make.bottom.equalTo(self.view.mas_bottom);
 }];
 */


/**
就是，那啥，键盘上的表情被点击了的回调

 @param emojiString 你要拿去显示的字符串
 */
- (void)emojiKeyboard:(XLEmojiKeyboard *)emojiKeyboard didClickedEmoji:(NSString *)emojiString;

/**
 键盘上的回退按钮被点击了
 */
- (void)emojiKeyboardDidClickedBackspace;
@end

@interface XLEmojiKeyboard : UIView

///这个没啥用 就是方便调用
+ (instancetype)keyboard;

///需要设置代理
@property (weak ,nonatomic) id<XLEmojiKeyBoardDelegate> delegate;

@end
