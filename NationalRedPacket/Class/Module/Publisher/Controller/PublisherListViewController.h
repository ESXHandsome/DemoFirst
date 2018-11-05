//
//  PublisherListViewController.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/8.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublisherViewModel.h"

@interface PublisherListViewController : UITableViewController

@property (strong, nonatomic) PublisherViewModel *viewModel;
@property (strong, nonatomic) NSString *authorID;

@end
