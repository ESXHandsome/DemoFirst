//
//  PPSSavePhoto.m
//  NationalRedPacket
//
//  Created by Ying on 2018/2/26.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "PPSSavePhoto.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "FLAnimatedImage.h"

@implementation PPSSavePhoto
#pragma mark - 保存图片到自定义相册
/**
 * 获得自定义的相册对象
 */
- (PHAssetCollection *)collection:(NSString*)albumName
{
    self.albumName = albumName;
    // 先从已存在相册中找到自定义相册对象
    PHFetchResult<PHAssetCollection *> *collectionResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in collectionResult) {
        if ([collection.localizedTitle isEqualToString:_albumName]) {
            return collection;
        }
    }
    
    // 新建自定义相册
    __block NSString *collectionId = nil;
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        collectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:self.albumName].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    
    if (error) {
        XLLog(@"获取相册【%@】失败", _albumName);
        return nil;
    }
    
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[collectionId] options:nil].lastObject;
}

/**
 * 保存图片到相册
 */
- (IBAction)saveImage:(UIImage*)image albumName:(NSString *)albumName{
    // 判断授权状态
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status != PHAuthorizationStatusAuthorized) return;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = nil;
            
            // 保存相片
            __block PHObjectPlaceholder *createdAsset = nil;
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                createdAsset = [PHAssetCreationRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset;
            } error:&error];
            
            if (error) {
               [MBProgressHUD showError:@"保存失败"];
                return;
            }
            
            // 拿到自定义的相册对象
            PHAssetCollection *collection = [self collection:albumName];
            if (collection == nil) return;
            
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                [[PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection] insertAssets:@[createdAsset] atIndexes:[NSIndexSet indexSetWithIndex:0]];
            } error:&error];
            
            if (error) {
               [MBProgressHUD showError:@"保存失败"];
            } else {
                [MBProgressHUD showError:@"保存成功"];
            }
        });
    }];
}

/**
 存储GIF图片到相册
 
 @param fileURL GIF URL
 @param albumName 相册名称
 */
- (void)saveGIFImageWithFileURL:(NSURL *)fileURL albumName:(NSString *)albumName {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:fileURL];
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary writeImageDataToSavedPhotosAlbum:data
                                               metadata:nil
                                        completionBlock:^(NSURL *assetURL, NSError *error) {
                                            if (error) {
                                                [MBProgressHUD showError:@"保存失败"];
                                                return;
                                            }
                                            [self saveToAlbumName:albumName withAssetsLibrary:assetsLibrary withAssetURL:assetURL];
                                        }];
    });
}


/**
 将图片存储到自定义的相册对象
 */
- (void)saveToAlbumName:(NSString *)albumName
      withAssetsLibrary:(ALAssetsLibrary *)assetsLibrary
           withAssetURL:(NSURL *)assetURL {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 先枚举所有的相册组
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupLibrary usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            
            // 如果已经有这个相册
            if ([albumName compare: [group valueForProperty:ALAssetsGroupPropertyName]] == NSOrderedSame) {
                [self addAssetWithURL:assetURL withAssetsGroup:group toAssetsLibrary:assetsLibrary];
            } else {
                // 创建相册
                __weak ALAssetsLibrary *weakLibrary = assetsLibrary;
                [weakLibrary addAssetsGroupAlbumWithName:albumName resultBlock:^(ALAssetsGroup *newGroup) {
                    [self addAssetWithURL:assetURL withAssetsGroup:newGroup toAssetsLibrary:assetsLibrary];
                } failureBlock:^(NSError *error) {
                    [MBProgressHUD showError:@"保存失败"];
                }];
            }
        } failureBlock:^(NSError *error) {
            [MBProgressHUD showError:@"保存失败"];
        }];
    });
}

/**
 保存到相册
 */
- (void)addAssetWithURL:(NSURL *)assetURL
        withAssetsGroup:(ALAssetsGroup *)assetsGroup
        toAssetsLibrary:(ALAssetsLibrary *)assetsLibrary {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            [assetsGroup addAsset:asset];
            [MBProgressHUD showError:@"保存成功"];
        } failureBlock:^(NSError *error) {
            [MBProgressHUD showError:@"保存失败"];
        }];
    });
}
 
@end
