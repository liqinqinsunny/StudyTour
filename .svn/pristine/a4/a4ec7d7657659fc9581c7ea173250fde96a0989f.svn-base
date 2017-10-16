//
//  QuestionView.h
//  StudyTour
//
//  Created by owen on 15/12/10.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Questions.h"

@interface QuestionView : UIView<UIAlertViewDelegate>
//属性
@property (strong, nonatomic) IBOutlet UILabel *titleIndex;

@property (strong, nonatomic) IBOutlet UILabel *titleNum;

@property (strong, nonatomic) IBOutlet UILabel *titleCon;

@property (strong, nonatomic) IBOutlet UILabel *explainCon;

@property (strong, nonatomic) IBOutlet UIView *explainView;


@property (strong, nonatomic) IBOutlet UIButton *rightBtn;

@property (strong, nonatomic) IBOutlet UIButton *errorBtn;

@property(nonatomic,assign)NSInteger rightIndex;
@property(nonatomic,assign)NSInteger curIndex;


//按钮事件
- (IBAction)rightBtn:(id)sender;

- (IBAction)errorBtn:(id)sender;


-(id)initWithFrame:(CGRect)frame Obbject:(id)obj;

//加载数据
-(void)loadData : (Questions *)quesTions atIndex:(NSInteger)index Count:(NSInteger)count;

//设置解析的显示状态
-(void)setExplainState : (BOOL)isShow isRight:(BOOL)isRight;

//设置回答后的 选项按钮状态
-(void)setSelectBtnState:(BOOL)isEnabel;

@end

