//
//  NewsBaseViewController.h
//  NationalRedPacket
//
//  Created by Ying on 2018/5/28.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLRefreshAutoGifFooter.h"
#import "XLSessionBaseViewModel.h"

@interface XLSessionBaseViewController : UIViewController

@property (assign, nonatomic) BOOL isEmpty; ///判断是否有数据
@property (strong, nonatomic) UITableView *tableView; ///表格视图
@property (strong, nonatomic) XLSessionBaseViewModel *viewModel;

/**需要继承的方法*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
