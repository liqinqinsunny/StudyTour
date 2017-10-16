//
//  TaskDetailView.h
//  StudyTour
//
//  Created by use on 15/12/14.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TaskDetailModel;

@interface TaskDetailView : UIView

@property (nonatomic, copy) NSString *position;//第几题
@property (nonatomic, strong) TaskDetailModel *model;
@property (nonatomic, copy) NSString *taskId;


@property (nonatomic, copy) void(^taskStateBlock)();

@property (nonatomic, copy) void(^taskClickedBlock)(CGFloat h);

@end
