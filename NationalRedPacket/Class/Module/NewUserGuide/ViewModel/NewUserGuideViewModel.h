//
//  NewUserGuideViewModel.h
//  NationalRedPacket
//
//  Created by Ying on 2018/4/8.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NewUserGuideViewModelDelegate <NSObject>

@optional

- (void)finishLoadData:(NSArray *)array;
- (void)fetchTokenSucceed;
- (void)fetchTokenFailed;
- (void)uploadSexSucceed:(NSArray *)array;
- (void)uploadSexFailed;
- (void)uploadAuthorldSucceed;
- (void)uploadAuthorldFailed;
- (void)changeStartButtonState:(BOOL)state;

@end

@interface NewUserGuideViewModel : NSObject

@property (weak,nonatomic) id<NewUserGuideViewModelDelegate> delegate;

/**
 上传性别

 @param sex 性别
 */
- (void)uploadSex:(NSInteger)sex;
- (void)fetchToken;

/**
 维护需要上传的AuthorId数组

 @param authorld AuthorId String
 @param state 添加或删除
 */
- (void)maintenanceUpLoadAuthorldArray:(NSString *)authorld state:(BOOL) state;
- (void)uploadAuthorldArray;
- (void)prepareToLogin;

@end
