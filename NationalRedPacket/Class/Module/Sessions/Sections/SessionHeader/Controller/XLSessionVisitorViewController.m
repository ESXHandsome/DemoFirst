//
//  NewsVisiterViewController.m
//  NationalRedPacket
//
//  Created by Ying on 2018/5/28.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLSessionVisitorViewController.h"
#import "XLSessionBaseTableViewCell.h"

@interface XLSessionVisitorViewController ()

@end

@implementation XLSessionVisitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"访客";
//    self.isEmpty = YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XLSessionBaseTableViewCell *cell = [tableView xl_dequeueReusableCellWithClass:XLSessionBaseTableViewCell.class forIndexPath:indexPath];
    [cell cellSetImage:[UIImage imageNamed:@"my_slick"] authorName:@"路肯不代表本不懂不懂定发" tailString:@"访问了你的主页" buttonTitle:@""];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
