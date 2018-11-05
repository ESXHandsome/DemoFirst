//
//  XLSheetAlertViewController.m
//  NationalRedPacket
//
//  Created by Ying on 2018/4/25.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLReportSheetAlertViewController.h"
#import "XLReportSheetAlertTableViewCell.h"
#import "XLDimmingPresentationController.h"
#import "NewsApi.h"

@interface XLReportSheetAlertViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (copy  , nonatomic) NSArray *textArray;
@end

@implementation XLReportSheetAlertViewController

#pragma mark - lifeCircle
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.titleLabel];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).mas_offset(adaptHeight1334(49*2));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.tableView.mas_top);
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textArray = @[@"淫秽色情",@"违法信息",@"营销广告",@"恶意攻击谩骂",@"其他"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark -tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return adaptHeight1334(45*2);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XLReportSheetAlertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell" forIndexPath:indexPath];
    cell.label.text = self.textArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.completion) {
        self.completion(self.textArray[indexPath.row]);
    }
  
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - public method
/*评论举报*/
- (void)presentSheetAlertViewController:(UIViewController *)contentView itemID:(NSString *)itemID type:(NSInteger) type complete:(void(^)(void))complete{
    self.view.height = adaptHeight1334(270*2);
    XLDimmingPresentationController *pc = [[XLDimmingPresentationController alloc] initWithPresentedViewController:self presentingViewController:contentView];
    self.transitioningDelegate = pc;
    self.completion = ^(NSString *content) {
        [NewsApi reportCommentWithId:itemID commentType:type == FeedCommentListFirstlyRowType ? 1 : 2 reprotContent:content success:^(id responseDict) {
            [MBProgressHUD showSuccess:@"举报成功，管理员会根据相关规则认真审核"];
            if (complete)
                complete();
        } failure:^(NSInteger errorCode) {
            [MBProgressHUD showSuccess:@"举报失败"];
        }];
    };
    [contentView presentViewController:self animated:YES completion:nil];
}

/*举报弹窗 */
- (void)presentReportAlertViewController:(UIViewController *)contentView itemID:(NSString *)itemID type:(NSInteger) type complete:(void(^)(void))complete {
    self.textArray = @[@"淫秽色情",@"违法信息",@"营销广告",@"不实信息",@"其他"];
    self.view.height = adaptHeight1334(270*2);
    XLDimmingPresentationController *pc = [[XLDimmingPresentationController alloc] initWithPresentedViewController:self presentingViewController:contentView];
    pc.opaque = YES;
    self.transitioningDelegate = pc;
    self.completion = ^(NSString *content) {
        [NewsApi negativeFeedbackWithItemId:itemID type:[NSString stringWithFormat:@"%ld",(long)type] action:content isReport:YES success:^(id responseDict) {
            [MBProgressHUD showSuccess:@"举报成功，管理员会根据相关规则认真审核"];
            if (complete)
                complete();
        } failure:^(NSInteger errorCode) {
            [MBProgressHUD showSuccess:@"举报失败"];
        }];
    };
    [contentView presentViewController:self animated:YES completion:nil];
}

/* 举报发布者 */
- (void)presentReportAlertViewController:(UIViewController *)contentView publisherId:(NSString *)publisherId complete:(void(^)(void))complete {
    
    self.textArray = @[@"淫秽色情",@"违法信息",@"营销广告",@"不实信息",@"其他"];
    self.view.height = adaptHeight1334(270*2);
    XLDimmingPresentationController *pc = [[XLDimmingPresentationController alloc] initWithPresentedViewController:self presentingViewController:contentView];
    self.transitioningDelegate = pc;
    self.completion = ^(NSString *content) {
        [NewsApi reprotPublisher:publisherId content:content success:^(id responseDict) {
            [MBProgressHUD showSuccess:@"举报成功，管理员会根据相关规则认真审核"];
            if (complete) {
                complete();
            }
        } failure:^(NSInteger errorCode) {
            [MBProgressHUD showSuccess:@"举报失败"];
        }];
    };
    [contentView presentViewController:self animated:YES completion:nil];
    
}

#pragma mark -getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"XLSheetAlertTableViewCell" bundle:nil] forCellReuseIdentifier:@"tableViewCell"];
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labWithText:@"举报" fontSize:adaptFontSize(16*2) textColorString:COLOR222222];
        _titleLabel.font = [UIFont boldSystemFontOfSize:adaptFontSize(16*2)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
