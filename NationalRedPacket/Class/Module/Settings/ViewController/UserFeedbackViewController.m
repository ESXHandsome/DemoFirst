//
//  FeedBackViewController.m
//  NationalRedPacket
//
//  Created by 王海玉 on 2018/1/2.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "UserFeedbackViewController.h"
#import "FeedBackView.h"
#import "FeedBackApi.h"

@interface UserFeedbackViewController ()

@property (strong, nonatomic) FeedBackView *feedbackView;

@end

@implementation UserFeedbackViewController

- (void)loadView {
    [super loadView];
    self.feedbackView = [[FeedBackView alloc] initWithFrame:self.view.frame];
    self.view = self.feedbackView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"意见反馈";
    self.automaticallyAdjustsScrollViewInsets = NO;
    @weakify(self);
    self.feedbackView.backResult = ^(NSInteger index) {
        @strongify(self);
        if (self.feedbackView.feedbackTextView.text.length < 10) {
            [MBProgressHUD showError:@"请填写10个字以上的问题描述"];
            return;
        }
        [FeedBackApi feedBackWithOpinion:self.feedbackView.feedbackTextView.text
                                  Number:self.feedbackView.contactTextField.text
                                 success:^(id responseDict) {
                                     @strongify(self);
                                     [MBProgressHUD showSuccess:@"提交成功"];
                                     [self.navigationController popViewControllerAnimated:YES];
                                 }
                                 failure:^(NSInteger errorCode) {
                                     [MBProgressHUD showError:@"提交失败"];
                                 }];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
