//
//  XLNIMConst.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/5/25.
//  Copyright © 2018年 XLook. All rights reserved.
//

#ifdef DEBUG

//云信Demo的AppKey
//static NSString * const XLNIMAppKey = @"45c6af3c98409b18a84451215d0bdd6e";
//自己服务端的AppKey
static NSString * const XLNIMAppKey = @"00c4ad60f8ee1218fbd0876466dbe5db";
static NSString * const XLNIMAPNSCertificateName = @"XLAPNsDevelop";

#else

static NSString * const XLNIMAppKey = @"00c4ad60f8ee1218fbd0876466dbe5db";
static NSString * const XLNIMAPNSCertificateName = @"XLAPNsProduction";

#endif
