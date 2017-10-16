//
//  SingleBtnView.h
//  QuestionNaire
//
//  Created by lqq on 16/6/16.
//  Copyright © 2016年 lqq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SingleBtnView;
@class QuestionModel;
@class RadioOrMultiBtn;

@protocol SingleBtnViewDelegate<NSObject>
@optional
- (void)SingleBtnView:(SingleBtnView *)singleBtnView BtnClick:(RadioOrMultiBtn *)btn;

@end

@interface SingleBtnView : UIView

@property(nonatomic,strong) QuestionModel *model;

@property(nonatomic,assign) id<SingleBtnViewDelegate> delegate;

@property(nonatomic,assign) CGFloat Height;

@property(nonatomic,strong) NSDictionary *questDict;


@end
