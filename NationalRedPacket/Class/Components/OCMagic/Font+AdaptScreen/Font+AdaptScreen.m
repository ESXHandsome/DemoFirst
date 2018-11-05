//
//  Font+AdaptScreen.m
//  NationalRedPacket
//
//  Created by Ying on 2018/4/4.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "Font+AdaptScreen.h"
#import <objc/runtime.h>

@implementation UIButton (MyFont)

+ (void)load {
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    method_exchangeImplementations(imp, myImp);
}

- (id)myInitWithCoder:(NSCoder*)aDecode {
    [self myInitWithCoder:aDecode];
    if (self) {
        //部分不想改变字体的 把tag值设置成333跳过
        if(self.titleLabel.tag != 333){
            CGFloat fontSize = self.titleLabel.font.pointSize;
            self.titleLabel.font = [self.titleLabel.font fontWithSize:kFontSize(fontSize)];
        }
    }
    return self;
}
@end

@implementation UILabel (MyFont)

+ (void)load {
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    method_exchangeImplementations(imp, myImp);
}

- (id)myInitWithCoder:(NSCoder*)aDecode {
    [self myInitWithCoder:aDecode];
    if (self) {
        //部分不想改变字体的 把tag值设置成333跳过
        if(self.tag != 333){
            CGFloat fontSize = self.font.pointSize;
            self.font = [self.font fontWithSize:kFontSize(fontSize)];
        }
    }
    return self;
}
@end

@implementation UITextField (MyFont)

+ (void)load {
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    method_exchangeImplementations(imp, myImp);
}

- (id)myInitWithCoder:(NSCoder*)aDecode {
    [self myInitWithCoder:aDecode];
    if (self) {
        //部分不想改变字体的 把tag值设置成333跳过
        if(self.tag != 333){
            CGFloat fontSize = self.font.pointSize;
            self.font = [self.font fontWithSize:kFontSize(fontSize)];
        }
    }
    return self;
}
@end

@implementation UITextView (MyFont)

+ (void)load {
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    method_exchangeImplementations(imp, myImp);
}
- (id)myInitWithCoder:(NSCoder*)aDecode {
    [self myInitWithCoder:aDecode];
    if (self) {
        //部分不想改变字体的 把tag值设置成333跳过
        if(self.tag != 333){
            CGFloat fontSize = self.font.pointSize;
            self.font = [self.font fontWithSize:kFontSize(fontSize)];
        }
    }
    return self;
}

@end
