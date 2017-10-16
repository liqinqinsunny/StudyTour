//
//  TaskDetailModel.h
//  StudyTour
//
//  Created by use on 15/12/14.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

//#import "JSONModel.h"
#import "NSObject+Model.h"

@interface TaskDetailModel : NSObject

@property (nonatomic, assign) NSInteger taskType;
@property (nonatomic, copy) NSString *taskQ;
@property (nonatomic, copy) NSDictionary *taskA;
@property (nonatomic, copy) NSString *taskCorrectA;
@property (nonatomic, copy) NSString *taskAnalysis;
@property (nonatomic, copy) NSString *topicId;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *taskState;

@property (nonatomic, copy) NSString *answer;

@property (nonatomic, assign) NSInteger curA;

- (instancetype)createTaskDetailModel:(NSDictionary *)dict;

@end
