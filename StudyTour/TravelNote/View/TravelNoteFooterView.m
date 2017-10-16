
//
//  TravelNoteFooterView.m
//  StudyTour
//
//  Created by use on 16/6/2.
//  Copyright © 2016年 魏鹏. All rights reserved.
//

#import "TravelNoteFooterView.h"

@interface TravelNoteFooterView ()

@property (weak, nonatomic) IBOutlet UILabel *nextTravelNoteLabel;

@end

@implementation TravelNoteFooterView

- (instancetype)init
{
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"TravelNoteFooterView" owner:nil options:nil];
    self = [nibContents lastObject];
    return self;
}

- (void)setNoticeTitle:(NSString *)noticeTitle
{
    _noticeTitle = noticeTitle;
    NSString *noticeString = [NSString stringWithFormat:@"\"%@\"", _noticeTitle];
    _nextTravelNoteLabel.text = noticeString;
    if (_noticeTitle == nil) {
        _nextTravelNoteLabel.text = @"无更多话题";
    }
}

@end