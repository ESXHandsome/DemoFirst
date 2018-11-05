//
//  DAOServiceTest.m
//  NationalRedPacketTests
//
//  Created by 张子琦 on 30/01/2018.
//  Copyright © 2018 孙明悦. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PPSDAOService.h"

@interface DAOServiceTest : XCTestCase

@end

@implementation DAOServiceTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testHomeFeedDAO {
    id<PPSHomeFeedDAOProtocol> homeFeedDAO = [[PPSDAOService serviceForUser:@"123123"] homeFeedDAO];
    
    PPSDAOHomeFeedModel *homeFeedModel1 = [PPSDAOHomeFeedModel new];
    homeFeedModel1.feedId = @"feed_id1";
    homeFeedModel1.templateType = 1;
    homeFeedModel1.isLiked = YES;
    homeFeedModel1.isRead = NO;
    homeFeedModel1.commentCount = 10000000;
    homeFeedModel1.likedCount = 10000000;
    homeFeedModel1.forwardCount = 10000000;
    homeFeedModel1.JSON = @"{raw json}";
    homeFeedModel1.publisherId = @"abcd";
    homeFeedModel1.publishTimestamp = 1517294894245;
    homeFeedModel1.createdTimestamp = 1517294894123;
    
    [homeFeedDAO insertModel:homeFeedModel1];
    
    PPSDAOHomeFeedModel *homeFeedModel2 = [PPSDAOHomeFeedModel new];
    homeFeedModel2.feedId = @"feed_id2";
    homeFeedModel2.templateType = 2;
    homeFeedModel2.isLiked = YES;
    homeFeedModel2.isRead = NO;
    homeFeedModel2.commentCount = 10000000;
    homeFeedModel2.likedCount = 10000000;
    homeFeedModel2.forwardCount = 10000000;
    homeFeedModel2.JSON = @"{raw json}";
    homeFeedModel2.publisherId = @"abcd";
    homeFeedModel2.publishTimestamp = 1517294894245;
    homeFeedModel2.createdTimestamp = 1517294894123;
    
    [homeFeedDAO insertModel:homeFeedModel2];
    
    PPSDAOHomeFeedModel *homeFeedModel3 = [PPSDAOHomeFeedModel new];
    homeFeedModel3.feedId = @"feed_id3";
    homeFeedModel3.templateType = 3;
    homeFeedModel3.isLiked = YES;
    homeFeedModel3.isRead = NO;
    homeFeedModel3.commentCount = 10000000;
    homeFeedModel3.likedCount = 10000000;
    homeFeedModel3.forwardCount = 10000000;
    homeFeedModel3.JSON = @"{raw json}";
    homeFeedModel3.publisherId = @"abcd";
    homeFeedModel3.publishTimestamp = 1517294894245;
    homeFeedModel3.createdTimestamp = 1517294894123;
    
    [homeFeedDAO insertModel:homeFeedModel3];
    
    NSArray *models = @[homeFeedModel1, homeFeedModel2, homeFeedModel3];
    
    [homeFeedDAO insertModels:models];
    
    NSInteger count = [homeFeedDAO totalCountForRow];
    
    models = [homeFeedDAO queryModelsFrom:2 offset:3];
    
    PPSDAOHomeFeedModel *model = models[0];
    
    models = [homeFeedDAO queryModelsFrom:2 offset:300];
    
    models = [homeFeedDAO queryModelsFrom:200 offset:3];
    
    model.feedId = @"id+++";
    model.templateType = 10;
    model.isLiked = NO;
    model.isRead = YES;
    model.commentCount = 1;
    model.likedCount = 2;
    model.forwardCount = 3;
    model.JSON = @"{raw json 22222}";
    
    [homeFeedDAO updateModel:model];
    
    [homeFeedDAO deleteModelsFromHead:1];
    
    [homeFeedDAO deleteAllModels];
}

- (void)testPublisherDAO {
    id<PPSPublisherDAOProtocol> publisherDAO = [[PPSDAOService serviceForUser:@"123123"] publisherDAO];
    
    [publisherDAO deleteAllModels];
    
    PPSDAOPublisherModel *publisherModel1 = [PPSDAOPublisherModel new];
    publisherModel1.publisherId = @"a";
    publisherModel1.nickname = @"aa";
    publisherModel1.gender = MALE;
    publisherModel1.age = 18;
    publisherModel1.location = @"bj";
    publisherModel1.bio = @"bio1";
    publisherModel1.constellation = @"aaa";
    publisherModel1.followerCount = 11111;
    publisherModel1.followingCount = 11111;
    publisherModel1.isFollowing = NO;
    
    PPSDAOPublisherModel *publisherModel2 = [PPSDAOPublisherModel new];
    publisherModel2.publisherId = @"b";
    publisherModel2.nickname = @"bb";
    publisherModel2.gender = FEMALE;
    publisherModel2.age = 20;
    publisherModel2.location = @"uz";
    publisherModel2.bio = @"bio2";
    publisherModel2.constellation = @"bbb";
    publisherModel2.followerCount = 22;
    publisherModel2.followingCount = 22222;
    publisherModel2.isFollowing = NO;
    
    PPSDAOPublisherModel *publisherModel3 = [PPSDAOPublisherModel new];
    publisherModel3.publisherId = @"c";
    publisherModel3.nickname = @"cc";
    publisherModel3.gender = MALE;
    publisherModel3.age = 28;
    publisherModel3.location = @"uy";
    publisherModel3.bio = @"bio3";
    publisherModel3.constellation = @"ccc";
    publisherModel3.followerCount = 11111111;
    publisherModel3.followingCount = 1111231;
    publisherModel3.isFollowing = NO;
    
    [publisherDAO insertModel:publisherModel1];
    [publisherDAO insertModel:publisherModel2];
    [publisherDAO insertModel:publisherModel3];
    
    PPSDAOPublisherModel *model = [publisherDAO queryModelWithId:@"a"];
    
    model.nickname = @"dd";
    model.gender = FEMALE;
    model.age = 70;
    model.location = @"ll";
    model.bio = @"asdasd";
    model.constellation = @"bebeb";
    model.followingCount = 123;
    model.isFollowing = YES;
    model.followerCount = model.followerCount + 1;
    
    [publisherDAO updateModel:model];
    
    model = [publisherDAO queryModelWithId:@"a"];
    
    NSArray *models = [publisherDAO queryModelsWithIds:@[@"b", @"c"]];
    
    [publisherDAO deleteModels:@[model, publisherModel3]];
    
}

@end
