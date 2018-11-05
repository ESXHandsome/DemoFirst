//
//  NewsFansViewController.m
//  NationalRedPacket
//
//  Created by Ying on 2018/5/28.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLSessionFansViewController.h"
#import "XLSessionBaseTableViewCell.h"
#import "NSDate+SessionHeader.h"

@interface XLSessionFansViewController ()

@end

@implementation XLSessionFansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"粉丝";
    
    [self.sessionListViewModel markOnlyShowRedDotSessionForMessageType:XLMessageFans];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    XLSessionMessageModel *model = self.viewModel.sessionMessageArray[indexPath.row];
    if (model.name.length > 10) {
        return adaptHeight1334(95*2);
    }
    return adaptHeight1334(78*2);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XLSessionBaseTableViewCell *cell = [tableView xl_dequeueReusableCellWithClass:XLSessionBaseTableViewCell.class forIndexPath:indexPath];
    XLSessionMessageModel *model = self.viewModel.sessionMessageArray[indexPath.row];
    cell.authorID = model.uid;
    [cell cellSetImage:model.avatar authorName:model.name tailString:@"关注了你" buttonTitle:model.extra dateLabel:[NSDate changeTimestampToString:model.create_at]];
    if ([self.viewModel authorIdFollowedExtra:model.uid extra:model.extra]) {
        [cell changeButtonState];
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)type {
    return 1;
}

+ (__kindof UIViewController<XLRoutableProtocol> * _Nonnull)xlr_Instance {
    return [self new];
}
@end
