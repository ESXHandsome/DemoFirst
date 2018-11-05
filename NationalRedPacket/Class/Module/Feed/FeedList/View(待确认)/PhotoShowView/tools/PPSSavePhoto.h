//
//  PPSSavePhoto.h
//  NationalRedPacket
//
//  Created by Ying on 2018/2/26.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface PPSSavePhoto : NSObject

@property (copy, nonatomic) NSString *albumName;

- (IBAction)saveImage:(UIImage*)image albumName:(NSString *)albumName;
- (void)saveGIFImageWithFileURL:(NSURL *)fileURL albumName:(NSString *)albumName;

@end
