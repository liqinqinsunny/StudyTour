//
//  TaskDetailModel.m
//  StudyTour
//
//  Created by use on 15/12/14.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import "TaskDetailModel.h"

@implementation TaskDetailModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
//    NSLog(@"%@---%@", key, value);
}

- (instancetype)createTaskDetailModel:(NSDictionary *)dict
{
    return [self initWithDict:dict];
}

@end
