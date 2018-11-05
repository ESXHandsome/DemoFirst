//
//  Emojis.m
//  LYInputView
//
//  Created by Ying on 2018/4/23.
//  Copyright © 2018年 Ying. All rights reserved.
//

#import "XLEmoji.h"

@implementation XLEmoji
+ (NSArray *)emojis{
    static NSDictionary *emojis = nil;
    static NSArray *emojisArray = nil;
    if (!emojis){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"json"];
        NSData *emojiData = [[NSData alloc] initWithContentsOfFile:path];
        emojis = [NSJSONSerialization JSONObjectWithData:emojiData options:NSJSONReadingAllowFragments error:nil];
    }
    if (emojis[@"emoji"]) {
        emojisArray = emojis[@"emoji"];
    }
    
    return emojisArray;
}
@end
