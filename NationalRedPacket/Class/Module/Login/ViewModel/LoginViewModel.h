//
//  LoginViewModel.h
//  NationalRedPacket
//
//  Created by fensi on 2018/4/4.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LoginSourceType) {
    LoginSourceTypeVideoPraise = 0,
    LoginSourceTypeVideoTread,
    LoginSourceTypeVideoCollection,
    LoginSourceTypeVideoComment,
    LoginSourceTypeArticlePraise,
    LoginSourceTypeArticleTread,
    LoginSourceTypeArticleCollection,
    LoginSourceTypeArticleComment,
    LoginSourceTypeImagePraise,
    LoginSourceTypeImageTread,
    LoginSourceTypeImageCollection,
    LoginSourceTypeImageComment,
    LoginSourceTypeCommentPraise,
    LoginSourceTypeUserTabbarClick,
    LoginSourceTypeFollowAction,
    LoginSourceTypePublishClick,
    LoginSourceTypeRedPacketClick,
    LoginSourceTypeNetworkError,
};

typedef NS_ENUM(NSInteger, LoginPlatformType) {
    LoginPlatformTypeWechat = 0,
    LoginPlatformTypeQQ     = 1,
};

@protocol LoginViewModelDelegate

- (void)thirdpartyLoginDidSuccess;
- (void)thirdpartyLoginDidFailure:(NSInteger)errorCode;

@end

@interface LoginViewModel : NSObject

@property (weak, nonatomic) id <LoginViewModelDelegate> delegate;

///登录来源
@property (assign, nonatomic)           LoginSourceType   sourceType;
@property (assign, nonatomic, readonly) LoginPlatformType platformType;

- (instancetype)initWithSourceType:(LoginSourceType)sourceType;

- (void)thirdpartyLogin;

@end
