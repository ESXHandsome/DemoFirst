//
//  ImagesWithAuthorCell.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/2/22.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "BaseFeedAuthorCell.h"
#import "ContainerImageView.h"

@interface FeedImagesCell : BaseFeedAuthorCell

@property (strong, nonatomic) ContainerImageView *containerView;
@property (assign, nonatomic) BOOL isDetail;
@property (assign, nonatomic) NSInteger playPlace;
@property (strong, nonatomic) XLFeedModel *tempModel;

- (void)updateDetailInfo;

@end
