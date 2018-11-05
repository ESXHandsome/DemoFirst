//
//  XLEmojiKeyboard.m
//  NationalRedPacket
//
//  Created by Ying on 2018/4/23.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLEmojiKeyboard.h"
#import "XLEmoji.h"
#import "XLEmojiCollectionViewCell.h"
#import "XLCollectionViewHorizontalLayout.h"
#import "XLContentOfSelectedView.h"

@interface XLEmojiKeyboard() <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate ,XLContentOfSelectedViewDelegate>
@property (strong, nonatomic) UIPageControl    *pageControlBottom;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (copy,   nonatomic) NSArray          *emojiArray;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@property (strong, nonatomic) XLContentOfSelectedView    *contentOfSelectedView;
@property (strong, nonatomic) UILabel *lineLabel;
@end

@implementation XLEmojiKeyboard

+ (instancetype)keyboard {
    return [self new];
}

#pragma mark - setUpView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        self.height = adaptHeight1334(256*2);
        self.width = SCREEN_WIDTH;
        [self setUpView];
    }
    return self;
}

- (void)setUpView {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControlBottom];
    [self addSubview:self.contentOfSelectedView];
    [self addSubview:self.lineLabel];
    
    [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_offset(0.5);
    }];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(adaptHeight1334(219*2));
    }];
    [_pageControlBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self->_collectionView.mas_bottom);
        make.height.mas_equalTo(adaptHeight1334(39*2));
    }];
    [_contentOfSelectedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_collectionView.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    [self addCancelButtonInCollectionView];
}

- (void)addCancelButtonInCollectionView{
    for (int i = 0 ; i<self.emojiArray.count/20+1 ; i++) {
        UIImageView *cancelButton = [[UIImageView alloc] init];
        CGRect frame = CGRectMake(adaptWidth750(313.21*2) + (i*SCREEN_WIDTH), adaptHeight1334(133.59*2), adaptWidth750(50*2), adaptHeight1334(56*2));
        UIImage *image = [UIImage imageNamed:@"emoji_delete"];
        cancelButton.x = frame.origin.x + 10;
        cancelButton.y = frame.origin.y + 15;
        cancelButton.size = image.size;
        cancelButton.image = image;
        [self.collectionView addSubview:cancelButton];
        cancelButton.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelButtonAction)];
        [cancelButton addGestureRecognizer:tapGesturRecognizer];
    }
}

#pragma mark - IBActions/Event Response
- (void)cancelButtonAction {
    if ([_delegate respondsToSelector:@selector(emojiKeyboardDidClickedBackspace)]) {
        [_delegate emojiKeyboardDidClickedBackspace];
    }
}

#pragma mark - lazyLoad
- (UICollectionView *)collectionView {
    if(!_collectionView){
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(adaptWidth750(11.5*2), adaptHeight1334(12*2), SCREEN_WIDTH-adaptWidth750(23*2), adaptHeight1334(142*2)) collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"XLEmojiCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MyCollectionViewCell"];
    }
    return _collectionView;
}

- (NSArray *)emojiArray {
    if (!_emojiArray) {
        _emojiArray = [XLEmoji emojis];
    }
    return _emojiArray;
}

- (UILabel *)lineLabel {
    if(!_lineLabel) {
        _lineLabel = [[UILabel alloc] init];
        _lineLabel.backgroundColor = [UIColor colorWithString:COLORE6E6E6];
    }
    return _lineLabel;
}

- (UIPageControl *)pageControlBottom{
    if (!_pageControlBottom){
        _pageControlBottom = [UIPageControl new];
        _pageControlBottom.numberOfPages = self.emojiArray.count/20+1;
        _pageControlBottom.pageIndicatorTintColor = [UIColor colorWithString:COLORD8D8D8];
        _pageControlBottom.currentPageIndicatorTintColor = [UIColor colorWithString:COLOR000000];
    }
    return _pageControlBottom;
}

- (UICollectionViewFlowLayout *)layout {
    if(!_layout){
        _layout = [[XLCollectionViewHorizontalLayout alloc] init];
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.itemSize = CGSizeMake(self.collectionView.width/7, self.collectionView.height/2.5);
    }
    return _layout;
}

- (UIView *)contentOfSelectedView {
    if (!_contentOfSelectedView) {
        _contentOfSelectedView = [[XLContentOfSelectedView alloc] init];
        _contentOfSelectedView.delegate = self;
    }
    return _contentOfSelectedView;
}

#pragma mark - collectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (((self.emojiArray.count/20)+(self.emojiArray.count%20==0?0:1))!=section+1) {
        return 20;
    }else{
        return  self.emojiArray.count-20*(( self.emojiArray.count/20)+( self.emojiArray.count%20==0?0:1)-1);
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return (self.emojiArray.count/20)+(self.emojiArray.count%20==0?0:1);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XLEmojiCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCollectionViewCell" forIndexPath:indexPath];
    cell.label.text = self.emojiArray[indexPath.section*20+indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString * showString = self.emojiArray[indexPath.section*20+indexPath.row];
    if ([_delegate respondsToSelector:@selector(emojiKeyboard:didClickedEmoji:)]) {
        [_delegate emojiKeyboard:self didClickedEmoji:showString];
    }
}

#pragma mark - ScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contenOffset = scrollView.contentOffset.x;
    int page = contenOffset/scrollView.frame.size.width+((int)contenOffset%(int)scrollView.frame.size.width==0?0:1);
    self.pageControlBottom.currentPage = page;
    
}

#pragma mark - ContentViewDelegate
- (void)contentOfSelectedViewDidClicked:(NSArray *)itemArray {
    self.emojiArray = itemArray;
    [self.collectionView reloadData];
    self.pageControlBottom.numberOfPages = self.emojiArray.count/20+1;
}

@end
