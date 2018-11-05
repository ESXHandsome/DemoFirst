//
//  NewsButtonContentView.h
//  NationalRedPacket
//
//  Created by Ying on 2018/5/28.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ContentType) {
    ContentTypeFans = 0,
    ContentTypeLike = 1,
    ContentTypeCommnet = 2,
    ContentTypeVisitor = 3,
};

@protocol NewsButtonContentViewDelegate <NSObject>

/**
 按钮点击的回调

 @param tag 0-3按钮的tag值 方便判断
 */
- (void)newsButtonContentViewButtonClicked:(NSInteger)tag;
@end

@interface XLSessionButtonContentView : UIView
@property (weak, nonatomic) id<NewsButtonContentViewDelegate> delegate; ///实现按钮点击的回调

/**
 获取UIImageView

 @param type 0-3取到对应的button
 @return 你想拿到的button
 */
- (UIImageView *)getTabButton:(ContentType)type;

@end
