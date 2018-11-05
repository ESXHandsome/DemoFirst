//
//  NIMSessionLayout.m
//  NIMKit
//
//  Created by chris on 2016/11/8.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import "NIMSessionLayoutImpl.h"
#import "UITableView+NIMScrollToBottom.h"
#import "NIMMessageCell.h"
#import "NIMGlobalMacro.h"
#import "NIMSessionTableAdapter.h"
#import "UIView+NIM.h"
#import "NIMKitKeyboardInfo.h"

@interface NIMSessionLayoutImpl()
{
    NSMutableArray *_inserts;
    CGFloat _inputViewHeight;
}

@property (nonatomic,strong)  NIMSession  *session;

@property (nonatomic,strong)  id<NIMSessionConfig> sessionConfig;

@property (nonatomic,weak)    id<NIMSessionLayoutDelegate> delegate;

@end

@implementation NIMSessionLayoutImpl

- (instancetype)initWithSession:(NIMSession *)session
                         config:(id<NIMSessionConfig>)sessionConfig
{
    self = [super init];
    if (self) {
        _sessionConfig = sessionConfig;
        _session       = session;
        _inserts       = [[NSMutableArray alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidHide:) name:UIMenuControllerDidHideMenuNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:NIMKitKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)setTableView:(UITableView *)tableView
{
    BOOL change = _tableView != tableView;
    if (change)
    {
        _tableView = tableView;
        [self setupRefreshControl];
    }
}





- (void)adjustInputView
{
    UIView *superView = self.inputView.superview;
    UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *))
    {
        safeAreaInsets = superView.safeAreaInsets;
    }
    self.inputView.nim_bottom = superView.nim_height - safeAreaInsets.bottom;
}

- (void)adjustTableView
{
    //输入框是否弹起
    BOOL inputViewUp = NO;
    switch (self.inputView.status)
    {
        case NIMInputStatusText:
            inputViewUp = [NIMKitKeyboardInfo instance].isVisiable;
            break;
        case NIMInputStatusAudio:
            inputViewUp = NO;
            break;
        case NIMInputStatusMore:
        case NIMInputStatusEmoticon:
            inputViewUp = YES;
        default:
            break;
    }
    self.tableView.userInteractionEnabled = !inputViewUp;
    CGRect rect = self.tableView.frame;
    
    //tableview 的位置
    UIView *superView = self.tableView.superview;
    UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *))
    {
        safeAreaInsets = superView.safeAreaInsets;
    }
    
    CGFloat containerSafeHeight = self.tableView.superview.frame.size.height - safeAreaInsets.bottom;
    
    rect.size.height = containerSafeHeight - self.inputView.toolBar.nim_height;
    
    
    //tableview 的内容 inset
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    CGFloat visiableHeight = 0;
    if (@available(iOS 11.0, *))
    {
        contentInsets = self.tableView.adjustedContentInset;
    }
    else
    {
        contentInsets = self.tableView.contentInset;
    }
    [self.tableView reloadData];
    
    //如果气泡过少，少于总高度，输入框视图需要顶到最后一个气泡的下面。
    visiableHeight = visiableHeight + self.tableView.contentSize.height + contentInsets.top + contentInsets.bottom;
    visiableHeight = MIN(visiableHeight, rect.size.height);
    
    
    
    rect.origin.y    = containerSafeHeight - visiableHeight - self.inputView.nim_height;
    rect.origin.y    = rect.origin.y > 0? 0 : rect.origin.y;
    
    
    BOOL tableChanged = !CGRectEqualToRect(self.tableView.frame, rect);
    if (tableChanged)
    {
        [self.tableView setFrame:rect];
        [self.tableView nim_scrollToBottom:YES];
    }
}

#pragma mark - Notification
- (void)menuDidHide:(NSNotification *)notification {
    [UIMenuController sharedMenuController].menuItems = nil;
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    if (!self.tableView.window) {
        //如果当前视图不是顶部视图，则不需要监听
        return;
    }
    [self.inputView sizeToFit];
}

#pragma mark - Private

- (void)setupRefreshControl {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing:)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.arrowView.image = [UIImage imageNamed:@"dynamic_delete_loading"];
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;
}

- (void)headerRereshing:(id)sender {
    if ([self.delegate respondsToSelector:@selector(onRefresh)]) {
        [self.delegate onRefresh];
    }
}

#pragma mark -
#pragma mark NIMSessionLayout Implementation

- (void)update:(NSIndexPath *)indexPath {
    NIMMessageCell *cell = (NIMMessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        CGFloat scrollOffsetY = self.tableView.contentOffset.y;
        [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, scrollOffsetY) animated:NO];
    }
}

- (void)insert:(NSArray<NSIndexPath *> *)indexPaths animated:(BOOL)animated {
    if (!indexPaths.count)
    {
        return;
    }
    
    NSMutableArray *addIndexPathes = [NSMutableArray array];
    [indexPaths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[obj integerValue] inSection:0];
        [addIndexPathes addObject:indexPath];
    }];
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:addIndexPathes withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
    
    if (self.tableView.contentSize.height < self.tableView.height) {
        [UIView animateWithDuration:0.25 delay:0 options:7 animations:^{
            [self resetLayout];
        } completion:nil];
    } else {
        if (self.tableView.mj_offsetY + self.tableView.height * 1.5 > self.tableView.contentSize.height) {
            [self.tableView nim_scrollToBottom:YES];
        }
    }
    
}

- (void)remove:(NSArray<NSIndexPath *> *)indexPaths {
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

- (BOOL)canInsertChatroomMessages {
    return !self.tableView.isDecelerating && !self.tableView.isDragging;
}

- (void)calculateContent:(NIMMessageModel *)model {
    [model contentSize:self.tableView.nim_width];
}

- (void)reloadTable {
    [self.tableView reloadData];
}

- (void)resetLayout {
    [self adjustInputView];
    [self adjustTableView];
}

- (void)changeLayout:(CGFloat)inputViewHeight {
    BOOL change = _inputViewHeight != inputViewHeight;
    if (change)
    {
        _inputViewHeight = inputViewHeight;
        [self adjustInputView];
        [self adjustTableView];
    }
}

- (void)setDelegate:(id<NIMSessionLayoutDelegate>)delegate {
    _delegate = delegate;
}

- (void)layoutAfterRefresh {
    [self.tableView.mj_header endRefreshing];
    
    CGFloat tempheight = self.tableView.contentSize.height;
    [self.tableView reloadData];
    //保证tableview刷新后不自动滚动到顶部
    if (self.tableView.contentSize.height - tempheight - self.tableView.mj_header.height != 0) {
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - tempheight - self.tableView.mj_header.height*2 - 10)];
    }
}

- (void)adjustOffset:(NSInteger)row {
    
}

@end
