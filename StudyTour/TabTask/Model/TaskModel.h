//
//  TaskModel.h
//  StudyTour
//
//  Created by use on 15/12/18.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import "JSONModel.h"

@interface TaskModel : JSONModel

@property (nonatomic, copy) NSString *taskId;
@property (nonatomic, copy) NSString *taskState;
@property (nonatomic, copy) NSString *taskTitle;

@end
