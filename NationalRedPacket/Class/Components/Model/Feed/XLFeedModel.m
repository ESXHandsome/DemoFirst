//
//  XLFeedModel.m
//  WatermelonNews
//
//  Created by sunmingyue on 17/11/14.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "XLFeedModel.h"
#import "PPSDAOService.h"
#import "NSString+Height.h"
#import "XLFeedCommentModel.h"

@implementation XLFeedModel

+(NSDictionary *)modelCustomPropertyMapper{
    return @{@"transmissionID":@"id"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"image" : [ImageModel class],
             @"otherAds" : [XLFeedAdNativeExpressModel class],
             @"bestComment" : [XLFeedCommentModel class]
             };
}

- (id)copyWithZone:(NSZone *)zone {
    return [self yy_modelCopy];
}

- (void)setCommentNum:(NSInteger)commentNum {
    _commentNum = commentNum;
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    _createdTime = [NSString stringWithFormat:@"%ld", time(0)];
    
    if ([dic[@"type"] integerValue] == XLFeedCellVideoVerticalWithAuthorType ||
        [dic[@"type"] integerValue] == XLFeedCellVideoHorizonalWithAuthorType) {
        CGFloat height = [NSString heightWithString:dic[@"title"]
                                           fontSize:adaptFontSize(32)
                                        lineSpacing:adaptHeight1334(6)
                                           maxWidth: SCREEN_WIDTH - adaptWidth750(26*2)];
        _isNeedFullButton = height > adaptHeight1334(64*2) ? YES : NO;
        
        BOOL isHorizonVideo = [dic[@"height"] floatValue] / [dic[@"width"] floatValue] <= 1 ? YES : NO;
                
        _type = isHorizonVideo ? [NSString stringWithFormat:@"%ld",(long)XLFeedCellVideoHorizonalWithAuthorType] : [NSString stringWithFormat:@"%ld",XLFeedCellVideoVerticalWithAuthorType];
        
    } else {
        CGFloat height = [NSString heightWithString:dic[@"title"]
                                           fontSize:adaptFontSize(32)
                                        lineSpacing:adaptHeight1334(6)
                                           maxWidth: SCREEN_WIDTH - adaptWidth750(26*2)];
        _isNeedFullButton = height > adaptHeight1334(64*2) ? YES : NO;
    }

    return YES;
}

- (void)setTitle:(NSString *)title {
    _title = title;
}

- (void)setSource:(NSString *)source
{
    if (source.length > 8) {
        _source = [NSString stringWithFormat:@"%@...", [source substringToIndex:8]];
    } else {
        _source = source;
    }
}

+ (NSString *)completeShareURL:(XLFeedModel *)model withRefrence:(NSString *)reference {
    NSString *baseURL = model.share;
    NSString *appVersionNumber = NSBundle.appVersionNumber;
    
    return [NSString stringWithFormat:@"%@&version=%@&reference=%@",baseURL,appVersionNumber,reference];
}

+ (void)updateDataBaseModel:(XLFeedModel *)model
{
    id<PPSHomeFeedDAOProtocol> feedDAO = [[PPSDAOService serviceForUser:XLLoginManager.shared.userId] homeFeedDAO];
    [feedDAO updateModel:[XLFeedModel transformXLFeedModel:model]];
}

#pragma mark - 模型 -> 模型
// XLFeedModel ==》PPSDAOHomeFeedModel
+ (PPSDAOHomeFeedModel *)transformXLFeedModel:(XLFeedModel *)model
{
    PPSDAOHomeFeedModel *ppsModel = [PPSDAOHomeFeedModel new];
    ppsModel.feedId = model.itemId;
    ppsModel.templateType = [model.type integerValue];
    ppsModel.isLiked = model.isPraise;
    ppsModel.isRead = model.isRead;
    ppsModel.commentCount = model.commentNum;
    ppsModel.likedCount = model.praiseNum;
    ppsModel.forwardCount = model.forwardNum;
    ppsModel.publisherId = model.authorId;
    ppsModel.publishTimestamp = [model.releaseTime integerValue];
    ppsModel.createdTimestamp = [model.createdTime integerValue];
    
    NSMutableDictionary *dic = [model yy_modelToJSONObject];
    [dic removeObjectForKey:@"currentTime"];
    [dic removeObjectForKey:@"indexPath"];
    ppsModel.JSON = dic.yy_modelToJSONString;
    
    return ppsModel;
}

// PPSDAOHomeFeedModel ==》XLFeedModel
+ (XLFeedModel *)transformPPSDAOHomeFeedModel:(PPSDAOHomeFeedModel *)model
{
    return [XLFeedModel yy_modelWithJSON:model.JSON];
}

// PPSDAOHomeFeedModelArray ==》XLFeedModelArray
+ (NSMutableArray<PPSDAOHomeFeedModel *> *)transformXLFeedModelArray:(NSMutableArray<XLFeedModel *> *)array
{
    NSMutableArray *feedArray = [NSMutableArray array];
    for (XLFeedModel *newsModel in array) {
        if (newsModel.type.integerValue != XLFeedCellAdNativeExpressType &&
            newsModel.type.integerValue != XLFeedCellADSimplePictureType) {
            PPSDAOHomeFeedModel *model = [XLFeedModel transformXLFeedModel:newsModel];
            [feedArray addObject:model];
        }
    }
    return [[feedArray reverseObjectEnumerator] allObjects].mutableCopy;
}

// PPSDAOHomeFeedModelArray ==》XLFeedModelArray
+ (NSMutableArray<XLFeedModel *> *)transformPPSDAOHomeFeedModelArray:(NSMutableArray<PPSDAOHomeFeedModel *> *)array
{
    NSMutableArray *newsArray = [NSMutableArray array];
    for (PPSDAOHomeFeedModel *model in array) {
        XLFeedModel *newsModel = [XLFeedModel transformPPSDAOHomeFeedModel:model];
        [newsArray addObject:newsModel];
    }
    return [[newsArray reverseObjectEnumerator] allObjects].mutableCopy;
}

@end

@implementation ImageModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSString *value = dic[@"preview"];
    if ([value containsString:@".gif"]) {
        self.previewGif = dic[@"image"];
    }
    return YES;
}

+(NSDictionary *)modelCustomPropertyMapper{
    return @{@"originalImage":@"image"};
}

@end

@implementation AdModel

+(NSDictionary *)modelCustomPropertyMapper{
    return @{@"adId":@"id"};
}

@end
