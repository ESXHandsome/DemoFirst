//
//  XLPostViewModel.h
//  NationalRedPacket
//
//  Created by Ying on 2018/7/11.
//  Copyright © 2018 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XLPostAlertViewModelDelegate <NSObject>

- (void)openPhotoLibrary;
- (void)openVideoLibrary;

@end

@interface XLPostAlertViewModel : NSObject

@property (weak, nonatomic) id<XLPostAlertViewModelDelegate> delegate;

- (void)chooseToOpen:(NSString *)sign;

@end

NS_ASSUME_NONNULL_END
