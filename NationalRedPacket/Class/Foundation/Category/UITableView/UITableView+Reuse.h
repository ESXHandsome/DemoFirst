//
//  UITableView+Reuse.h
//  NationalRedPacket
//
//  Created by fensi on 2018/4/23.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Reuse)

- (void)xl_registerClass:(Class)cls;

- (__kindof UITableViewCell *)xl_dequeueReusableCellWithClass:(Class)cls forIndexPath:(NSIndexPath *)indexPath;

@end
