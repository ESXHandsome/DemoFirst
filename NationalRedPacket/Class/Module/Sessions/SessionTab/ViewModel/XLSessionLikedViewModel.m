//
//  XLSessionLikedViewModel.m
//  NationalRedPacket
//
//  Created by Ying on 2018/7/19.
//  Copyright © 2018 XLook. All rights reserved.
//

#import "XLSessionLikedViewModel.h"
#import "SessionsMessageApi.h"
#import "XLSessionCommentModel.h"

@implementation XLSessionLikedViewModel
- (void)loadMore {
    [SessionsMessageApi fetchReceivePraise:@"old" id:1 success:^(id responseDict) {
        
    } failure:^(NSInteger errorCode) {
        
    }];
}

- (void)refresh {
    @weakify(self);
    [SessionsMessageApi fetchReceivePraise:@"new" id:0 success:^(id responseDict) {
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
