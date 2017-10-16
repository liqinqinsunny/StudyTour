//
//  QuestionCellFrame.m
//  StudyTour
//
//  Created by lqq on 16/6/21.
//  Copyright © 2016年 lqq. All rights reserved.
//

#import "QuestionCellFrame.h"
#import "QuestionModel.h"
#import "NSString+Frame.h"
#import "SingleBtnView.h"
#import "RadioOrMultiModel.h"
#import "RadioOrMultiBtn.h"
#import "QustionSection.h"
#define titleFont  [UIFont fontWithName:@"Helvetica-Bold" size:14]

@implementation QuestionCellFrame

- (void)setModel:(QuestionModel *)model
{
    _model = model;
    
    CGFloat titleW = ScreenWidth - 40 * 2;
    NSString *strtitle = [NSString stringWithFormat:@"%@.%@",model.SortId, model.title];
    
    CGFloat titleH = [strtitle heightWithFont:titleFont withinWidth:titleW ];
    titleH += 2;
    self.titleFrame = CGRectMake(40, 40, titleW , titleH);
    static NSInteger xxx = 0;
    NSLog(@"row: %ld,   %f", (long)xxx++, titleH);
    CGFloat viewY = CGRectGetMaxY(self.titleFrame) + 40;


    UIView *view = [[UIView alloc]init];
    [model.OptionsAry enumerateObjectsUsingBlock:^(QustionSection *questionSection, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![model.type isEqualToString:@"填空"]) {
            RadioOrMultiModel *radioModel = [[RadioOrMultiModel alloc]init];
            radioModel.type = model.type;
            radioModel.title = questionSection.title;
            radioModel.Option = questionSection.section;
            radioModel.value = 0;
            
            RadioOrMultiBtn *btn = [[RadioOrMultiBtn alloc]init];
            btn.model = radioModel;
            [view addSubview:btn];
        }
    }];
    [view.subviews enumerateObjectsUsingBlock:^(RadioOrMultiBtn *btn, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat w = ScreenWidth - 40 * 2;
        CGFloat h = btn.frame.size.height;
        CGFloat y = (h + 20) * idx ;
        btn.frame = CGRectMake(0,y, w , h);
        
    }];
    CGFloat _viewH  = CGRectGetMaxY([view.subviews lastObject].frame);
    
    
    self.viewFrame = CGRectMake(40, viewY, titleW, _viewH);
    
    CGFloat textY = CGRectGetMaxY(self.viewFrame) + 40;
    CGFloat sepY = 0;

    if ([model.type isEqualToString:@"填空"]) {
        self.viewFrame = CGRectZero;
        textY = CGRectGetMaxY(self.titleFrame) + 40;
        self.textFieldFrame = CGRectMake(40, textY, titleW, 40);
        sepY = CGRectGetMaxY(self.textFieldFrame) + 40;
    } else {
        if ([model.OptionText isEqualToString:@""]) {
            self.textFieldFrame = CGRectZero;
            sepY = textY;
        } else {
            self.textFieldFrame = CGRectMake(40, textY, titleW, 40);
            sepY = CGRectGetMaxY(self.textFieldFrame) + 40;
        }
    }
    self.separateViewFrame = CGRectMake(40, sepY, titleW, 1);
    self.rowHeight = CGRectGetMaxY(self.separateViewFrame);
    
}
@end
