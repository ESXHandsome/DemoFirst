//
//  Font+AdaptScreen.h
//  NationalRedPacket
//
//  Created by Ying on 2018/4/4.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kAdaptScreenRatio   UIScreen.mainScreen.bounds.size.width / 375.0f
#define kFontSize(value)    value * kAdaptScreenRatio
#define kFont(value)        [UIFont systemFontOfSize:value * kAdaptScreenRatio]

#define kAdaptScreenRatio   UIScreen.mainScreen.bounds.size.width / 375.0f
#define kFontSize(value)    value * kAdaptScreenRatio
#define kFont(value)        [UIFont systemFontOfSize:value * kAdaptScreenRatio]

/**
 *  Button
 */
@interface UIButton (MyFont)
@end

/**
 *  Label
 */
@interface UILabel (MyFont)
@end

/**
 *  TextField
 */
@interface UITextField (MyFont)
@end

/**
 *  TextView
 */
@interface UITextView (MyFont)
@end
