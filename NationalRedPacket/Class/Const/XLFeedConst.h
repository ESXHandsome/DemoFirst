//
//  XLFeedConst.h
//  NationalRedPacket
//
//  Created by fensi on 2018/4/19.
//  Copyright © 2018年 XLook. All rights reserved.
//

#ifndef XLFeedConst_h
#define XLFeedConst_h

typedef NS_ENUM(NSInteger, XLFeedCellType) {
    XLFeedCellArticleBigPictureType = 1,        // 大图文章
    XLFeedCellArticleSmallPictureType = 2,      // 小图文章
    XLFeedCellArticleQQCircleType = 3,          // 3图文章
    XLFeedCellVideoVerticalType = 4,            // 无作者信息的竖版视频
    XLFeedCellVideoHorizonalType = 5,           // 横版视频
    XLFeedCellMultiPictureType = 6,             // 图片CELL类型模板
    XLFeedCellVideoVerticalWithAuthorType = 7,  // 有作者信息的竖版视频
    XLFeedCellVideoHorizonalWithAuthorType = 8, // 有作者信息的横版视频
    XLFeedCellADSimplePictureType = 8080,       // 单图广告
    XLFeedCellAdNativeExpressType = 8081,       // 原生模板广告
    XLFeedCellPostViolationType = 1000,         // 帖子违规
};

#endif /* XLFeedConst_h */
