//
//  XLSheetAlertViewController.h
//  NationalRedPacket
//
//  Created by Ying on 2018/4/25.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedCommentListRowModel.h"

@interface XLReportSheetAlertViewController : UIViewController

@property (copy, nonatomic) void(^completion)(NSString *content);

- (void)presentSheetAlertViewController:(UIViewController *)contentView itemID:(NSString *)itemID type:(NSInteger) type complete:(void(^)(void))complete;
- (void)presentReportAlertViewController:(UIViewController *)contentView itemID:(NSString *)itemID type:(NSInteger) type complete:(void(^)(void))complete;
- (void)presentReportAlertViewController:(UIViewController *)contentView publisherId:(NSString *)publisherId complete:(void(^)(void))complete;

@end
