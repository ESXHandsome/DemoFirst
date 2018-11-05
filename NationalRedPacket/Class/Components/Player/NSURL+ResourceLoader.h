//
//  NSURL+ResourceLoader.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/4/12.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (ResourceLoader)

/**
 *  自定义scheme
 */
- (NSURL *)customSchemeURL;

/**
 *  还原scheme
 */
- (NSURL *)originalSchemeURL;

/**
 *  本地资源scheme
 */
- (NSURL *)localVideoSchemeURL;

@end
