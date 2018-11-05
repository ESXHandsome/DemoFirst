//
//  XLCityPickerViewModel.h
//  NationalRedPacket
//
//  Created by Ying on 2018/7/27.
//  Copyright © 2018 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLPickerItem : NSObject

@property (nonatomic, copy) NSString* name;
@property (nonatomic, assign) id obj;
@property (nonatomic, copy) NSArray<XLPickerItem *> *datas;

@end

@interface XLCityPickerViewModel : NSObject
@property (copy, nonatomic) NSArray *items;
@property (strong, nonatomic) NSMutableArray <XLPickerItem *>*dataSource;
@end
