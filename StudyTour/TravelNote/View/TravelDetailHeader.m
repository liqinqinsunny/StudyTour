//
//  TravelDetailHeader.m
//  StudyTour
//
//  Created by use on 16/6/12.
//  Copyright © 2016年 魏鹏. All rights reserved.
//

#import "TravelDetailHeader.h"

@interface TravelDetailHeader ()

@property (weak, nonatomic) IBOutlet UILabel *lastTravelNoteLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pointDownImageView;

@end

@implementation TravelDetailHeader

- (instancetype)init
{
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"TravelDetailHeader" owner:nil options:nil];
    self = [nibContents lastObject];
    _pointDownImageView.transform = CGAffineTransformMakeRotation(M_PI);
    return self;
}

- (void)setNoticeTitle:(NSString *)noticeTitle
{
    _noticeTitle = noticeTitle;
    NSString *noticeString = [NSString stringWithFormat:@"\"%@\"", _noticeTitle];
    _lastTravelNoteLabel.text = noticeString;
    if (_noticeTitle == nil) {
        _lastTravelNoteLabel.text = @"无更多话题";
    }
}
@end
