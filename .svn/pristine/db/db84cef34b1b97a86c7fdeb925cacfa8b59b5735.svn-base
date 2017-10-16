//
//  FeecBackHeaderView.m
//  StudyTour
//
//  Created by use on 16/6/12.
//  Copyright © 2016年 魏鹏. All rights reserved.
//

#import "FeecBackHeaderView.h"

@interface FeecBackHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *dayNameLabel;
@property (weak, nonatomic) IBOutlet UIView *feedbackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

@implementation FeecBackHeaderView

- (void)setModel:(TravelNotePerDayModel *)model
{
    _model = model;
    [self setFeedbackStatus:_model.feedback];
    [self setType:_model.type];
    [self setDayName:_model.dayName];
}

- (void)setDayName:(NSString *)dayName
{
    _dayNameLabel.text = dayName;
}

- (void)setType:(NSString *)type
{
    if ([type isEqualToString:@"0"]) {
        _bottomConstraint.constant = 4;
        _feedbackView.hidden = YES;
    } else {
        _bottomConstraint.constant = 116;
        _feedbackView.hidden = NO;
    }
}

- (void)setFeedbackStatus:(NSString *)feedbackStatus
{
    _model.feedback = feedbackStatus;
    NSInteger status = [feedbackStatus integerValue];
    for (NSInteger i = 0; i < 3; ++i) {
        UIButton *button = [self viewWithTag:(i+10)];
        if (i == status) {
            button.backgroundColor = [UIColor themeColor];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.enabled = NO;
        } else {
            button.backgroundColor = [UIColor whiteColor];
            button.layer.borderWidth = 1;
            button.layer.borderColor = [UIColor themeColor].CGColor;
            [button setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
            if (status < 3) {
                button.enabled = NO;
            } else {
                button.enabled = YES;
            }
        }
    }
}

- (IBAction)feedBackClicked:(UIButton *)sender {
    if (self.feedbackBlock) {
        self.feedbackBlock(sender.tag - 10);
        [self setFeedbackStatus:[NSString stringWithFormat:@"%ld", sender.tag-10]];
    }
}

@end
