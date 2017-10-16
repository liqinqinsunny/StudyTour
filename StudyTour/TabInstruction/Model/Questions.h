//
//  Questions.h
//  StudyTour
//
//  Created by owen on 15/12/10.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import "JSONModel.h"

@interface Questions : JSONModel

@property(nonatomic,strong)NSString * title;

@property(nonatomic,strong)NSArray * selectArr;

@property(nonatomic,strong)NSString * answer;

@property(nonatomic,strong)NSString * explain;

//是否已经答过
@property(nonatomic,assign)BOOL ansState;
//已经回答的答案
@property(nonatomic,assign)BOOL answered;


//选择索引
@property(nonatomic,assign)NSInteger selectIndex;

//给属性赋值
+(Questions *)infoFromDict:(NSDictionary *)dict;

//读取测试题plist
+(NSArray *)readQuestionsPlist;


@end
