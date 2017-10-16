//
//  JPDownloadManager.m
//  StudyTour
//
//  Created by use on 16/6/23.
//  Copyright © 2016年 魏鹏. All rights reserved.
//

#import "JPDownloadManager.h"

@implementation JPDownloadManager

+ (instancetype)sharedManager
{
    static JPDownloadManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[JPDownloadManager alloc] initWithBaseURL:nil];
        _sharedManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    
    return _sharedManager;
}


@end
