//
//  NewsVisiterViewController.m
//  NationalRedPacket
//
//  Created by Ying on 2018/5/28.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLSessionVisitorViewController.h"
#import "XLSessionBaseTableViewCell.h"
#import "NSDate+SessionHeader.h"

@interface XLSessionVisitorViewController () <XLSessionBaseTableViewCellDelegate>

@end

@implementation XLSessionVisitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"访客";
    [self.sessionListViewModel markOnlyShowRedDotSessionForMessageType:XLMessageVisitor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    XLSessionMessageModel *model = self.viewModel.sessionMessageArray[indexPath.row];
    if (model.name.length > 7) {
        return adaptHeight1334(95*2);
    }
    return adaptHeight1334(78*2);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XLSessionBaseTableViewCell *cell = [tableView xl_dequeueReusableCellWithClass:XLSessionBaseTableViewCell.class forIndexPath:indexPath];
    cell.delegate = self;
    XLSessionMessageModel *model = self.viewModel.sessionMessageArray[indexPath.row];
    cell.authorID = model.uid;
    [cell cellSetImage:model.avatar authorName:model.name tailString:@"访问了您的主页" buttonTitle:model.extra dateLabel:[NSDate changeTimestampToString:model.create_at]];
    if ([self.viewModel authorIdFollowedExtra:model.uid extra:model.extra]) {
        [cell changeButtonState];
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)type {
    return 4;
}

+ (__kindof UIViewController<XLRoutableProtocol> * _Nonnull)xlr_Instance {
    return [self new];
}

#pragma mark -
#pragma mark - XLSessionBaseTableViewCellDelegate

- (void)didSelectFollowButton {
    [self.tableView reloadData];
}
@end
