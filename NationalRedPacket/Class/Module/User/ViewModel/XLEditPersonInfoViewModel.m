//
//  XLEditPersonInfoViewModel.m
//  NationalRedPacket
//
//  Created by Ying on 2018/7/27.
//  Copyright © 2018 XLook. All rights reserved.
//

#import "XLEditPersonInfoViewModel.h"
#import "AliyunOSSApi.h"
#import "UserApi.h"

@implementation XLPersonInfoModel

@end

@interface XLEditPersonInfoViewModel ()
@property (strong, nonatomic) NSMutableDictionary *personItemInfo;
@property (strong, nonatomic) XLPersonInfoModel *model;
@property (strong, nonatomic) MBProgressHUD *HUD;
@end

@implementation XLEditPersonInfoViewModel
- (NSArray *)items {
    if (!_items) {
        _items = @[@"昵称",@"性别",@"生日",@"地区",@"签名"];
    }
    return _items;
}

- (void)configDataSource {
    self.dataSource = XLUserManager.shared.userInfoModel.myInfo;
}

- (void)uploadPersonInfo:(XLPersonInfoModel *)model {
    
    if ([model.nickname isEqualToString:@""]) {
        [MBProgressHUD showSuccess:@"昵称不能为空"];
        return;
    }
    
    self.HUD = [MBProgressHUD showChrysanthemum:@"上传中..."];
    self.HUD.offset = CGPointMake(0, -50);
    self.model = model;
    if (model.avatar) {
        @weakify(self);
        [[AliyunOSSApi alloc] uploadObjectAsyncWithImage:model.avatar imageFileURL:nil success:^(id responseDict) {
            @strongify(self);
            NSString *image = responseDict[@"image"];
            self.personItemInfo = [NSMutableDictionary dictionaryWithDictionary:@{@"avatar":image}];
            [self uploadPersoninfomation:self.personItemInfo];
        } failure:^(NSInteger errorCode) {
            [MBProgressHUD showSuccess:@"上传失败"];
        }];
    } else {
        self.personItemInfo =[NSMutableDictionary dictionaryWithDictionary: @{}];
        [self uploadPersoninfomation:self.personItemInfo];
    }
}

- (void)uploadPersoninfomation:(NSDictionary *)info {
    
    if (self.model.nickname) {
        [self.personItemInfo setValue:self.model.nickname forKey:@"nickname"];
//        XLUserManager.shared.userInfoModel.myInfo.nickname = self.model.nickname;
   
    }
    if (self.model.sex) {
        [self.personItemInfo setValue:self.model.sex forKey:@"sex"];
//        XLUserManager.shared.userInfoModel.myInfo.sex = self.model.sex;
    
    }
    if (self.model.birth) {
        [self.personItemInfo setValue:self.model.birth forKey:@"birth"];
//        XLUserManager.shared.userInfoModel.myInfo.birth = self.model.birth;

    }
    if (self.model.province) {
        [self.personItemInfo setValue:self.model.province forKey:@"province"];
//        XLUserManager.shared.userInfoModel.myInfo.province = self.model.province;

    }
    if (self.model.city) {
        [self.personItemInfo setValue:self.model.city forKey:@"city"];
//        XLUserManager.shared.userInfoModel.myInfo.city = self.model.city;

    }
    if (self.model.intro) {
        [self.personItemInfo setValue:self.model.intro forKey:@"intro"];
//        XLUserManager.shared.userInfoModel.myInfo.intro = self.model.intro;

    }
    
    
    @weakify(self);
    [UserApi uploadPersonInfo:self.personItemInfo success:^(id responseDict) {
        @strongify(self);
        [self.HUD hideAnimated:YES];
        switch ([responseDict[@"result"] integerValue]) {
            case 0: {
                [MBProgressHUD showSuccess:@"上传成功"];
                if ([self.delegate respondsToSelector:@selector(finishToUploadPersonInfo)]) {
                    [self.delegate finishToUploadPersonInfo];
                }
                break;
            }
            case 2: {
                [MBProgressHUD showSuccess:@"昵称中含有违规内容，请重新修改"];
                break;
            }
            case 3: {
                [MBProgressHUD showSuccess:@"签名中含有违规内容，请重新修改"];
                break;
            }
        }
        
    } failure:^(NSInteger errorCode) {
        [self.HUD hideAnimated:YES];
        [MBProgressHUD showSuccess:@"上传失败"];
    }];
}

@end
