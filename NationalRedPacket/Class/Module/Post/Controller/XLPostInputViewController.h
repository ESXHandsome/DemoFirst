//
//  XLPostInputViewController.h
//  NationalRedPacket
//
//  Created by Ying on 2018/7/12.
//  Copyright © 2018 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XLPostInputViewControllerDelegate <NSObject>

- (void)dissmissInputView;

@end

@interface XLPostInputViewController : UIViewController
@property (weak, nonatomic) id<XLPostInputViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSURL *url;
@property (assign, nonatomic) BOOL isImage;
@property (assign, nonatomic) NSInteger size;
@end

NS_ASSUME_NONNULL_END
