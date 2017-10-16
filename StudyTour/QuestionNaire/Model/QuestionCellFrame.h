//
//  QuestionCellFrame.h
//  StudyTour
//
//  Created by lqq on 16/6/21.
//  Copyright © 2016年 lqq. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QuestionModel;

@interface QuestionCellFrame : NSObject

@property(nonatomic,strong) QuestionModel *model;

@property(nonatomic,assign) CGRect titleFrame;

@property(nonatomic,assign) CGRect viewFrame;

@property(nonatomic,assign) CGRect separateViewFrame;

@property(nonatomic,assign) CGRect textFieldFrame;


@property(nonatomic,assign) CGFloat rowHeight;

@end
