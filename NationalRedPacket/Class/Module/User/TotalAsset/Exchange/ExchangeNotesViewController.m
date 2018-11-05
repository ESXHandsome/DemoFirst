//
//  ExchangeNotesViewController.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/12/1.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "ExchangeNotesViewController.h"
#import "ExchangeNotesCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface ExchangeNotesViewController ()

@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) NSArray *contentArray;

@end

@implementation ExchangeNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"注意事项";
    self.titleArray = @[@[@"话费提现失败", @"原因", @"我该怎么办"], @[@"支付宝提现失败",@"原因", @"我该怎么办"]];
    self.contentArray = @[@[@"", @"电话号码填写错误", @"请重新填写电话号码，再次尝试提现"], @[@"", @"您的支付宝账号没有实名认证\n (支付宝公司规定：没有实名制认证的账号，无法正常接收转账）", @"登录支付宝网站，进行实名认证，然后再提交支付宝提现"]];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[ExchangeNotesCell class] forCellReuseIdentifier:ExchangeNotesCellID];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, adaptHeight1334(18))];
    self.tableView.sectionHeaderHeight = adaptHeight1334(22);
    self.tableView.sectionFooterHeight = 0;
    self.tableView.backgroundColor = [UIColor colorWithString:COLORF7F7F7];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.titleArray[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
        cell.textLabel.textColor = [UIColor colorWithString:COLORFF5A5D];
        cell.textLabel.font = [UIFont systemFontOfSize:adaptFontSize(32)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        
        ExchangeNotesCell *cell = [tableView dequeueReusableCellWithIdentifier:ExchangeNotesCellID forIndexPath:indexPath];
        cell.titleLabel.text = self.titleArray[indexPath.section][indexPath.row];
        cell.contentLabel.text = self.contentArray[indexPath.section][indexPath.row];
        [self setLabelSpec:cell.contentLabel];
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return adaptHeight1334(46*2);
    } else {
        return [tableView fd_heightForCellWithIdentifier:ExchangeNotesCellID configuration:^(ExchangeNotesCell *cell) {
            cell.titleLabel.text = self.titleArray[indexPath.section][indexPath.row];
            cell.contentLabel.text = self.contentArray[indexPath.section][indexPath.row];
            [self setLabelSpec:cell.contentLabel];
            
        }]+1;
    }
}

- (void)setLabelSpec:(UILabel *)label
{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:label.text attributes:nil];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:adaptHeight1334(6)];//行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, label.text.length)];
    label.attributedText = attributedString;
}

@end
