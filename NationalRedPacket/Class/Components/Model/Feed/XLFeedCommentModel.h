//
//  XLFeedCommentModel.h
//  NationalRedPacket
//
//  Created by 王海玉 on 2017/11/16.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLFeedCommentModel : NSObject

@property (copy, nonatomic) NSString *commentId;
@property (copy, nonatomic) NSString *fromName; 
@property (copy, nonatomic) NSString *fromIcon;
@property (assign, nonatomic) BOOL   bestComment;
@property (copy, nonatomic) NSString *fromAuthorId;
@property (copy, nonatomic) NSString *toName;
@property (copy, nonatomic) NSString *toIcon;
@property (copy, nonatomic) NSString *toAuthorId;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *createdAt;
@property (copy, nonatomic) NSString *hundredContent;
@property (copy, nonatomic) NSString *upNum;
@property (assign, nonatomic) BOOL   isPraise;
@property (assign, nonatomic) BOOL   isMyComment;
@property (strong, nonatomic) NSArray<ImageModel *> *images;
@property (assign, nonatomic) NSInteger secondaryCommentTotalCount;
@property (strong, nonatomic) NSArray<XLFeedCommentModel *> *secondaryComments;

@end
