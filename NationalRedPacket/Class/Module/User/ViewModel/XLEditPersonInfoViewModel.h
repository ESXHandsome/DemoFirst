//
//  XLEditPersonInfoViewModel.h
//  NationalRedPacket
//
//  Created by Ying on 2018/7/27.
//  Copyright © 2018 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLUserManager.h"

@protocol XLEditPersonInfoViewModelDelegate <NSObject>

- (void)finishToUploadPersonInfo;

@end

NS_ASSUME_NONNULL_BEGIN

@interface XLPersonInfoModel : NSObject

@property (strong, nonatomic) UIImage *avatar;
@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *sex;
@property (copy, nonatomic) NSString *birth;
@property (copy, nonatomic) NSString *province;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *intro;

@end


@interface XLEditPersonInfoViewModel : NSObject

@property (copy, nonatomic) NSArray *items;
@property (strong, nonatomic) PPSMyInfoModel *dataSource;
@property (weak, nonatomic) id<XLEditPersonInfoViewModelDelegate> delegate;

- (void)configDataSource;

- (void)uploadPersonInfo:(XLPersonInfoModel *)model;

@end

NS_ASSUME_NONNULL_END
