//
//  NewsButtonContentView.h
//  NationalRedPacket
//
//  Created by Ying on 2018/5/28.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewsButtonContentViewDelegate <NSObject>

/**
 按钮点击的回调

 @param tag 0-4按钮的tag值 方便判断
 */
- (void)newsButtonContentViewButtonClicked:(NSInteger)tag;
@end

@interface XLSessionButtonContentView : UIView
@property (weak, nonatomic) id<NewsButtonContentViewDelegate> delegate; ///实现按钮点击的回调
@end
