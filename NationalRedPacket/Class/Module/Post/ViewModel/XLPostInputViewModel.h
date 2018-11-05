//
//  XLPostInputViewModel.h
//  NationalRedPacket
//
//  Created by Ying on 2018/7/12.
//  Copyright © 2018 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol XLPostInputViewModelDelegate <NSObject>

- (void)showMyUploadViewController;

@end

@interface XLPostInputViewModel : NSObject

@property (weak, nonatomic) id<XLPostInputViewModelDelegate> delegate;

- (void)uploadPicture:(UIImage *)image url:(NSURL *)url item:(NSString *)item;
- (void)uploadVideo:(UIImage *)image url:(NSURL *)url title:(NSString*)title size:(NSInteger)size ;
@end

NS_ASSUME_NONNULL_END
