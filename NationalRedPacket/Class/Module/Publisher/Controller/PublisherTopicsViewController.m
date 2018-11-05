//
//  PublisherTopicsViewController.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/10.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "PublisherTopicsViewController.h"
#import "BannerImageCell.h"
#import "TopicsIntroductionCell.h"
#import "PublisherTopicsCell.h"
#import "PublisherCardCell.h"
#import "PublisherViewModel.h"
#import "PublisherViewController.h"
#import "UIImage+ImageEffects.h"

#define kPersionalHeight adaptHeight1334(195*2)

@interface PublisherTopicsViewController () <PublisherCellDelegate>

@property (strong, nonatomic) BannerImageCell    *headerView;
@property (strong, nonatomic) PublisherViewModel *viewModel;
@property (assign, nonatomic) NSInteger          tempNumber;
@property (strong, nonatomic) UIImage            *resultImage;
@end

@implementation PublisherTopicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configTableView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:self.model.imageUrl];
        self.resultImage = [image applyBlurWithRadius:6 tintColor:nil  saturationDeltaFactor:1.8 maskImage:nil];
    });
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

/**
 配置TableView
 */
- (void)configTableView
{
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TopicsIntroductionCell class]) bundle:nil] forCellReuseIdentifier:@"TopicsIntroductionCellID"];
    [self.tableView registerClass:[PublisherTopicsCell class] forCellReuseIdentifier:PublisherTopicsCellID];
    self.tableView.contentInset = UIEdgeInsetsMake(kPersionalHeight, 0, 0, 0);
    self.headerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([BannerImageCell class]) owner:nil options:nil].firstObject;
    self.headerView.frame = CGRectMake(0, -kPersionalHeight, SCREEN_WIDTH, kPersionalHeight);
    self.headerView.bannerImageView.layer.cornerRadius = 0; //去除圆角效果
    self.headerView.layer.masksToBounds = YES; //去除阴影效果
    [self.headerView.bannerImageView sd_setImageWithURL:[NSURL URLWithString:self.model.imageUrl]];
    [self.tableView addSubview:self.headerView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [((UIButton *)[self.navigationItem.leftBarButtonItem customView]) setImage:[UIImage imageNamed:@"video_nav_back"] forState:UIControlStateNormal];
    
    [self.navigationController.navigationBar  setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self navigationBarAppear];
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat offsetH = kPersionalHeight + offsetY;
    if (offsetH < kPersionalHeight - NAVIGATION_BAR_HEIGHT) {
        self.headerView.height = kPersionalHeight - offsetH; //高度变化
        self.headerView.y = -kPersionalHeight + offsetH;     //Y值变化
    } else {
        self.headerView.height = NAVIGATION_BAR_HEIGHT;
        self.headerView.y = offsetY;
    }
}

/**
 NavigationBar渐变效果
 */
- (void)navigationBarAppear
{
    CGFloat contentOffset = self.tableView.contentOffset.y;
    if ((contentOffset + kPersionalHeight) > (kPersionalHeight - NAVIGATION_BAR_HEIGHT)) {
        if (self.title.length != 0) {
            return;
        }
        self.title = self.model.title;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor blackColor] colorWithAlphaComponent:0.2] size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
        self.headerView.bannerImageView.image = self.resultImage;
        
    } else if ((contentOffset + kPersionalHeight) <= 0){
        self.title = @"";
        self.headerView.bannerImageView.image = [[SDImageCache sharedImageCache] imageFromCacheForKey:self.model.imageUrl];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    } else {
        self.title = @"";
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        
        CGFloat blur = (contentOffset + kPersionalHeight)/(kPersionalHeight - NAVIGATION_BAR_HEIGHT)*10;
        if (fmod(blur,1) >= 0.1) { //避免多次调用，导致创建大量子线程，导致崩溃
            return;
        }
        if (blur > 6) {
            blur = 6;
        }
        UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:self.model.imageUrl];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *resultImage = [image applyBlurWithRadius:blur tintColor:nil  saturationDeltaFactor:1.8 maskImage:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.headerView.bannerImageView.image = resultImage;
            });
        });
    }
}

#pragma mark - PublisherCellDelegate
- (void)didSelectPublisherCell:(PublisherCardCell *)publisherCell publisherModel:(XLPublisherModel *)model
{
    PublisherViewController *publisherVC = [PublisherViewController new];
    publisherVC.model = model;
    [StatServiceApi statEvent:PERSONPAGE_CLICK model:model];
    if (publisherCell) {
        [publisherVC setPersonalHomepageControllerWillDisplayBlock:^{
            [publisherCell updateFollowInfo];
        }];
    }
    [self.navigationController pushViewController:publisherVC animated:YES];
}

- (void)didSelectPublisherCellFollowButton:(PublisherCardCell *)publisherCell publisherModel:(XLPublisherModel *)model
{
    [self.viewModel followPublisherWithModel:model success:^(BOOL isToFollow) {
        [StatServiceApi statEvent:FOLLOW_CLICK model:model otherString:@"card"];
        if (isToFollow) {
            [MBProgressHUD showSuccess:@"关注成功"];
        } else {
            [MBProgressHUD showSuccess:@"取消关注"];
        }
        [publisherCell updateFollowInfo];
    } failure:^(NSInteger errorCode) {
        [MBProgressHUD showSuccess:@"关注失败"];
        [publisherCell updateFollowInfo];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        TopicsIntroductionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopicsIntroductionCellID" forIndexPath:indexPath];
            cell.introductionLabel.text = self.model.intro;
        [self setLabelSpec:cell.introductionLabel];
        return cell;
    } else {
        PublisherTopicsCell *cell = [tableView dequeueReusableCellWithIdentifier:PublisherTopicsCellID forIndexPath:indexPath];
        [cell configDelegateObject:self];
        [cell configModelData:self.model indexPath:indexPath];
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return [self.tableView fd_heightForCellWithIdentifier:@"TopicsIntroductionCellID" configuration:^(TopicsIntroductionCell *cell) {
            cell.introductionLabel.text = self.model.intro;
            [self setLabelSpec:cell.introductionLabel];
        }]+1;
    }
    return [PublisherTopicsCell getTopicsCellHeightWithDataArray:self.model.authorList];
}

- (PublisherViewModel *)viewModel
{
    if (!_viewModel) {
        self.viewModel = [PublisherViewModel new];
    }
    return _viewModel;
}

- (void)setLabelSpec:(UILabel *)label
{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:label.text attributes:nil];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:adaptHeight1334(6)];//行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, label.text.length)];
    label.attributedText = attributedString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
