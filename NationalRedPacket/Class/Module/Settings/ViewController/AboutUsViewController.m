//
//  AboutUsViewController.m
//  NationalRedPacket
//
//  Created by 王海玉 on 2018/1/2.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "AboutUsViewController.h"
#import "PrivacyAndTermsViewController.h"
#import "PPSSetUpTableViewCell.h"
#import "PPSAboutUsHeaderView.h"
#import "PrivacyAndTermsViewController.h"
#import "UIApplication+AppStore.h"
#import "XLH5WebViewController.h"
#import "UserProtocolURL.h"

@interface AboutUsViewController ()
@property (nonatomic) NSMutableArray *rowsArray;
@property (nonatomic) NSArray *urlArray;
@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _rowsArray = @[@[@"服务协议",@"隐私政策", @"知识产权声明", @"免责声明"], @[@"给「神段子」一个好评"]].mutableCopy;
    _urlArray = @[URL_PRIVACY_TERMS,URL_PRIVACY_POLICY, URL_INTELL_PROPERTY, URL_DISCLAIMAR_STATE];
    self.title = @"关于我们";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:18]}];
    self.tableView.backgroundColor = [UIColor colorWithString:@"#F7F7F7"];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.tableHeaderView = [[PPSAboutUsHeaderView alloc] init];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorColor = [UIColor colorWithString:@"#F1F1F1"];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return adaptHeight1334(52*2);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_rowsArray[section] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _rowsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PPSSetUpTableViewCell *cell = [[PPSSetUpTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    [cell setTitleLabelText:_rowsArray[indexPath.section][indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0){
        XLH5WebViewController *webViewController = [XLH5WebViewController new];
        webViewController.urlString = self.urlArray[indexPath.row];
        [self showViewController:webViewController sender:nil];
    }else{
        [UIApplication commentInAppStore:@"1381390129"];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 0  ? adaptHeight1334(15*2) : 1 ;

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithString:@"#F7F7F7"];
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
