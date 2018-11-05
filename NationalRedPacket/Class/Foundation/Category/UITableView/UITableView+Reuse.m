//
//  UITableView+Reuse.m
//  NationalRedPacket
//
//  Created by fensi on 2018/4/23.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "UITableView+Reuse.h"

@implementation UITableView (Reuse)

- (void)xl_registerClass:(Class)cls {
    [self registerClass:cls forCellReuseIdentifier:NSStringFromClass(cls)];
}

- (__kindof UITableViewCell *)xl_dequeueReusableCellWithClass:(Class)cls forIndexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableCellWithIdentifier:NSStringFromClass(cls) forIndexPath:indexPath];
}

@end
