//
//  MessageCell.m
//  StudyTour
//
//  Created by use on 15/12/2.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import "MessageCell.h"
#import "UserInfo.h"
#import "NSString+Frame.h"

@interface MessageCell ()

@property (weak, nonatomic) IBOutlet UILabel *userDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation MessageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(MyMessageModel *)model
{
    _model = model;
    
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    NSString *leadName = @"";
    
    NSArray *array = userInfo.teamleader;
    for (NSDictionary *lead in array) {
        if ([lead[@"teamLeaderId"] isEqualToString:model.teamLeaderId]) {
            leadName = lead[@"teamLeaderName"];
            break;
        }
    }
    
    NSString *userDateStr = [NSString stringWithFormat:@"%@领队 %@", leadName, model.newsTime];
    
    _userDateLabel.text = userDateStr;
    
    CGFloat contentHeight = [model.leaderNews heightWithFont:[UIFont systemFontOfSize:17] withinWidth:ScreenWidth-62];
    CGFloat modelHeight = contentHeight + 39;
    
    _model.myCellHeight = [NSNumber numberWithFloat:modelHeight];
    
    _messageLabel.text = model.leaderNews;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
