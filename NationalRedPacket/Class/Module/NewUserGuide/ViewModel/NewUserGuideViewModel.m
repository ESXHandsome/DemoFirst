//
//  NewUserGuideViewModel.m
//  NationalRedPacket
//
//  Created by Ying on 2018/4/8.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "NewUserGuideViewModel.h"
#import "NewUserGuideNetApi.h"
#import "TokenNetApi.h"
#import "NewUserGuideModel.h"
#import "LaunchViewModel.h"

@interface NewUserGuideViewModel()

@property (strong, nonatomic) NSMutableArray *updateArray;
@property (strong, nonatomic) NSArray *startPage;
@property (copy, nonatomic) NSString *firstStartPageAuthorId;
@property (strong ,nonatomic) LaunchViewModel *launchModel;

@end

@implementation NewUserGuideViewModel

-(instancetype)init{
    if(self = [super init]){
        _updateArray = [[NSMutableArray alloc] init];
        _launchModel = [[LaunchViewModel alloc] init];
    }
    return self;
}

//上传性别
-(void)uploadSex:(NSInteger)sex {
    [NewUserGuideNetApi fetchStartPageSex:sex success:^(id responseDict) {
        if(responseDict == nil) {
            [self.delegate uploadSexFailed];
        } else {
            self.startPage = [NSArray yy_modelArrayWithClass:NewUserGuideModel.class json:responseDict[@"list"]];
            if (self.startPage.count>0) {
                NewUserGuideModel *model = self.startPage.firstObject;
                self.firstStartPageAuthorId = model.authorId;
                [self.delegate uploadSexSucceed:self.startPage];
            } else {
                [self.delegate uploadSexFailed];
            }
        }
    } failure:^(NSInteger errorCode) {
        [self.delegate uploadSexFailed];
    }];    
}

- (void)fetchToken {
    [TokenNetApi fetchRequestToken:^(id responseDict)  {
        [self.delegate fetchTokenSucceed];
    } failure:^(NSInteger errorCode) {
        [self.delegate fetchTokenFailed];
    }];
}

//维护需要上传的AuthorID数组
- (void)maintenanceUpLoadAuthorldArray:(NSString *)authorld state:(BOOL) state {
    
    //监听cell按钮的状态 添加或删除信息
    if (state) {
        [self.updateArray removeObject:authorld];
    } else {
        [self.updateArray addObject:authorld];
    }
    
    //设置Controller按钮状态
    if (self.updateArray.count>0 && ![self.updateArray containsObject:self.firstStartPageAuthorId]) {
        [self.delegate changeStartButtonState:YES];
    } else if (self.updateArray.count > 1){
        [self.delegate changeStartButtonState:YES];
    } else {
        [self.delegate changeStartButtonState:NO];
    }
}

//上传AuthorID数组
- (void)uploadAuthorldArray {
    
    //关注的统计打点
    [self.updateArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XLPublisherModel *model = [XLPublisherModel new];
        model.authorId = obj;
        [StatServiceApi statEvent:FOLLOW_CLICK model:model];
    }];
    
    [NewUserGuideNetApi startPageFollowingList:self.updateArray
                                         count:self.updateArray.count
                                       success:^(id responseDict) {
        [self.delegate uploadAuthorldSucceed];
    } failure:^(NSInteger errorCode) {
        [self.delegate uploadAuthorldFailed];
    }];
}

- (void)prepareToLogin {
    [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:XLUserDefaultsIsNewUserKey];
    [self.launchModel resetWindowRootViewController];
}
@end

