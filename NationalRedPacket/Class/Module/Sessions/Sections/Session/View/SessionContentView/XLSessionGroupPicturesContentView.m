//
//  XLSessionGroupPicturesContentView.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/6/20.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLSessionGroupPicturesContentView.h"
#import "TTTAttributedLabel.h"
#import "XLGroupBigPictureCell.h"
#import "XLGroupSmallPictureCell.h"
#import "XLGroupPicturesAttachment.h"

@interface XLSessionGroupPicturesContentView () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation XLSessionGroupPicturesContentView

- (instancetype)initSessionMessageContentView {
    if (self = [super initSessionMessageContentView]) {
        
        self.bubbleImageView.hidden = YES;
        
        self.backgroundView = [UIView new];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        self.backgroundView.layer.cornerRadius = 4;
        self.backgroundView.layer.borderWidth = 0.5;
        self.backgroundView.layer.borderColor = [UIColor colorWithString:COLORE6E6E6].CGColor;
        self.backgroundView.layer.masksToBounds = YES;
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XLGroupBigPictureCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XLGroupBigPictureCell class])];
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XLGroupSmallPictureCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XLGroupSmallPictureCell class])];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.scrollEnabled = NO;
        
        [self addSubview:self.backgroundView];
        [self.backgroundView addSubview:self.tableView];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(adaptWidth750(30));
        make.width.mas_equalTo(SCREEN_WIDTH - adaptWidth750(60));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.backgroundView);
    }];
    
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    
    XLGroupPicturesAttachment *attachment = [(NIMCustomObject *)data.message.messageObject attachment];
    self.dataArray = attachment.list;
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        XLGroupBigPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XLGroupBigPictureCell class]) forIndexPath:indexPath];
        [cell configModelData:self.dataArray[indexPath.row] indexPath:indexPath];
        return cell;
    } else {
        XLGroupSmallPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XLGroupSmallPictureCell class]) forIndexPath:indexPath];
        [cell configModelData:self.dataArray[indexPath.row] indexPath:indexPath];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return kBigPictureHeight;
    }
    return kSmallPictureHeight;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NIMKitEvent *event = [[NIMKitEvent alloc] init];
    event.eventName = NIMKitEventNameTapActivityLink;
    event.messageModel = self.model;
    event.data = self.dataArray[indexPath.row];
    [self.delegate onCatchEvent:event];
    
}

@end
