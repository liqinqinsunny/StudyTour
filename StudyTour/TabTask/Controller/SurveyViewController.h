//
//  SurveyViewController.h
//  StudyTour
//
//  Created by owen on 16/1/16.
//  Copyright © 2016年 魏鹏. All rights reserved.
//

#import "RootViewController.h"

@interface SurveyViewController : RootViewController<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

//数据源
@property(nonatomic,strong)NSArray * dataArray;

//答案
@property(nonatomic,strong)NSMutableArray * anwserArr;

//系列id和名称
@property(nonatomic,strong)NSString * routeCategoryID;
@property(nonatomic,strong)NSString * routeCategoryName;


@property (nonatomic, copy) NSMutableDictionary *submitDictionary;

@end
