//
//  Header.h
//  NationalRedPacket
//
//  Created by Ying on 2018/6/14.
//  Copyright © 2018年 XLook. All rights reserved.
//

#ifndef XLTools_h
#define XLTools_h

/**
 通过string获取图片

 @param imageName 图片名称
 @return 图片
 */

#define GetColor(colorName) [UIColor colorWithString:[NSString stringWithFormat:@"%@",colorName]]
#define GetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]
#define KeyWindow [UIApplication sharedApplication].keyWindow

#endif /* Header_h */
