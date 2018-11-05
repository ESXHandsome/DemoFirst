//
//  XLPostInputViewModel.m
//  NationalRedPacket
//
//  Created by Ying on 2018/7/12.
//  Copyright © 2018 XLook. All rights reserved.
//

#import "XLPostInputViewModel.h"
#import "AliyunOSSApi.h"
#import "XLPublishApi.h"
#import "XLPosrPhotoTools.h"

@implementation XLPostInputViewModel

- (void)uploadPicture:(UIImage *)image url:(NSURL *)url item:(NSString *)item {
    MBProgressHUD *HUD = [MBProgressHUD showChrysanthemum:@"上传中..."];
    HUD.offset = CGPointMake(0, -50);
    @weakify(self);
    [[AliyunOSSApi alloc] uploadObjectAsyncWithImage:image imageFileURL:url success:^(id responseDict) {
        CGFloat size = [XLPosrPhotoTools getImageFileSizeWithURL:url];
        NSDictionary *personItemInfo = @{@"type":@"image",
                                         @"item":responseDict[@"image"],
                                         @"height":responseDict[@"height"],
                                         @"width":responseDict[@"width"],
                                         @"duration":@"",
                                         @"size":[NSString stringWithFormat:@"%f",size],
                                         @"cover":@"",
                                         @"title":item,
                                         };
        [XLPublishApi uploadPersonItem:personItemInfo success:^(id responseDict) {
            [HUD hideAnimated:NO];
            if ([responseDict[@"result"] integerValue] != 0) {
                [MBProgressHUD showError:@"你输入的内容含有违规内容，请编辑后重新发送"];
                return;
            }
            [MBProgressHUD showSuccess:@"上传成功\n\n您发布的内容将会被管理员审\n核，审核通过后即有机会展示\n给其他用户\n" icon:@"icon_success" time:8];
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(showMyUploadViewController)]) {
                [self.delegate showMyUploadViewController];
            }
        } failure:^(NSInteger errorCode) {
            [HUD hideAnimated:NO];
            [MBProgressHUD showError:@"上传失败"];
        }];
    } failure:^(NSInteger errorCode) {
        [HUD hideAnimated:NO];
        [MBProgressHUD showError:@"上传失败"];
    }];
}

- (void)uploadVideo:(UIImage *)image url:(NSURL *)url title:(NSString*)title size:(NSInteger)size {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KeyWindow animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.detailsLabel.text = @"上传视频";
    hud.detailsLabel.font = [UIFont systemFontOfSize:adaptFontSize(30)];
    hud.detailsLabel.textColor = [UIColor colorWithString:COLORffffff];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.6];
    hud.bezelView.layer.cornerRadius = adaptFontSize(8);
    hud.margin = adaptWidth750(25);
    
    @weakify(self);
    [[AliyunOSSApi alloc] uploadObjectAsyncWithVideoFileURL:url firstImage:image success:^(id responseDict) {
        NSDictionary *videoInfo = [XLPosrPhotoTools getVideoInfoWithSourcePath:url];
        NSDictionary *personItemInfo = @{@"type":@"video",
                                         @"item":responseDict[@"item"],
                                         @"height":responseDict[@"height"],
                                         @"width":responseDict[@"width"],
                                         @"duration":videoInfo[@"duration"],
                                         @"size":[NSNumber numberWithInteger:size],
                                         @"cover":responseDict[@"cover"],
                                         @"title":title,
                                         };
        [XLPublishApi uploadPersonItem:personItemInfo success:^(id responseDict) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
            });
            if ([responseDict[@"result"] integerValue] != 0) {
                [MBProgressHUD showError:@"你输入的内容含有违规内容，请编辑后重新发送"];
                return;
            }
            [MBProgressHUD showSuccess:@"上传成功\n\n您发布的内容将会被管理员审\n核，审核通过后即有机会展示\n给其他用户\n" icon:@"icon_success" time:8];
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(showMyUploadViewController)]) {
                [self.delegate showMyUploadViewController];
            }
        } failure:^(NSInteger errorCode) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
            });
            [MBProgressHUD showError:@"上传失败"];
        }];
    }  progress:^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        
        if (totalByteSent/totalBytesExpectedToSend >=  1) {

        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                hud.progress = (float)totalByteSent/(float)totalBytesExpectedToSend;
            });
        }
      
    }  failure:^(NSInteger errorCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
        [MBProgressHUD showError:@"上传失败"];
    }];
}
@end
