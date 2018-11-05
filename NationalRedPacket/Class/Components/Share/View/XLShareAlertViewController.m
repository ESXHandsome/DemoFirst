//
//  XLShareAlertView.m
//  NationalRedPacket
//
//  Created by Ying on 2018/7/2.
//  Copyright © 2018 XLook. All rights reserved.
//

#import "XLShareAlertViewController.h"
#import "XLShareAlertViewModel.h"
#import "XLShareAlertTableViewCell.h"
#import "XLDimmingPresentationController.h"
#import "XLReportSheetAlertViewController.h"

@interface XLShareAlertViewController() <UITableViewDelegate, UITableViewDataSource, XLShareAlertViewModelDelegate, XLShareAlertTableViewCellDelegate>

@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) XLShareAlertViewModel *viewModel;
@property (strong, nonatomic) UITableView *tableView;
/// 标题数组
@property (strong, nonatomic) NSArray *titleArray;
/// 图标数组
@property (strong, nonatomic) NSArray *iconArray;
/// 举报模型数组
@property (strong, nonatomic) NSArray *shareTitleArray;
@property (strong, nonatomic) NSArray *shareIconArray;

@property (strong, nonatomic) NSMutableArray *toolTitleArray;
@property (strong, nonatomic) NSMutableArray *toolIconArray;

@property (strong, nonatomic) XLShareReportModel *reportModel;

@end

@implementation XLShareAlertViewController

#pragma mark -
#pragma mark - life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.shareTitleArray = @[@"微信",@"朋友圈",@"QQ",@"QQ空间"];
        self.toolTitleArray = [NSMutableArray arrayWithArray:@[@"收藏",@"举报",@"拉黑"]];
        
        self.shareIconArray = @[@"share_wechat",@"share_timeline",@"share_qq",@"share_zone"];
        self.toolIconArray = [NSMutableArray arrayWithArray:@[@"detail_comment_collection_n",@"detail_comment_report",@"blacklist"]];
        
        self.titleArray = @[self.shareTitleArray,self.toolTitleArray];
        self.iconArray  = @[self.shareIconArray,self.toolIconArray];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.cancelButton];
    
    [self configUI];
    [self configModel];
    
    if (self.viewModel.shareCollectionModel.isCollection) {
        [self.toolIconArray replaceObjectAtIndex:0 withObject:@"detail_comment_collection_h"];
    }
    
}

#pragma mark -
#pragma mark - action

- (void)tapAction {
    [self dismiss];
}

- (void)cancelButtonAction {
    [self dismiss];
}

#pragma mark -
#pragma mark - private Method

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)configUI {
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

#pragma mark -
#pragma mark - public method

- (void)onlyShare {
    self.titleArray  = @[self.shareTitleArray];
    self.iconArray   = @[self.shareIconArray];
}

- (void)onlyTool {
    self.titleArray  = @[self.toolTitleArray];
    self.iconArray   = @[self.toolIconArray];
}

- (void)resetTool:(NSArray *)titleArray icon:(NSArray *)iconArray {
    
    [self.toolIconArray removeAllObjects];
    [self.toolIconArray addObjectsFromArray:iconArray];
    [self.toolTitleArray removeAllObjects];
    [self.toolTitleArray addObjectsFromArray:titleArray];
}

- (void)addObjectToTool:(NSString *)title icon:(NSString *)icon {
    [self.toolIconArray addObject:icon];
    [self.toolTitleArray addObject:title];
}

- (void)presentSheetAlertViewController:(UIViewController *)contentView {
    self.view.height = adaptHeight1334(48*2 + 113*2*self.titleArray.count);
    XLDimmingPresentationController *pc = [[XLDimmingPresentationController alloc] initWithPresentedViewController:self presentingViewController:contentView];
    self.transitioningDelegate = pc;
    [contentView presentViewController:self animated:YES completion:nil];
}

- (void)configModel {
    if ([self.shareDelegate respondsToSelector:@selector(configShareModel)]) {
        if ([[self.shareDelegate configShareModel] isKindOfClass:XLShareURLModel.class]) {
            self.viewModel.shareURLModel = [self.shareDelegate configShareModel];
        } else if ([[self.shareDelegate configShareModel] isKindOfClass:XLShareImageModel.class]) {
            self.viewModel.shareImageModel = [self.shareDelegate configShareModel];
        } else if ([[self.shareDelegate configShareModel] isKindOfClass:XLShareFeedModel.class]) {
            self.viewModel.shareFeedModel = [self.shareDelegate configShareModel];
        } else {
            
        }
    }
    
    if ([self.shareDelegate respondsToSelector:@selector(configUploadCollection)]) {
        self.viewModel.shareCollectionModel = [self.shareDelegate configUploadCollection];
    }
    
    if ([self.shareDelegate respondsToSelector:@selector(configUploadReport)]) {
        self.reportModel = [self.shareDelegate configUploadReport];
    }
    
    if ([self.shareDelegate respondsToSelector:@selector(configUpLoadBackList)]) {
        self.viewModel.shareBackListModel = [self.shareDelegate configUpLoadBackList];
    }
    
    if ([self.shareDelegate respondsToSelector:@selector(configDeleteModel)]) {
        self.viewModel.deleteFeedModel = [self.shareDelegate configDeleteModel];
    }
    
    if ([self.shareDelegate respondsToSelector:@selector(configSaveVideo)]) {
        self.viewModel.saveVideoModel = [self.shareDelegate configSaveVideo];
    }
  
}

#pragma mark -
#pragma mark - table Delegate and DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XLShareAlertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(XLShareAlertTableViewCell.class)];
    cell.delegate = self;
    cell.titleArray = self.titleArray[indexPath.row];
    cell.iconArray = self.iconArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return adaptHeight1334(113*2);
}

#pragma mark -
#pragma mark - ViewModel delegate

- (void)showHUD:(BOOL)type {
    if (type) {
        [MBProgressHUD showChrysanthemum:@"分享中，请稍后" toView:self.view];
    } else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

- (void)presentReportView {
    if (!self.reportModel) {
        [self dismiss];
        return;
    }
    @weakify(self);
    [self dismissViewControllerAnimated:YES completion:^{
        XLReportSheetAlertViewController *vc = [[XLReportSheetAlertViewController alloc] init];
        @strongify(self);
        [vc presentReportAlertViewController:[UIViewController currentViewController] itemID:self.reportModel.itemID type:[self.reportModel.type integerValue] complete:^{
        }];
    }];
}

- (void)deleteFeedItem {
    if ([self.shareDelegate respondsToSelector:@selector(deleteFeedCell)]) {
        [self.shareDelegate deleteFeedCell];
    }
}

#pragma mark -
#pragma mark - Share Alert tableView delegate

- (void)didClickItem:(XLShareAlertCollectionViewCell *)item {
    self.viewModel.shareType = NO;
    [self.viewModel chooseToOpen:item.title];
    if ([item.title isEqualToString:@"举报"]) {
        
    } else {
        [self dismiss];
    }
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

- (XLShareAlertViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[XLShareAlertViewModel alloc] init];
        _viewModel.delegate = self;
    }
    return _viewModel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:XLShareAlertTableViewCell.class forCellReuseIdentifier:NSStringFromClass(XLShareAlertTableViewCell.class)];
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
