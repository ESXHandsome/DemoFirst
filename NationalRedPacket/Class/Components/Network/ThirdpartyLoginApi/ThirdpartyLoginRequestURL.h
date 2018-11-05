//
//  WechatRequestURL.h
//  NationalRedPacket
//
//  Created by sunmingyue on 17/7/27.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#ifndef WechatRequestURL_h
#define WechatRequestURL_h

// 微信登录验证
#define URL_THIRDPARTY_LOGIN        URL_BASE@"/User/weixinLogin"

// 微信请求ACCESS TOKEN
#define URL_WEIXINCODE              @"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code"

#endif /* WechatRequestURL_h */
