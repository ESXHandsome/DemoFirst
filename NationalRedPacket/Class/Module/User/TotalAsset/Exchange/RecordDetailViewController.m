//
//  RecordDetailViewController.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/26.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "RecordDetailViewController.h"
#import "RecordStateCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "RecordSuccessCell.h"
#import "UserFeedbackViewController.h"
#import "RecordViewController.h"
#import "ExchangeEditController.h"
#import "NSDate+Timestamp.h"

@interface RecordDetailViewController ()

@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) NSArray *contentArray;

@property (strong, nonatomic) UIButton *completeButton;

@end

@implementation RecordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[RecordSuccessCell class] forCellReuseIdentifier:RecordSuccessCellID];
    [self.tableView registerClass:[RecordStateCell class] forCellReuseIdentifier:RecordStateCellID];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    
    if ([self.model.exchangeMode isEqualToString:@"ALIPAY_NATIVE"]) {
        self.title = @"支付宝提现";
        self.titleArray = @[@"提现金额", @"提现账号", @"申请提现时间", @"提现类型"];
        self.contentArray = @[[NSString stringWithFormat:@"￥%.2f", self.model.money.floatValue], self.model.account,[NSDate switchTimestamp:self.model.createdAt.integerValue toFormatStr:@"yyyy-MM-dd HH:mm:ss"], @"支付宝"];
    } else {
        self.title = @"话费提现";
        self.titleArray = @[@"提现金额", @"提现手机号", @"申请提现时间", @"提现类型"];
        self.contentArray = @[[NSString stringWithFormat:@"￥%.2f", self.model.money.floatValue], self.model.account, [NSDate switchTimestamp:self.model.createdAt.integerValue toFormatStr:@"yyyy-MM-dd HH:mm:ss"], @"话费"];
    }
    
    if (self.model.status == ExchangeStatusFail) {
        [self.tableView addSubview:self.completeButton];
        [self.completeButton setTitle:@"我要反馈" forState:UIControlStateNormal];
    }
    
    if (self.isFromExchange) {
        [self.tableView addSubview:self.completeButton];
    }
}

- (void)completeAction
{
    if (self.model.status == ExchangeStatusFail) {
        [self showViewController:[UserFeedbackViewController new] sender:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isFromExchange) {
        [self changeNavigationControllers];
    }
}

//修改栈中的controller (将栈中的兑换编辑页面删除，插入兑换记录页面)
- (void)changeNavigationControllers
{
    if (self.navigationController.viewControllers.count >= 3) {
        NSMutableArray *array = self.navigationController.viewControllers.mutableCopy;
        if ([array[array.count - 2] isKindOfClass:[ExchangeEditController class]]) {
            [array removeObjectAtIndex:array.count - 2];
            RecordViewController *recordVC = [RecordViewController new];
            [array insertObject:recordVC atIndex:array.count - 1];
            [self.navigationController setViewControllers:array animated:NO];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.model.status == ExchangeStatusSuccess) {
            return [self.tableView fd_heightForCellWithIdentifier:RecordSuccessCellID configuration:^(RecordSuccessCell *cell) {
                [cell configModelData:self.model indexPath:indexPath];
            }];
        } else {
            return [self.tableView fd_heightForCellWithIdentifier:RecordStateCellID configuration:^(RecordStateCell *cell) {
                [cell configModelData:self.model indexPath:indexPath];
            }];
        }
        
    } else {
        return adaptHeight1334(70);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        if (self.model.status == ExchangeStatusSuccess) {
            cell = [tableView dequeueReusableCellWithIdentifier:RecordSuccessCellID forIndexPath:indexPath];
            [((RecordSuccessCell *)cell) configModelData:self.model indexPath:indexPath];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:RecordStateCellID forIndexPath:indexPath];
            [((RecordStateCell *)cell) configModelData:self.model indexPath:indexPath];
        }

    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        UILabel *titleLabel = [UILabel labWithText:self.titleArray[indexPath.row] fontSize:adaptFontSize(28) textColorString:COLOR888888];
        [cell.contentView addSubview:titleLabel];
        
        UILabel *contentLabel = [UILabel labWithText:self.contentArray[indexPath.row] fontSize:adaptFontSize(28) textColorString:COLOR333333];
        [cell.contentView addSubview:contentLabel];
        
        [titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(adaptWidth750(26*2));
            make.centerY.equalTo(cell.contentView);
        }];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView).offset(-adaptWidth750(26*2));
            make.centerY.equalTo(cell.contentView);
        }];
    }
    return cell;
}

- (UIButton *)completeButton
{
    if (!_completeButton) {
        self.completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.completeButton.frame = CGRectMake(0, 0, adaptWidth750(162*2), adaptHeight1334(36*2));
        self.completeButton.centerX = self.view.centerX;
        self.completeButton.y = SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - adaptHeight1334(77*2);
        [self.completeButton setTitle:@"完成" forState:UIControlStateNormal];
        [self.completeButton setTitleColor:[UIColor colorWithString:COLORFF8100] forState:UIControlStateNormal];
        self.completeButton.layer.borderWidth = 1;
        self.completeButton.layer.borderColor = [UIColor colorWithString:COLORFF8100].CGColor;
        self.completeButton.layer.cornerRadius = 4;
        [self.completeButton addTarget:self action:@selector(completeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completeButton;
}

@end
