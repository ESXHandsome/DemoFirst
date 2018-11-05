//
//  PublisherTopicsCell.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/10.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "PublisherTopicsCell.h"
#import "PublisherCardCell.h"
#import "XLPublisherDataSource.h"

@interface PublisherTopicsCell () <UICollectionViewDelegate, UICollectionViewDataSource, XLDataSourceDelegate>

@property (strong, nonatomic) UILabel          *titleLabel;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) XLPublisherDataSource *dataSource;

@property (strong, nonatomic) id               tempDelegateObject;


@end

@implementation PublisherTopicsCell

- (void)setupViews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.collectionView];
    
    self.titleLabel = [UILabel labWithText:@"推荐账号" fontSize:adaptFontSize(34) textColorString:COLOR3B424C];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:adaptFontSize(34)];
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(adaptWidth750(50));
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(adaptWidth750(50));
        make.right.equalTo(self.contentView).offset(-adaptWidth750(50));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(-adaptHeight1334(20));
        make.bottom.equalTo(self.contentView);
    }];
}

#pragma mark - XLDataSourceDelegate

- (void)dataSource:(XLDataSource *)dataSource didChangedForIndex:(NSInteger)index {
    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
}

#pragma mark - CollectionViewDelegateAndDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.elements.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PublisherCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PublisherCardCellID" forIndexPath:indexPath];
    cell.delegate = self.tempDelegateObject;
    [cell configModelData:self.dataSource.elements[indexPath.row] indexPath:indexPath];
    [cell changeSubviewsLayout];
    if (indexPath.row % 3 == 2) {
        UIView *lineView = [UIView new];
        lineView.frame = CGRectMake(0, cell.height * (indexPath.row + 1)/3, SCREEN_WIDTH, 1);
        lineView.backgroundColor = [UIColor colorWithString:COLORF0F3F5];
        if (indexPath.row != self.dataSource.elements.count - 1) {
            [self.collectionView addSubview:lineView];
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PublisherCardCell *cell = (PublisherCardCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.delegate && [cell.delegate respondsToSelector:@selector(didSelectPublisherCell:publisherModel:)]) {
        [cell.delegate didSelectPublisherCell:cell publisherModel:self.dataSource.elements[indexPath.row]];
    }
}

- (void)configDelegateObject:(id)delegateObject
{
    self.tempDelegateObject = delegateObject;
}

- (void)configModelData:(BannerModel *)model indexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource == nil) {
        self.dataSource = [[XLPublisherDataSource alloc] init];
        self.dataSource.delegate = self;
    }
    [self.dataSource setElementsFromArray:model.authorList];
    [self.collectionView reloadData];
}

/**
 根据数据源计算高度
 
 @param dataArray 数据源
 @return cell高度
 */
+ (CGFloat)getTopicsCellHeightWithDataArray:(NSArray *)dataArray
{
    NSInteger sectionCount = dataArray.count % 3 == 0 ? dataArray.count / 3.0 : dataArray.count / 3.0 + 1;
    return sectionCount * (adaptHeight1334(212*2)) + adaptHeight1334(24);
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(adaptWidth750(98*2), adaptHeight1334(212*2));
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PublisherCardCell class]) bundle:nil] forCellWithReuseIdentifier:@"PublisherCardCellID"];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.scrollEnabled = NO;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

@end
