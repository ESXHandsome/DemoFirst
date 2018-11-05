//
//  NegativeFeedback.m
//  NationalRedPacket
//
//  Created by Ying on 2018/5/7.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "NegativeFeedbackTableView.h"
#import "NegativeFeedTableViewCell.h"

@interface NegativeFeedbackTableView() <UITableViewDelegate,UITableViewDataSource>
@property (copy, nonatomic) NSArray *dataList;
@end

@implementation NegativeFeedbackTableView

- (instancetype)initWithOrigin:(CGPoint)origin {
    self = [super init];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.frame = CGRectMake(origin.x, origin.y, adaptWidth750(164*2), adaptHeight1334(116*2));
        /*不让丫动*/
        self.scrollEnabled = NO;
        /*不要线*/
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        /*注册一个nib的cell*/
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([NegativeFeedTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
        self.dataList = @[@"不感兴趣",@"重复/过时",@"内容太差"];
    }
    return self;
}

#pragma mark - TableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*固定高度39*/
    return adaptHeight1334(39*2);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*可复用的cell*/
    NegativeFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    /*给cell设置一下标题*/
    [cell.titleLabel setText:self.dataList[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.negativeFeedbackDelegate && [self.negativeFeedbackDelegate respondsToSelector:@selector(NegativeFeedbackTableView:didClickAtIndexPath:)]) {
        [self.negativeFeedbackDelegate NegativeFeedbackTableView:self didClickAtIndexPath:indexPath];
    }
    [self removeFromSuperview];
}

@end
