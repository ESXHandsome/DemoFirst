//
//  XLBadgeManager.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/6/4.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLBadgeManager.h"
#import "XLBadgeModel.h"
#import "XLBadgeInfo.h"

#import "XLBadgeRegister.h"
#import "NSObject+XLBadgeHandler.h"
#import "NSString+XLBadgeCount.h"

#define __XLUserDefaults [NSUserDefaults standardUserDefaults]

@interface XLBadgeManager ()

/**
 *  save refresh block
 */
@property (nonatomic, strong) NSMutableDictionary *badgeDictionary;

/**
 *  model for regist
 */
@property (nonatomic, strong) NSMutableDictionary *badgeModelDictionary;

@end

@implementation XLBadgeManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static XLBadgeManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [XLBadgeManager new];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.badgeDictionary = [NSMutableDictionary dictionary];
        self.badgeModelDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)registProfile {
    
    [XLBadgeManager.sharedManager registWithProfile:[XLBadgeRegister registProfiles] defaultShow:NO];
    
    UITabBarController *tabVC = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
  
    if (tabVC.tabBar.items.count >= 3) {
        UITabBarItem *imTabBarItem = tabVC.tabBar.items[2];
        if (@available(iOS 10.0, *)) {
            imTabBarItem.badgeColor = [UIColor colorWithString:COLORFF3E3D];
        }
        
        [self setRedDotKey:XLBadgeIMTabBarKey refreshBlock:^(NSInteger show) {
            imTabBarItem.badgeValue = [NSString badgeCount:show];
        } handler:self];
    }
}

#pragma mark- regist


- (void)registWithProfile:(NSArray *)profile defaultShow:(BOOL)show {
    BOOL save;
    [self.badgeModelDictionary removeAllObjects];
    [self.badgeDictionary removeAllObjects];
    
    [self registWithObject:profile parent:nil defaultShow:show save:&save];
    if (save) [__XLUserDefaults synchronize];
}

- (void)registNodeWithKey:(NSString *)key
                parentKey:(NSString *)parentKey
              defaultShow:(BOOL)show{
    
    if (!key || key.length == 0) return;
        
    id<XLBadgeModelProtocol> model = self.badgeModelDictionary[key];
    if (model) return;
    
    id<XLBadgeModelProtocol> parent = self.badgeModelDictionary[parentKey];
    BOOL save;
    [self fetchOrCreateModelWithKey:key parent:parent defaultShow:show save:&save isLeaf:YES];
    if (save) [__XLUserDefaults synchronize];
    
    [self refreshRedDotTreeForKey:key];
}

- (void)registWithObject:(id)object
                  parent:(id<XLBadgeModelProtocol>)parent
             defaultShow:(BOOL)show
                    save:(BOOL *)save {
    
    if ([object isKindOfClass:[NSArray class]]) {
        for (id subObject in object) {
            [self registWithObject:subObject parent:parent defaultShow:show save:save];
        }
    } else if ([object isKindOfClass:[NSDictionary class]]) {
        for (id key in object) {
            
            id model = [self fetchOrCreateModelWithKey:key parent:parent defaultShow:show save:save isLeaf:NO];
            
            id subObject = object[key];
            [self registWithObject:subObject parent:model defaultShow:show save:save];
        }
    } else if ([object isKindOfClass:[NSString class]]) { //object is key
        
        [self fetchOrCreateModelWithKey:object parent:parent defaultShow:show save:save isLeaf:YES];
    }
}

//regist, fetch by protocol, create by default way
- (id<XLBadgeModelProtocol>)fetchOrCreateModelWithKey:(NSString *)key
                                                parent:(id<XLBadgeModelProtocol>)parent
                                           defaultShow:(BOOL)show
                                                  save:(BOOL *)save
                                                isLeaf:(BOOL)isLeaf {
 
    key = [self formatKey:key];
    // 创建模型，并且根据UserDefault的数据进行初始化
    NSString *showNumStr = [__XLUserDefaults stringForKey:key];
    
    XLBadgeModel *model = [XLBadgeModel new];
    model.key = key;
    
    if (!isLeaf) {
        // 如果不是叶子结点，则不处理，因为父节点的红点取决于子结点的红点
    } else if (showNumStr.length == 0) {
        model.show = @(show);
        [__XLUserDefaults setObject:@"0" forKey:key];
    }   else {
        model.show = @(showNumStr.integerValue);
    }
    
    if (parent && model.parent == nil) {
        model.parent = parent;
        [parent.subDots addObject:model];
    }
    [self.badgeModelDictionary setObject:model forKey:key];
    
    return model;
}

/**
 增加子结点
 */
- (void)addRedDotItem:(XLBadgeInfo *)item forKey:(NSString *)key {
    key = [self formatKey:key];

    [self.badgeDictionary setObject:item forKey:key];
    //add进去后应该自动刷一下当前key的
    [self refreshRedDotForKey:key];
}

/**
 移除指定key的结点
 */
- (void)removeRedDotItemForKey:(NSString *)key {
    key = [self formatKey:key];

    [self.badgeDictionary removeObjectForKey:key];
}

/**
 限定了当前节点“无子节”点才可修改show
 */
- (void)resetBadgeCount:(NSString *)countString forKey:(NSString *)key {
    key = [self formatKey:key];

    id<XLBadgeModelProtocol> model = self.badgeModelDictionary[key];
    if (!model) return;
    if (model.subDots.count > 0) return; //有子节点不可手动改，以子节点为准
    model.show = @(countString.integerValue);
   
    [__XLUserDefaults setObject:countString forKey:key];
    [__XLUserDefaults synchronize];
    
    [self refreshRedDotTreeForKey:key];
}

/**
 改变某key后，从key这个节点刷新相关的，因为限定了只能set最底层，所以往上遍历
 */
- (void)refreshRedDotTreeForKey:(NSString *)key {
    
    id<XLBadgeModelProtocol> model = [self refreshRedDotForKey:key];
    
    model = model.parent;
    if (model) {
        [self refreshRedDotTreeForKey:model.key];
    }
}

/**
 @return 当前刷新的RedDot model对象
 */
- (id<XLBadgeModelProtocol>)refreshRedDotForKey:(NSString *)key {
    id<XLBadgeModelProtocol> model = self.badgeModelDictionary[key];
    if (!model) return nil;

    XLBadgeInfo *info = [self.badgeDictionary objectForKey:key];
        
    NSInteger show = [self checkShowWithModel:model];
    if (show >= 0) {
        !info.refreshBlock ?: info.refreshBlock(show);
    }
    return model;
}

/**
 检查当前节点是否show，有子节点的以子节点为准，没有子节点的，以show为准

 @param model 当前节点model
 @return show or hide
 */
- (NSInteger)checkShowWithModel:(id<XLBadgeModelProtocol>)model {
    if (model.subDots.count > 0) {
        NSInteger showNum = 0;
        
        for (id<XLBadgeModelProtocol> redDot in model.subDots) {
              showNum += redDot.show.integerValue ;
        }
        return showNum;
        
    } else {
        return model.show.integerValue;
    }
    return 0;
}

#pragma mark - Private

- (NSString *)formatKey:(NSString *)key {
    return [NSString stringWithFormat:@"%@_%@",XLLoginManager.shared.userId, key];
}

@end
