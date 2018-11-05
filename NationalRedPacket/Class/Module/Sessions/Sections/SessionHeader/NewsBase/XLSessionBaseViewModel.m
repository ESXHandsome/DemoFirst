//
//  XLSessionBaseViewModel.m
//  NationalRedPacket
//
//  Created by Ying on 2018/5/28.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLSessionBaseViewModel.h"

@implementation XLSessionBaseViewModel

- (void)loadMore {
    
}

- (void)refresh {
    [self.baseDelegate refreshFinish];  
}

@end
