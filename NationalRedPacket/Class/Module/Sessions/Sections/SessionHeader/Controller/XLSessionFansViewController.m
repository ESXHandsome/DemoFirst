//
//  NewsFansViewController.m
//  NationalRedPacket
//
//  Created by Ying on 2018/5/28.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLSessionFansViewController.h"
#import "XLSessionBaseTableViewCell.h"

@interface XLSessionFansViewController ()

@end

@implementation XLSessionFansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title = @"粉丝";
//    self.isEmpty = YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XLSessionBaseTableViewCell *cell = [tableView xl_dequeueReusableCellWithClass:XLSessionBaseTableViewCell.class forIndexPath:indexPath];
    [cell cellSetImage:[UIImage imageNamed:@"my_slick"] authorName:@"路肯不代表本不懂不懂定发" tailString:@"关注了你" buttonTitle:@""];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
