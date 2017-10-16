//
//  JPDownloadManager.h
//  StudyTour
//
//  Created by use on 16/6/23.
//  Copyright © 2016年 魏鹏. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface JPDownloadManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

@end
