//
//  LoginViewModel.m
//  NationalRedPacket
//
//  Created by fensi on 2018/4/4.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "LoginViewModel.h"
#import "WechatLogin.h"
#import "WXApi.h"
#import "TencentQQApi.h"

@implementation LoginViewModel

- (LoginPlatformType)platformType {
    return [self isSupportWechat] ? LoginPlatformTypeWechat : LoginPlatformTypeQQ;
}

- (BOOL)isSupportWechat {
    return [WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi];
}

- (instancetype)initWithSourceType:(LoginSourceType)sourceType {
    self = [super init];
    if (self) {
        self.sourceType = sourceType;
    }
    return self;
}

- (void)thirdpartyLogin {

    [NSUserDefaults.standardUserDefaults setObject:self.platformType == LoginPlatformTypeWechat ? @"WECHAT" : @"QQ" forKey:XLUserDefaultsThirdpartyPlatformKey];
    [StatServiceApi statEvent:USER_CLICK_LOGIN model:nil otherString:[self thirdpartyTrackingDataChannel]];
    
    @weakify(self);
    
    //第三方登录完成回调处理
    void (^callback)(ThirdpartyLoginModel *model) = ^(ThirdpartyLoginModel *model) {
        
        if (model.code != 0) {
            if (self.delegate) {
                [self.delegate thirdpartyLoginDidFailure:model.code];
            }
            return;
        }
        
        [XLLoginManager.shared loginWithThirdpartyPlatform:model.platform openId:model.openId accessToken:model.accessToken success:^(id responseDict) {
            @strongify(self);
            
            // 登录打点
            [StatServiceApi statEvent:USER_LOGIN_SUCCESS model:nil otherString:[self thirdpartyTrackingDataChannel]];
            
            [XLNIMService.shared loginNIMAccount:responseDict[@"imAccid"] token:responseDict[@"imToken"] success:^{
                if (self.delegate) {
                    [self.delegate thirdpartyLoginDidSuccess];
                }
            } failure:^{
                if (self.delegate) {
                    [self.delegate thirdpartyLoginDidFailure:model.code];
                }
                [XLLoginManager.shared resetLoginStatus];
            }];
            
        } failure:^(NSInteger errorCode) {
            @strongify(self);
            
            if (self.delegate) {
                [self.delegate thirdpartyLoginDidFailure:model.code];
            }
            
        }];
    };
    
    
    if (self.platformType == LoginPlatformTypeWechat) {
        [WechatLogin.shared wechatLogin:^(ThirdpartyLoginModel *model) {
            callback(model);
        }];
    } else {
        [[TencentQQApi sharedInstance] loginCallback:^(ThirdpartyLoginModel *model) {
            callback(model);
        }];
    }
    
}

/**
 微信登录成功
 */
- (NSString *)thirdpartyTrackingDataChannel {
    NSString *channelStr = BUTTON_CLICK_CHANNEL;
    switch (self.sourceType) {
        case LoginSourceTypeVideoPraise:       channelStr = VIDEO_LIKE_CHANNEL;        break;
        case LoginSourceTypeVideoTread:        channelStr = VIDEO_TREAD_CHANNEL;       break;
        case LoginSourceTypeVideoComment:      channelStr = VIDEO_COMMENT_CHANNEL;     break;
        case LoginSourceTypeVideoCollection:   channelStr = VIDEO_COLLECTION_CHANNEL;  break;
        case LoginSourceTypeArticlePraise:     channelStr = ARTICLE_LIKE_CHANNEL;      break;
        case LoginSourceTypeArticleTread:      channelStr = ARTICLE_TREAD_CHANNEL;     break;
        case LoginSourceTypeArticleComment:    channelStr = ARTICLE_COMMENT_CHANNEL;   break;
        case LoginSourceTypeArticleCollection: channelStr = ARTICLE_COLLECTION_CHANNEL;break;
        case LoginSourceTypeImagePraise:       channelStr = IMAGE_LIKE_CHANNEL;        break;
        case LoginSourceTypeImageTread:        channelStr = IMAGE_TREAD_CHANNEL;       break;
        case LoginSourceTypeImageComment:      channelStr = IMAGE_COMMENT_CHANNEL;     break;
        case LoginSourceTypeImageCollection:   channelStr = IMAGE_COLLECTION_CHANNEL;  break;
        case LoginSourceTypeCommentPraise:     channelStr = COMMENT_LIKE_CHANNEL;      break;
        case LoginSourceTypeUserTabbarClick:   channelStr = BUTTON_CLICK_CHANNEL;      break;
        case LoginSourceTypeFollowAction:      channelStr = FOLLOW_ACTION_CHANNEL;     break;
        case LoginSourceTypeRedPacketClick:    channelStr = REDPACKET_CLICK_CHANNEL;   break;
        case LoginSourceTypePublishClick:      channelStr = PUBLISH_CLICK_CHANNEL;     break;
        case LoginSourceTypeNetworkError:      channelStr = @"";                       break;
        default: break;
    }
    return channelStr;
}

@end
