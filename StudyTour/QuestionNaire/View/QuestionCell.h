//
//  QuestionCell.h
//  StudyTour
//
//  Created by lqq on 16/6/17.
//  Copyright © 2016年 lqq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QuestionCellFrame;

@interface QuestionCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong) QuestionCellFrame *cellFrame;

@property(nonatomic,copy) NSMutableDictionary *questionDict;

@property(nonatomic,copy) NSString *questionText;
@property(nonatomic,copy) NSDictionary *questDict;

@property(nonatomic,assign) NSInteger rowIndex;

@end