//
//  NewsViewController.m
//  NationalRedPacket
//
//  Created by Ying on 2018/5/28.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "NewsViewController.h"
#import "XLSessionButtonContentView.h"
#import "XLSessionLikedViewController.h"
#import "XLSessionFansController.h"
#import "XLSessionCommentViewController.h"
#import "XLSessionVisitorViewController.h"

@interface NewsViewController () <NewsButtonContentViewDelegate>

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)setUpUI {
    NewsButtonContentView *contentView = [[NewsButtonContentView alloc] init];
    contentView.delegate = self;
    [self.view addSubview:contentView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - NewsContentViewDelegate
- (void)newsButtonContentViewButtonClicked:(NSInteger)tag {
    switch (tag) {
        case 0:
            [self showViewController:[NewsFansViewController new] sender:nil];
            break;
        case 1:
            [self showViewController:[NewsLikedViewController new] sender:nil];
            break;
        case 2:
            [self showViewController:[NewsCommentViewController new] sender:nil];
            break;
        case 3:
            [self showViewController:[NewsVisiterViewController new] sender:nil];
            break;
        default:
            break;
    }
}

@end
