//
//  DetailFeedBackFooterView.m
//  StudyTour
//
//  Created by use on 16/6/12.
//  Copyright © 2016年 魏鹏. All rights reserved.
//

#import "DetailFeedBackFooterView.h"

@interface DetailFeedBackFooterView ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *detailFeedBackTextView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (nonatomic, copy) NSString *detailContent;
@end

@implementation DetailFeedBackFooterView

- (instancetype)init
{
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"DetailFeedBackFooterView" owner:nil options:nil];
    self = [nibContents lastObject];
    
    _detailFeedBackTextView.delegate = self;
    
    return self;
}

- (IBAction)submitFeedBack:(UIButton *)sender {
    if (self.submitBlock) {
        if (_detailContent == nil) {
            _detailContent = @"";
        }
        self.submitBlock(_detailContent);
    }
}

#pragma mark -- UIText View Delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (![textView.text isEqualToString:@"请记录今日行程安排中您认为存在的问题，您的建议或意见；请告知我们，我们将尽快为您处理。"]) {
        return YES;
    }
    textView.text = @"";
    textView.textColor = [UIColor colorWithHex:0x777777];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (textView.text.length <= 0 || [textView.text isEqualToString:@"请记录今日行程安排中您认为存在的问题，您的建议或意见；请告知我们，我们将尽快为您处理。"]) {
        textView.text = @"请记录今日行程安排中您认为存在的问题，您的建议或意见；请告知我们，我们将尽快为您处理。";
        textView.textColor = [UIColor colorWithHex:0xcccccc];
        _detailContent = @"";
    } else {
        _detailContent = textView.text;
    }
    return YES;
}

@end
