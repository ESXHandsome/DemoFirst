//
//  XLAppletsTableViewCell.m
//  NationalRedPacket
//
//  Created by Ying on 2018/6/21.
//  Copyright © 2018 XLook. All rights reserved.
//

#import "XLAppletsView.h"
#import "XLAppletsCollectionViewCell.h"
#import "XLAppletsModel.h"

@interface XLAppletsView() <UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *collection;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@property (copy, nonatomic) NSArray *itemArray;
@end

@implementation XLAppletsView

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.collection];
    UIImageView *bottomLine = [UIImageView new];
    [self addSubview:bottomLine];
    bottomLine.backgroundColor = [UIColor colorWithString:COLORE6E6E6];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(adaptHeight1334(1));
    }];
}

- (void)congifCell:(NSArray *)array {
    self.itemArray = array;
}

#pragma mark -
#pragma mark - collection date souce
// 告诉系统一共多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 告诉系统每组多少个
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemArray.count;
}

// 告诉系统每个Cell如何显示
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XLAppletsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    XLAppletsModel *model = self.itemArray[indexPath.row];
    [cell congifAppletsView:model.image titleLabel:model.text floatLabel:model.tips useMask:[model.useMask boolValue]];
    [StatServiceApi statEvent:TOP_H5_LOOK model:nil otherString:model.ID];
    return cell;
}

#pragma mark -
#pragma mark - collection delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectItemToPushWebView:)]) {
        XLAppletsModel *model = self.itemArray[indexPath.row];
        [self.delegate didSelectItemToPushWebView:model.url];
        [StatServiceApi statEvent:TOP_H5_CLICK model:nil otherString:model.ID];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
    
}

#pragma mark -
#pragma mark - lazy load

- (UICollectionView *)collection {
    if (!_collection) {
        _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, adaptHeight1334(109*2))
                                         collectionViewLayout:self.layout];
        _collection.delegate = self;
        _collection.dataSource = self;
        _collection.backgroundColor = [UIColor colorWithString:COLORFCFCFC];
        [_collection registerClass:XLAppletsCollectionViewCell.class forCellWithReuseIdentifier:@"cell"];
        _collection.showsHorizontalScrollIndicator = NO;
    }
    return _collection;
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        NSInteger margin = adaptWidth750(13*2);
        _layout.minimumInteritemSpacing = margin;
        _layout.itemSize = CGSizeMake(adaptWidth750(76*2), adaptHeight1334(76*2));
        _layout.sectionInset = UIEdgeInsetsMake(adaptHeight1334(16*2), adaptWidth750(16*2), adaptHeight1334(16*2), adaptWidth750(16*2));
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}

@end
