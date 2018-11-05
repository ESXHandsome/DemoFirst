//
//  ExchangeAlertView.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/23.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "ExchangeAlertView.h"

@interface ExchangeAlertView () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *alertTableView;

@property (strong, nonatomic) UIView      *headerView;
@property (strong, nonatomic) UIButton    *closeButton;
@property (strong, nonatomic) UILabel     *titleLabel;
@property (strong, nonatomic) UIView      *specLine;
@property (strong, nonatomic) UILabel     *moneyLabel;

@property (strong, nonatomic) UIView      *footerView;
@property (strong, nonatomic) UIButton    *sureButton;

@property (strong, nonatomic) NSArray     *dataArray;
@property (strong, nonatomic) NSArray     *typeArray;

@property (copy, nonatomic) void (^sureInfoAction)(void);

@end

@implementation ExchangeAlertView

- (void)setupViews
{
    UIColor * color = [UIColor blackColor];
    self.backgroundColor = [color colorWithAlphaComponent:0.6];
    
    self.alertTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, adaptHeight1334(496*2)) style:UITableViewStylePlain];
    self.alertTableView.backgroundColor = [UIColor whiteColor];
    self.alertTableView.scrollEnabled = NO;
    self.alertTableView.delegate = self;
    self.alertTableView.dataSource = self;
    [self.alertTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.alertTableView.rowHeight = adaptHeight1334(84);
    [self addSubview:self.alertTableView];
    
    self.alertTableView.tableHeaderView = self.headerView;
    self.alertTableView.tableFooterView = [UIView new];
    [self.alertTableView addSubview:self.footerView];
    
}

+ (void)showExchangeSureViewWithType:(ExchangeType)exchangeType sureInfo:(NSMutableDictionary *)dicInfo sureInfoCallBack:(void(^)(void))sureInfoCallBack
{
    
    ExchangeAlertView *sureView = [ExchangeAlertView new];
    sureView.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f", [dicInfo[@"money"] floatValue]];
    if (exchangeType == ExchangeTypeAlipay) {
        sureView.dataArray = @[@"支付宝", dicInfo[@"exchangeAccount"], dicInfo[@"realname"]];
        sureView.typeArray = @[@"提现类型", @"支付宝账号", @"姓名"];
    } else {
        sureView.dataArray = @[@"话费", dicInfo[@"exchangeAccount"]];
        sureView.typeArray = @[@"提现类型", @"手机号"];
    }
    sureView.sureInfoAction = sureInfoCallBack;
    [sureView show];
}

- (void)sureAction
{
    if (self.sureInfoAction) {
        [self dismiss];
        self.sureInfoAction();
    }
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.typeArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:adaptFontSize(32)];
    cell.textLabel.textColor = [UIColor colorWithString:COLOR737373];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *infoLabel = [UILabel labWithText:self.dataArray[indexPath.row] fontSize:adaptFontSize(32) textColorString:COLOR000000];
    [cell.contentView addSubview:infoLabel];
    
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.right.equalTo(cell.contentView).offset(-adaptWidth750(22));
    }];
    
    return cell;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alertTableView.y = SCREEN_HEIGHT - self.alertTableView.height;
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alertTableView.y = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/**
 手势冲突解决
 
 @param gestureRecognizer 手势
 @param touch touch
 @return 是否支持手势
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

- (UIView *)headerView
{
    if (!_headerView) {
        self.headerView = [UIView new];
        self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, adaptHeight1334(117*2));
        
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [self.closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:self.closeButton];
        
        self.titleLabel = [UILabel labWithText:@"确认信息" fontSize:adaptFontSize(36) textColorString:COLOR020202];
        [self.headerView addSubview:self.titleLabel];
        
        self.specLine = [UIView new];
        self.specLine.backgroundColor = [UIColor colorWithString:COLORCECECE];
        [self.headerView addSubview:self.specLine];
        
        self.moneyLabel = [UILabel labWithText:@"¥50.00" fontSize:adaptFontSize(68) textColorString:COLOR020202];
        self.moneyLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:adaptFontSize(68)];
        [self.headerView addSubview:self.moneyLabel];
        
        [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.headerView);
            make.height.width.mas_equalTo(adaptHeight1334(88));
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.closeButton);
            make.centerX.equalTo(self.headerView);
        }];
        
        [self.specLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.headerView);
            make.top.equalTo(self.closeButton.mas_bottom);
            make.height.mas_equalTo(0.5);
        }];
        
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.headerView);
            make.top.equalTo(self.specLine.mas_bottom).offset(adaptHeight1334(30));
        }];
        
    }
    return _headerView;
}

- (UIView *)footerView
{
    if (!_footerView) {
        
        self.footerView = [UIView new];
        self.footerView.frame = CGRectMake(0, self.alertTableView.height - adaptHeight1334(76*2), SCREEN_WIDTH, adaptHeight1334(76*2));
        self.footerView.backgroundColor = [UIColor whiteColor];
        
        self.sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.sureButton setTitle:@"确认" forState:UIControlStateNormal];
        self.sureButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(40)];
        self.sureButton.backgroundColor = [UIColor colorWithString:COLOR108EE9];
        [self.sureButton setTitleColor:[UIColor colorWithString:COLORffffff] forState:UIControlStateNormal];
        self.sureButton.layer.cornerRadius = 4;
        self.sureButton.layer.masksToBounds = YES;
        [self.sureButton addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        [self.footerView addSubview:self.sureButton];
        
        [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.footerView).offset(adaptWidth750(30));
            make.right.equalTo(self.footerView).offset(-adaptWidth750(30));
            make.height.mas_equalTo(adaptHeight1334(84));
            make.centerY.equalTo(self.footerView);
        }];
        
    }
    return _footerView;
}

@end
