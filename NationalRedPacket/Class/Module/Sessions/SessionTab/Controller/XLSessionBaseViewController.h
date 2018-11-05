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
#import "XLRouter.h"
#import "SessionListViewModel.h"

@interface XLSessionBaseViewController : UIViewController

@property (assign, nonatomic) BOOL isEmpty; ///判断是否有数据
@property (strong, nonatomic) UITableView *tableView; ///表格视图
@property (strong, nonatomic) __kindof XLSessionBaseViewModel *viewModel;
@property (assign, nonatomic) NSInteger type;

@property (strong, nonatomic) SessionListViewModel *sessionListViewModel;


- (void)configureViewModel;
/**需要重写的方法*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
+ (__kindof UIViewController<XLRoutableProtocol> * _Nonnull)xlr_Instance ;
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end
