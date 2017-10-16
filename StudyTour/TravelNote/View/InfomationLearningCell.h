//
//  InfomationLearningCell.h
//  StudyTourLeaderSide
//
//  Created by use on 16/4/20.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJPTaskModel.h"

@interface InfomationLearningCell : UITableViewCell

@property (nonatomic, strong) WJPTaskModel *model;

@property (nonatomic, assign) CGFloat persent;

@property (nonatomic, assign) NSInteger downloadCount;

@property (weak, nonatomic) IBOutlet UIView *cuttingline;

@end
