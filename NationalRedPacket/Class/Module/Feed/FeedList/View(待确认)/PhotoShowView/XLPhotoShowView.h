//
//  PPSPhotoShowView.h
//  NationalRedPacket
//  图片预览模块
//  Created by Ying on 2018/2/22.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageCell.h"
#import "BaseNavigationController.h"
#import "HomePopularFeedListViewController.h"
#import "HomeFollowFeedListViewController.h"
#import "XLFeedModel.h"

@protocol PPSPhotoShowViewDelegate <NSObject>

@required
//- (void)currentPage:(NSInteger)currentPage;                         ///检测当前页面位置的回调
- (UIView *)dismissAction:(NSInteger)currentPage;                   ///获取点击消失时的位置
- (void)dismissAtCurrentPage:(NSInteger)currentPage;                ///完全消失之后的回调
@end

@interface XLPhotoShowView : UIView
@property (strong, nonatomic) NSArray   *groupItems;          ///图片数组
@property (assign, nonatomic) NSInteger currentPage;          ///当前状态
@property (assign, nonatomic) BOOL      blurEffectBackground; ///是否需要背景遮罩
@property (weak, nonatomic) id<PPSPhotoShowViewDelegate> delegate;
@property (weak, nonatomic)   UIView    *fromView;            ///起始图片
@property (assign, nonatomic) BOOL      isDetail;             ///是否是详情界面
@property (strong, nonatomic) XLFeedModel *newsModel;
@property (assign, nonatomic) BOOL      isHaveAlertView;      ///弹窗要不要(没有不要的可能, 只能少俩但是我就愿意这么写!)

/* UNAVAILABLE_ATTRIBUTE  ： 方法禁用*/
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithGroupItems:(NSArray *)groupItems;

- (void)viewWillAppear:(BOOL)animated;

- (void)viewDidDisAppear:(BOOL)animated;

/*
 * 弹出图片显示窗口
 * fromView:被选中的图片
 * container:需要被加载到的视图
 */
- (void)presentFromImageView:(UIView *)fromView
                 toContainer:(UIView *)container
                    animated:(BOOL)animated
                  completion:(void (^)(void))completion;

- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion;
- (void)dismiss;


@end
