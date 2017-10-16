//
//  WJPLinkTaskCell.h
//  StudyTourLeaderSide
//
//  Created by use on 16/4/26.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJPTaskModel.h"

@interface WJPLinkTaskCell : UITableViewCell

@property (nonatomic, strong) WJPTaskModel *model;
@property (weak, nonatomic) IBOutlet UIView *cuttingline;

@end
