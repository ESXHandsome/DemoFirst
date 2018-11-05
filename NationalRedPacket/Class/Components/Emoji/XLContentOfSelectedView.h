//
//  XLContentOfSelectedView.h
//  NationalRedPacket
//
//  Created by Ying on 2018/4/24.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XLContentOfSelectedViewDelegate <NSObject>

/**
 调用emoji的途径
 展示需要展示的emoji列表，进行展示

 @param itemArray 传入需要展示的emoji的数组
 */
- (void)contentOfSelectedViewDidClicked:(NSArray *)itemArray;
@end

@interface XLContentOfSelectedView : UIView
@property (weak, nonatomic) id<XLContentOfSelectedViewDelegate> delegate;
@end
