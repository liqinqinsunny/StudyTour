//
//  TableViewCell.h
//  StudyTour
//
//  Created by use on 15/12/2.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskModel.h"

@interface TableViewCell : UITableViewCell

@property (nonatomic, assign) TaskModel *model;

@end
