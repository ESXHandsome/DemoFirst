//
//  XLAppletsCollectionViewCell.h
//  NationalRedPacket
//
//  Created by Ying on 2018/6/21.
//  Copyright © 2018 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLAppletsCollectionViewCell : UICollectionViewCell

/**
 配置view需要展示的数据
 
 @param bgImageString 背景图片地址字符串
 @param labelTitle 标题文字
 @param floatTitle 悬浮文字
 @param mask    是否需要遮罩
 */
- (void)congifAppletsView:(NSString *)bgImageString titleLabel:(NSString *)labelTitle floatLabel:(NSString *)floatTitle useMask:(BOOL)mask;
@end
