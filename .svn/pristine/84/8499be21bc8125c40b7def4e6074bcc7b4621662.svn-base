//
//  CheckQuestionController.h
//  StudyTour
//
//  Created by owen on 15/12/11.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "QuestionView.h"

@interface CheckQuestionController : RootViewController<UIScrollViewDelegate>

@property(nonatomic,strong)QuestionView * views;

@property(nonatomic,strong)NSMutableArray * viewArr;

//数据源
@property(nonatomic,strong)NSArray * questions;

//当前索引
@property(nonatomic, assign) NSInteger pageIndex;

//滚动层
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;

@property (strong, nonatomic) IBOutlet UIButton *upTitleBtn;

@property (strong, nonatomic) IBOutlet UIButton *nextTitleBtn;

- (IBAction)upBtnAction:(UIButton *)sender;

- (IBAction)nextBtnAction:(UIButton *)sender;




//数据记录
//@property(nonatomic,strong)NSMutableDictionary * dataDic;

//设置翻页按钮状态  是否激活
-(void)setTurnButtonState;

//设置翻页
-(void)setTurnPage : (CGPoint)pageIndex;

@end
