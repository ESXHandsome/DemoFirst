//
//  XLContentOfSelectedView.m
//  NationalRedPacket
//
//  Created by Ying on 2018/4/24.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLContentOfSelectedView.h"
#import "XLEmojiCollectionViewCell.h"
#import "XLEmoji.h"

@interface XLContentOfSelectedView() <UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@property (copy, nonatomic) NSArray *dataArray;
@end

@implementation XLContentOfSelectedView

/*构造方法，初始化UI*/
- (instancetype)init {
    self = [super init];
    if(self){
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    [self addSubview:self.collectionView];
}

#pragma mark -delegate collection
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XLEmojiCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithString:COLORF9F9F9];
    /*让emoji变的大大的*/
    UIFont* emojiFont = [UIFont fontWithName:@"AppleColorEmoji" size:25.0];
    cell.label.font = emojiFont;
    cell.label.text = self.dataArray[0];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [_delegate contentOfSelectedViewDidClicked:[XLEmoji emojis]];
}

#pragma mark -setter方法
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, adaptHeight1334(39*2)) collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor colorWithString:COLORffffff];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"XLEmojiCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout {
    if(!_layout){
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.itemSize = CGSizeMake(adaptWidth750(52*2), self.collectionView.height);
    }
    return _layout;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSArray arrayWithObject:[XLEmoji emojis].firstObject];
    }
    return _dataArray;
}
@end
