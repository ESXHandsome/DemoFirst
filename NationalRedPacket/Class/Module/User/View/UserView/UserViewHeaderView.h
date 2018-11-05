//
//  UserViewHeaderView.h
//  NationalRedPacket
//
//  Created by Ying on 2018/5/29.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    UserViewHeaderViewNone,
    UserViewHeaderViewHasRedPackage
} UserViewHeaderViewType;

@protocol HeaderViewDelegate <NSObject>

- (void)didClickTimingRedPacketEvent;
- (void)headViewTimingRedPacketShowStateChanged:(BOOL)available;

@end

@interface UserViewHeaderView : UITableViewCell

@property (weak, nonatomic) id<HeaderViewDelegate> delegate;

- (instancetype)initWithRedType:(UserViewHeaderViewType)type;

- (void)userHeaderView:(NSString *)imageUrlString authorName:(NSString *)authorName invitedCode:(NSString *)invitedCode;

/**
 更新定时红包装填
 
 @param isAvailable 定时红包是否可用
 @param countDown 定时红包倒计时时间戳
 @param availableTime 开抢时间
 */
- (void)updateTimingRedPacketAvailable:(BOOL)isAvailable
                         withCountDown:(long)countDown
                     withAvailableTime:(NSString *)availableTime;

@end
