//
//  XLDataSource.m
//  NationalRedPacket
//
//  Created by fensi on 2018/4/13.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLDataSource.h"
#import "XLDataSourceManager.h"

@interface XLDataSource ()

@property (strong, nonatomic) NSMutableArray *elements;

@end

@implementation XLDataSource

#pragma mark - Initialize

+ (instancetype)dataSourceWithArray:(NSArray *)array {
    return [[self alloc] initWithArray:array];
}

- (instancetype)initWithArray:(NSArray *)array {
    XLDataSource *instance = [self init];
    // 做为值传递，避免二级页面修改对象，导致一级页面对象发生变化
    instance.elements = [[NSMutableArray alloc] initWithArray:array copyItems:YES];
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _elements = [NSMutableArray arrayWithCapacity:0];
        [XLDataSourceManager.shared addObserver:self];
    }
    return self;
}

#pragma mark - Mutable

- (void)addElementsFromArray:(NSArray *)otherArray {
    [_elements addObjectsFromArray:[[NSArray alloc] initWithArray:otherArray copyItems:YES]];
    
}

- (void)setElementsFromArray:(NSArray *)otherArray {
    _elements = [[NSMutableArray alloc] initWithArray:otherArray copyItems:YES];
}

- (void)removeElementAtIndex:(NSUInteger)index {
    [_elements removeObjectAtIndex:index];
}

#pragma mark - Subclass

- (void)enumerateElementsChangeUsingBlock:(BOOL(^)(id obj, NSUInteger idx, BOOL * stop))block {
    
    @weakify(self);
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
        @strongify(self);
        
        [self.elements enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!block(obj, idx, stop)) {
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
                if (self.delegate && [self.delegate respondsToSelector:@selector(dataSource:didChangedForIndex:)]) {
                    [self.delegate dataSource:self didChangedForIndex:idx];
                }
            });
        }];
    });
}

@end
