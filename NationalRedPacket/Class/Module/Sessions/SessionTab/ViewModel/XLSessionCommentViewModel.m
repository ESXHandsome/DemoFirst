//
//  XLSessionCommentViewModel.m
//  NationalRedPacket
//
//  Created by Ying on 2018/7/19.
//  Copyright © 2018 XLook. All rights reserved.
//

#import "XLSessionCommentViewModel.h"
#import "SessionsMessageApi.h"
#import "XLSessionCommentModel.h"

@implementation XLSessionCommentViewModel

- (void)loadMore {
    [SessionsMessageApi fetchReceiveComment:@"old" id:1 success:^(id responseDict) {
        [self.baseDelegate removeLoadView];
        
    } failure:^(NSInteger errorCode) {
        
    }];
}

- (void)refresh {
    @weakify(self);
    [SessionsMessageApi fetchReceiveComment:@"new" id:0 success:^(id responseDict) {
        @strongify(self);
        [self.baseDelegate removeLoadView];
         self.sessionMessageArray = [NSArray yy_modelArrayWithClass:XLSessionCommentModel.class json:responseDict[@"data"]];
        if (self.sessionMessageArray.count == 0) {
            [self.baseDelegate removeLoadView];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.baseDelegate emptyDate];
            });
        } else {
            [self.baseDelegate removeLoadView];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.baseDelegate refreshFinish];
            });
        }
            
    } failure:^(NSInteger errorCode) {
        @strongify(self);
        [self.baseDelegate removeLoadView];
        [self.baseDelegate emptyDate];
    }];
    
}
@end
