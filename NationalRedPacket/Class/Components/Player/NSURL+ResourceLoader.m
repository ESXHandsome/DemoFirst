//
//  NSURL+ResourceLoader.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/4/12.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "NSURL+ResourceLoader.h"

@implementation NSURL (ResourceLoader)

- (NSURL *)customSchemeURL {
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:self
                                               resolvingAgainstBaseURL:NO];
    components.scheme = @"streaming";
    return [components URL];
}

- (NSURL *)localVideoSchemeURL {
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:self
                                               resolvingAgainstBaseURL:NO];
    components.scheme = @"file";
    return [components URL];
}

- (NSURL *)originalSchemeURL {
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:self
                                               resolvingAgainstBaseURL:NO];
    components.scheme = @"http";
    return [components URL];
}

@end
