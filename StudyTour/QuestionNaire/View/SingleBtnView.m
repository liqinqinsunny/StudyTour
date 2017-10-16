//
//  SingleBtnView.m
//  QuestionNaire
//
//  Created by lqq on 16/6/16.
//  Copyright © 2016年 lqq. All rights reserved.
//

#import "SingleBtnView.h"
#import "QuestionModel.h"
#import "RadioOrMultiModel.h"
#import "RadioOrMultiBtn.h"
#import "UIView+Extension.h"
#import "QustionSection.h"
@interface SingleBtnView() <SingleBtnViewDelegate>

@end

@implementation SingleBtnView

- (void)setModel:(QuestionModel *)model
{
    _model = model;
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    [model.OptionsAry enumerateObjectsUsingBlock:^(QustionSection *questionSection, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![model.type isEqualToString:@"填空"]) {
            RadioOrMultiModel *radioModel = [[RadioOrMultiModel alloc]init];
            radioModel.type = model.type;
            radioModel.title = questionSection.title;
            radioModel.Option = questionSection.section;
            radioModel.value = 0;

            RadioOrMultiBtn *btn = [[RadioOrMultiBtn alloc]init];
            btn.model = radioModel;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:btn];
        }
    }];
}

- (void)setQuestDict:(NSDictionary *)questDict
{
//    _questDict = questDict;
    
    for (int i = 0; i< _model.OptionsAry.count; i++) {
        QustionSection *questionSection = _model.OptionsAry[i];
        RadioOrMultiBtn *btn =  self.subviews[i];
        RadioOrMultiModel *model = btn.model;
        model.value = questDict[questionSection.section];
        btn.model = model;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.subviews enumerateObjectsUsingBlock:^(RadioOrMultiBtn *btn, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat w = ScreenWidth - 40 * 2 - btn.currentImage.size.width;
        CGFloat h = btn.frame.size.height;
        CGFloat y = (h + 20) * idx ;
        btn.frame = CGRectMake(0,y, w , h);

    }];
    _Height = CGRectGetMaxY([self.subviews lastObject].frame);
}

- (void)btnClick:(RadioOrMultiBtn *)btn
{
    btn.selected = ! btn.selected;
    RadioOrMultiModel *btnModel = btn.model;
    
    [self.subviews enumerateObjectsUsingBlock:^(RadioOrMultiBtn *button, NSUInteger idx, BOOL * _Nonnull stop) {
        RadioOrMultiModel *buttonModel = button.model;
        if (buttonModel.value == nil){
              buttonModel.value = @0;
        }
        if ([self.model.type isEqualToString:@"单选"]) { // 单选
            if ([button isEqual:btn]) {
                btn.model.value =  button.selected ? @1 : @0;
                return ;
            }else {
               if (btn.selected) {
                   button.selected = NO;
                   buttonModel.value = @0;
               }
            }
         } else if ([self.model.type isEqualToString:@"多选"]) {
             btnModel.value = btn.selected ? @1 : @0;
         }
    }];

    
    if ([self.delegate respondsToSelector:@selector(SingleBtnView:BtnClick:)]) {
        [self.delegate SingleBtnView:self BtnClick:btn];
    }
}

@end
