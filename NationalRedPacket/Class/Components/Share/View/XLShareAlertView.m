//
//  XLShareAlertView.m
//  NationalRedPacket
//
//  Created by Ying on 2018/7/2.
//  Copyright © 2018 XLook. All rights reserved.
//

#import "XLShareAlertViewController.h"

@interface XLShareAlertViewController()

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *collectionViewFlowLayout;
@property (assign, nonatomic) BOOL hasMask;

@end

@implementation XLShareAlertViewController

#pragma mark -
#pragma mark - life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        UITapGestureRecognizer *tapGesture= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self.view addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
}

#pragma mark -
#pragma mark - action

- (void)tapAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark - public method

- (void)pushShareAlertViewController {
    if (self.hasMask) {
        self.view.backgroundColor = [UIColor colorWithString:COLOR000000];// 背景遮罩颜色
    }
}

#pragma mark -
#pragma mark - lazy load

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, adaptHeight1334(204*2)) collectionViewLayout:self.collectionViewFlowLayout];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)collectionViewFlowLayout {
    if (!_collectionViewFlowLayout) {
        _collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        
    }
    return _collectionViewFlowLayout;
}

@end
