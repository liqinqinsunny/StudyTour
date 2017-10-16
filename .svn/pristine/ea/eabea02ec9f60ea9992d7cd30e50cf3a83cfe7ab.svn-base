//
//  surveyModel.h
//  StudyTour
//
//  Created by owen on 16/1/16.
//  Copyright © 2016年 魏鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface surveyModel : JSONModel

//是否有其他
@property(nonatomic,assign)BOOL isOther;
//其他内容
@property(nonatomic,strong)NSString * otherTxt;

//是否必选
@property(nonatomic,assign)BOOL isSelect;

//类型
@property(nonatomic,strong)NSString * selectType;

//题目
@property(nonatomic,strong)NSArray * selects;


//所属系列
@property(nonatomic,strong)NSString * seriesName;

//题目标题
@property(nonatomic,strong)NSString * titleName;


// 读取Model数据
+(NSArray *)readPlistData : (NSString *)seriesName;

@end
