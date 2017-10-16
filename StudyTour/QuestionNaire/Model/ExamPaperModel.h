//
//  ExamPaperModel.h
//  StudyTour
//
//  Created by lqq on 16/6/21.
//  Copyright © 2016年 lqq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExamPaperModel : NSObject

@property(nonatomic,copy) NSString *ExamPaperHeadDesc;
@property(nonatomic,copy) NSString *ExamPaperID;
@property(nonatomic,copy) NSString *ExamPaperEndDesc;
@property(nonatomic,copy) NSString *ExamPaperName;
@property(nonatomic,strong) NSArray *QuestionList;

@end
