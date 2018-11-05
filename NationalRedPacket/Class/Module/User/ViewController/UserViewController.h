//
//  UserViewController.h
//  NationalRedPacket
//
//  Created by 王海玉 on 2017/12/29.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLFeedModel.h"
@interface UserViewController : UIViewController
@property (strong, nonatomic) XLFeedModel *newsModel;
@property (strong, nonatomic) UITableView *tableView;
@end
