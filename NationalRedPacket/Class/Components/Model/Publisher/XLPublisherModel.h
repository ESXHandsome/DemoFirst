//
//  FollowingModel.h
//  NationalRedPacket
//
//  Created by 王海玉 on 2018/1/25.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLPublisherModel : NSObject <NSCopying>

@property (copy, nonatomic) NSString *result;  ///0: 成功，1: 失败， 4：被封禁
@property (copy, nonatomic) NSString *authorId;
@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *icon;
@property (copy, nonatomic) NSString *sex;
@property (copy, nonatomic) NSString *age;
@property (copy, nonatomic) NSString *location;   // 位置
@property (copy, nonatomic) NSString *constellation;   // 星座
@property (copy, nonatomic) NSString *intro;     // 简介
@property (assign, nonatomic) NSInteger fansCount;
@property (assign, nonatomic) NSInteger attentionCount;
//@property (copy, nonatomic) NSString *index;
@property (assign, nonatomic) BOOL isFollowed;
@property (assign, nonatomic) BOOL isNoInfo;

@end
