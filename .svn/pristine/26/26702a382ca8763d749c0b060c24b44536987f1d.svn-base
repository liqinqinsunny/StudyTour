//
//  MyTravelView.h
//  StudyTour
//
//  Created by owen on 15/12/16.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTravel.h"

typedef void (^setScrollHeight)(CGFloat height);

@interface MyTravelView : UIView

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *startDesWidth;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *firstDesWidth;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *secondDesWidth;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *stayViewLeftPace;

//修改父视图 就会改变子视图label的宽度(因为子视图距离父视图边距固定)
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *consultViewWidth;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *stayViewWidth;


//视图组件
//@property (strong, nonatomic) IBOutlet UIView *parentView;

@property (strong, nonatomic) IBOutlet UIView *lastLineView;

@property (strong, nonatomic) IBOutlet UILabel *titleTxt;

@property (strong, nonatomic) IBOutlet UIView *travelView;

@property (strong, nonatomic) IBOutlet UIView *travelLine;

@property (strong, nonatomic) IBOutlet UILabel *travelStart;
@property (strong, nonatomic) IBOutlet UILabel *travelDes1;
@property (strong, nonatomic) IBOutlet UILabel *travelDes2;
@property (strong, nonatomic) IBOutlet UIImageView *travelTool1;
@property (strong, nonatomic) IBOutlet UIImageView *travelTool2;

@property (strong, nonatomic) IBOutlet UIView *consultView;
@property (strong, nonatomic) IBOutlet UILabel *consultDes;


@property (strong, nonatomic) IBOutlet UIView *stayView;
@property (strong, nonatomic) IBOutlet UILabel *stayLabel;

@property (strong, nonatomic) IBOutlet UILabel *travelDescribe;
@property (strong, nonatomic) IBOutlet UIView *travelDesView;

//重新初始化
-(id)init: (id)obj;

//加载数据
-(void)loadData : (MyTravel *)myTravel height:(void(^)(CGFloat height))ScrollHeight;

//设置底线是否隐藏
-(void)setBaseLineHidden : (BOOL)isHidden;

//设置当天的显示状态
-(void)showCurDayState;

//改变交通方式的样式
-(void)showCurDayTravelWay : (NSArray *)wayArr;

@end
