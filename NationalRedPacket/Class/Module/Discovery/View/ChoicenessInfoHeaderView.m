//
//  ChoicenessInfoHeaderView.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/8.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "ChoicenessInfoHeaderView.h"
#import "PublisherCardCell.h"

#define kChoicenessViewHeight adaptHeight1334(498*2)

@interface ChoicenessInfoHeaderView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) CycleBannerView  *cycleBannerView;
@property (strong, nonatomic) UILabel          *likeLabel;
@property (strong, nonatomic) UILabel          *moreLabel;

@property (strong, nonatomic) id               delegateObject;

@end

@implementation ChoicenessInfoHeaderView

- (void)setupViews
{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, kChoicenessViewHeight);
    
    self.cycleBannerView = [CycleBannerView new];
    [self addSubview:self.cycleBannerView];
    
    self.likeLabel = [UILabel labWithText:@"猜你喜欢" fontSize:adaptFontSize(17*2) textColorString:COLOR282828];
    [self addSubview:self.likeLabel];
    
    [self addSubview:self.collectionView];
    
    self.moreLabel = [UILabel labWithText:@"发现更多" fontSize:adaptFontSize(17*2) textColorString:COLOR282828];
    [self addSubview:self.moreLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.cycleBannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(adaptHeight1334(2)-adaptHeight1334(30));
        make.height.mas_equalTo(kBannerHeight);
    }];
    
    [self.likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(adaptWidth750(36));
        make.top.equalTo(self.cycleBannerView.mas_bottom);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.likeLabel.mas_bottom).offset(adaptHeight1334(17*2));
        make.height.mas_equalTo(adaptHeight1334(178*2));
    }];
    
    [self.moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.likeLabel);
        make.top.equalTo(self.collectionView.mas_bottom).offset(adaptHeight1334(27*2));
    }];
    
}

#pragma mark - Public Methods
- (void)setBannerDataArray:(NSMutableArray *)bannerDataArray
{
    _bannerDataArray = bannerDataArray;
    [self.cycleBannerView configDataArray:bannerDataArray];
}

- (void)setPublisherCardArray:(NSMutableArray *)publisherCardArray
{
    _publisherCardArray = publisherCardArray;
    [self.collectionView reloadData];
}

- (void)configDelegate:(id)delegateObject;
{
    self.delegateObject = delegateObject;
    self.cycleBannerView.delegate = delegateObject;
}

- (void)setBannerTimerStart:(BOOL)isStart
{
    self.cycleBannerView.pagerView.autoScrollInterval = isStart ? 5.0 : 0;
}

#pragma mark - CollectionViewDelegateAndDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.publisherCardArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PublisherCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PublisherCardCellID" forIndexPath:indexPath];
    cell.delegate = self.delegateObject;
    [cell configModelData:self.publisherCardArray[indexPath.row] indexPath:indexPath];
    NSLog(@"%ld", indexPath.row);
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PublisherCardCell *cell = (PublisherCardCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.delegate && [cell.delegate respondsToSelector:@selector(didSelectPublisherCell:publisherModel:)]) {
        [cell.delegate didSelectPublisherCell:cell publisherModel:self.publisherCardArray[indexPath.row]];
    }
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = adaptWidth750(22);
        layout.minimumInteritemSpacing = adaptWidth750(22);
        layout.itemSize = CGSizeMake(adaptWidth750(133*2), adaptHeight1334(178*2));
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0, adaptWidth750(18*2), 0, adaptWidth750(18*2));
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PublisherCardCell class]) bundle:nil] forCellWithReuseIdentifier:@"PublisherCardCellID"];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

@end
