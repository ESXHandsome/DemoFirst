//
//  XLPostViewController.m
//  NationalRedPacket
//
//  Created by Ying on 2018/7/11.
//  Copyright © 2018 XLook. All rights reserved.
//

#import "XLPostAlertViewController.h"
#import "XLDimmingPresentationController.h"

@interface XLPostAlertViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIButton *cancelButton;

@property (strong, nonatomic) NSArray *titleArray;  ///标题
@property (strong, nonatomic) NSArray *iconArray;   ///图标

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation XLPostAlertViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)presentPostAlertViewController:(UIViewController *)contentView {
    self.view.height = adaptHeight1334(46*2 + 112*2*self.titleArray.count);
    XLDimmingPresentationController *pc = [[XLDimmingPresentationController alloc] initWithPresentedViewController:self presentingViewController:contentView];
    self.transitioningDelegate = pc;
    [contentView presentViewController:self animated:YES completion:nil];
}

#pragma mark -
#pragma mark - Private Method

- (void)configUI {
    [self.view addSubview:self.cancelButton];
    [self.view addSubview:self.tableView];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(adaptHeight1334(48*2));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.cancelButton.mas_top);
        make.height.mas_equalTo(adaptHeight1334(226*self.titleArray.count));
    }];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark - Button Action

- (void)cancelButtonAction {
    [self dismiss];
}

#pragma mark -
#pragma mark - UITableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return adaptHeight1334(112*2);
}

#pragma mark -
#pragma mark - Lazy load

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(32)];
        [_cancelButton setTitleColor:[UIColor colorWithString:COLOR060606] forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithString:COLORB5B5B5] forState:UIControlStateHighlighted];
        CGSize size = CGSizeMake(SCREEN_WIDTH, adaptHeight1334(98));
        [_cancelButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:size] forState:UIControlStateNormal];
        [_cancelButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithString:COLORECECEB] size:size] forState:UIControlStateHighlighted];
        [_cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        [_tableView registerClass:XLShareAlertTableViewCell.class forCellReuseIdentifier:NSStringFromClass(XLShareAlertTableViewCell.class)];
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, adaptHeight1334(226 * self.titleArray.count));
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_tableView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(adaptHeight1334(10), adaptHeight1334(10))];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _tableView.bounds;
        maskLayer.path = maskPath.CGPath;
        _tableView.layer.mask = maskLayer;
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                        initWithTarget:self
                                                        action:@selector(handlePan:)];
        [_tableView addGestureRecognizer:panGestureRecognizer];
        
    }
    return _tableView;
}

#pragma mark -
#pragma mark - Gseture

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self.tableView];
    if (translation.y > 0) {
        self.tableView.frame = CGRectMake(0, translation.y, SCREEN_WIDTH, self.tableView.height);
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [recognizer velocityInView:self.tableView];
        if (self.tableView.frame.origin.y > self.view.height*0.6 || velocity.y > 500) {
            [self dismiss];
        } else {
            [UIView animateWithDuration:0.1f animations:^{
                self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.tableView.height);
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}
@end
