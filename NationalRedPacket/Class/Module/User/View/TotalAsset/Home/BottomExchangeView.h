//
//  BottomChangeView.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/20.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "BaseView.h"
#import "TotalAssetProtocol.h"

@interface BottomExchangeView : BaseView

@property (weak, nonatomic) id<TotalAssetProtocol>delegate;

@end
