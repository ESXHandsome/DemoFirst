//
//  XLCityPickerViewModel.m
//  NationalRedPacket
//
//  Created by Ying on 2018/7/27.
//  Copyright © 2018 XLook. All rights reserved.
//

#import "XLCityPickerViewModel.h"

@implementation XLPickerItem
- (void) loadData:(NSInteger)count config:(void(^)(XLPickerItem *item, NSInteger index)) config {
    if (count <= 0) {
        NSLog(@"至少需要一个数据源！");
        return;
    }
    
    NSMutableArray *temps = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        XLPickerItem *city = [[XLPickerItem alloc]init];
        if (config) {
            config(city, i);
        }
        
        [temps addObject:city];
    }
    
    self.datas = [NSArray arrayWithArray:temps];
}

@end

@implementation XLCityPickerViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadData];
    }
    return self;
}

- (void)loadData {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Address" ofType:@"plist"];
    
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:path];
    
    NSArray *provinces = [dic allKeys];
    
    for (NSString *tmp in provinces) {
        
        // 创建第一级数据
        XLPickerItem *item1 = [[XLPickerItem alloc]init];
        item1.name = tmp;
        
        NSArray *arr = [dic objectForKey:tmp];
        NSDictionary *cityDic = [arr firstObject];
        
        NSArray *keys = cityDic.allKeys;
        // 配置第二级数据
        [item1 loadData:keys.count config:^(XLPickerItem *item, NSInteger index) {
            
            item.name = keys[index];
        
        }];
        
        [self.dataSource addObject:item1];
    }
}


- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataSource;
}

@end
