//
//  TabSelectHeaderView.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/8.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CategorySelectHeaderView;

@protocol CategorySelectHeaderViewDelegate <NSObject>

- (void)categorySelectView:(CategorySelectHeaderView *)categorySelectView didSelectCategory:(NSInteger)categoryIndex;

@end

@interface CategorySelectHeaderView : BaseView

- (void)cofigureDelegate:(id<CategorySelectHeaderViewDelegate>)delegate dataArray:(NSMutableArray *)dataArray;

- (void)selectCategoryIndex:(NSInteger)categoryIndex;

@end
