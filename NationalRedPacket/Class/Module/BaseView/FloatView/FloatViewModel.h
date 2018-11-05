//
//  FloatViewModel.h
//  NationalRedPacket
//
//  Created by Ying on 2018/1/26.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FloatViewModel : NSObject

@property (copy, nonatomic)   NSString  *ID;
@property (assign, nonatomic) BOOL      allPage;
@property (copy, nonatomic)   NSArray   *page;
@property (assign, nonatomic) NSInteger appear;
@property (assign, nonatomic) NSInteger disappear;
@property (copy, nonatomic)   NSString  *repeat;
@property (copy, nonatomic)   NSString  *appearAnim;
@property (copy, nonatomic)   NSString  *disappearAnim;
@property (copy, nonatomic)   NSString  *picUrl;
@property (copy, nonatomic)   NSString  *position;
@property (assign, nonatomic) NSInteger width;
@property (assign, nonatomic) NSInteger height;
@property (assign, nonatomic) NSInteger marginVertical;
@property (assign, nonatomic) NSInteger marginHorizontal;
@property (assign, nonatomic) BOOL      mask;           ///是否有遮罩
@property (assign, nonatomic) BOOL      maskClose;      ///点击遮罩关闭
@property (assign, nonatomic) BOOL      showClose;      ///是否展示关闭按钮
@property (copy, nonatomic)   NSString  *closePosition; ///关闭按钮的位置
@property (copy, nonatomic)   NSString  *closePic;      ///关闭按钮的位置
@property (copy, nonatomic)   NSString  *url;           ///点击事件跳转链接
@property (assign, nonatomic) BOOL      *clickNotice;   ///点击后是否上报

@property (copy, nonatomic)   NSString *type;           ///类型:pop弹窗  sus悬浮窗
@property (assign, nonatomic) NSInteger closeMargin;    /// 悬浮窗下关闭按钮距离图片的距离
@property (assign, nonatomic) NSInteger showCount;      ///展示次数 -1为永久显示

@end
