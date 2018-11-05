//
//  XLAppletsTableViewCell.h
//  NationalRedPacket
//
//  Created by Ying on 2018/6/21.
//  Copyright © 2018 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XLAppletsViewDelegate <NSObject>

/**
 点击顶部H5入口后的回调

 @param urlString 即将跳转的webView的URLString
 */ 
- (void)didSelectItemToPushWebView:(NSString *)urlString;

@end

@interface XLAppletsView : UIView

@property (weak, nonatomic) id<XLAppletsViewDelegate> delegate;

/**
 配置cell

 @param array 传入想要展示的数组数据
 */
- (void)congifCell:(NSArray *)array;

@end
