//
//  WJPTaskModel.h
//  StudyTourLeaderSide
//
//  Created by use on 16/4/26.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJPTaskModel : NSObject <NSCoding>

@property (nonatomic, copy) NSString *taskId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *hide;
@property (nonatomic, copy) NSString *downloadCount;
// 1,附件下载任务     2,游学任务（暂时没有）      3, 外链任务       4,问卷调查      5，答题
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *accessory;
@property (nonatomic, copy) NSString *taskCount;
@property (nonatomic, copy) NSString *link;

@property (nonatomic, assign) BOOL noCustomBackgroundColor;
@property (nonatomic, assign) BOOL noCustomContentColor;

+ (id)createWJPTaskModelWithDict:(NSDictionary *)dict;

+ (id)createEmptyWJPTaskModel;
@end
