//
//  ExchangeTypeCell.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/22.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "ExchangeTypeCell.h"
#import "ExchangeOptionCell.h"
#import "OptionModel.h"

#define kCellSpec   adaptWidth750(18)
#define kCellHeight (adaptHeight1334(120))
#define kCellWidth  adaptWidth750(220)

@interface ExchangeTypeCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UILabel          *typeLabel;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSIndexPath      *tempIndexPath;

@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@property (strong, nonatomic) OptionModel      *tempModel;

@end

@implementation ExchangeTypeCell

- (void)setupViews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.typeLabel = [UILabel labWithText:@"" fontSize:adaptFontSize(32) textColorString:COLOR333333];
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.collectionView];
    
    [self my_layoutSubviews];
}

- (void)my_layoutSubviews
{
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(adaptWidth750(26));
        make.top.equalTo(self.contentView).offset(adaptHeight1334(32));
        
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeLabel);
        make.top.equalTo(self.typeLabel.mas_bottom).offset(adaptHeight1334(22));
        make.right.equalTo(self.contentView).offset(-adaptWidth750(26));
        make.height.mas_equalTo(kCellHeight);
        make.bottom.equalTo(self.contentView);
    }];
}

- (void)configModelData:(OptionModel *)model indexPath:(NSIndexPath *)indexPath
{
    self.tempModel = model;
    
    //测试使用
//    OptionListModel *newModel = [OptionListModel new];
//    newModel.exchangeMode = model.exchangeMode;
//    newModel.money = @"50";
//    newModel.available = @"0";
//    self.tempModel.modeList = @[newModel, newModel, newModel, newModel, newModel];
    
    if ([model.exchangeMode isEqualToString:@"TELEPHONE"]) {
        self.typeLabel.text = @"话费";
    } else if ([model.exchangeMode isEqualToString:@"ALIPAY_NATIVE"]){
        self.typeLabel.text = @"支付宝";
    }
    
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.tempModel.modeList.count % 3 != 0) {
            make.height.mas_equalTo(kCellHeight * (self.tempModel.modeList.count / 3 + 1) + kCellSpec * (self.tempModel.modeList.count / 3));
        } else {
            make.height.mas_equalTo(kCellHeight * (self.tempModel.modeList.count / 3) + kCellSpec * (self.tempModel.modeList.count / 3 - 1));
        }
    }];
    
    [self.collectionView reloadData];
}

#pragma mark - CollectionViewDelegateAndDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tempModel.modeList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ExchangeOptionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ExchangeOptionCellID forIndexPath:indexPath];
    OptionListModel *model = self.tempModel.modeList[indexPath.row];
    model.exchangeMode = self.tempModel.exchangeMode;
    [cell configOptionModel:model indexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    OptionListModel *model = self.tempModel.modeList[indexPath.row];

    if (model.available.integerValue == 0) {
        [MBProgressHUD showError:@"暂时没有库存了，试试其他额度吧！"];
        return;
    }
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didSelectExchangeOptionWithModel:)]) {
        [self.delegate didSelectExchangeOptionWithModel:model];
    }
}

//当cell高亮时返回是否高亮
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    OptionListModel *model = self.tempModel.modeList[indexPath.row];
    if (model.available.integerValue == 0) {
        return;
    }
    ExchangeOptionCell *cell = (ExchangeOptionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setOptionCellHighlight:YES];
}

- (void)collectionView:(UICollectionView *)collectionView  didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    OptionListModel *model = self.tempModel.modeList[indexPath.row];
    if (model.available.integerValue == 0) {
        return;
    }
    ExchangeOptionCell *cell = (ExchangeOptionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setOptionCellHighlight:NO];
}

#pragma mark - Lazy Loading

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        self.layout = [[UICollectionViewFlowLayout alloc] init];
        self.layout.minimumLineSpacing = kCellSpec;
        self.layout.minimumInteritemSpacing = kCellSpec;
        self.layout.itemSize = CGSizeMake(kCellWidth, kCellHeight);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        [_collectionView registerClass:[ExchangeOptionCell class] forCellWithReuseIdentifier:ExchangeOptionCellID];
        _collectionView.scrollEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

@end
