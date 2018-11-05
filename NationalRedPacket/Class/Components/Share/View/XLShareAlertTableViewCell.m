//
//  XLShareAlertTableViewCell.m
//  NationalRedPacket
//
//  Created by Ying on 2018/7/2.
//  Copyright © 2018 XLook. All rights reserved.
//

#import "XLShareAlertTableViewCell.h"
#import "XLShareAlertCollectionViewCell.h"
#import "XLShareAlertViewModel.h"

@interface XLShareAlertTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource ,XLShareAlertCollectionViewCellDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *collectionViewFlowLayout;
@property (strong, nonatomic) UILabel *separatorLine;

@end

@implementation XLShareAlertTableViewCell

#pragma mark -
#pragma mark - life cycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, adaptHeight1334(113*2));
        [self configUI];
    }
    return self;
}

- (void)configUI {
    [self addSubview:self.collectionView];
    [self addSubview:self.separatorLine];
    [self.separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(0.5);
        make.left.equalTo(self).mas_offset(adaptWidth750(16*2));
        make.right.equalTo(self).mas_offset(-adaptWidth750(16*2));
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

#pragma mark -
#pragma mark - collection delegate and dataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XLShareAlertCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(XLShareAlertCollectionViewCell.class) forIndexPath:indexPath];
    if ([self.titleArray[indexPath.row] isEqual:@"微信"]) {cell.hasLabel = YES;}
    [cell configCell:GetImage(self.iconArray[indexPath.row]) labelTitle:self.titleArray[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XLShareAlertCollectionViewCell *cell = (XLShareAlertCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickItem:)]) {
        [self.delegate didClickItem:cell];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titleArray.count;
}

#pragma mark -
#pragma mark - Collection Cell Delegate

- (void)didSelectButton:(NSString *)sign {
    NSInteger index = [self.titleArray indexOfObject:sign];
    [self.collectionView.delegate collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
}

#pragma mark -
#pragma mark - lazy load

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:self.collectionViewFlowLayout];
        [_collectionView registerClass:XLShareAlertCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(XLShareAlertCollectionViewCell.class)];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)collectionViewFlowLayout {
    if (!_collectionViewFlowLayout) {
        _collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionViewFlowLayout.itemSize = CGSizeMake(SCREEN_WIDTH/4, adaptHeight1334(113*2));
        _collectionViewFlowLayout.minimumLineSpacing = 0;
        _collectionViewFlowLayout.minimumInteritemSpacing = 0;
        [_collectionViewFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    }
    return _collectionViewFlowLayout;
}

- (UILabel *)separatorLine {
    if (!_separatorLine) {
        _separatorLine = [[UILabel alloc] init];
        _separatorLine.backgroundColor = GetColor(COLORE6E6E6);
    }
    return _separatorLine;
}

@end
