//
//  XLNetworkMacro.h
//  NationalRedPacket
//
//  Created by sunmingyue on 17/7/14.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#ifndef XLNetworkMacro_h
#define XLNetworkMacro_h

#define KEY_CLIENT @"enutpennaidijmoc"

#ifdef DEBUG

// 测试环境
//#define URL_BASE @"http://139.129.162.59:8088/V2"

#define URL_BASE @"http://139.129.162.59:9537/V2"

// 正式环境
//#define URL_BASE @"http://paopaojie.jipi-nobug.cn/V2"

#else

//正式环境
#define URL_BASE @"http://paopaojie.jipi-nobug.cn/V2"

#endif

#endif /* XLNetworkMacro_h */ 
