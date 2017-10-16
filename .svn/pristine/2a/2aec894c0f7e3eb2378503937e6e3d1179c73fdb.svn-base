//
//  TableViewCell.m
//  StudyTour
//
//  Created by use on 15/12/2.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import "TableViewCell.h"
#import "UserInfo.h"

@interface TableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskTitleLabel;

@property (nonatomic, strong) UserInfo *userInfo;
@end


@implementation TableViewCell

- (void)awakeFromNib {
    // Initialization code
    _userInfo = [UserInfo sharedUserInfo];
}

- (void)setModel:(TaskModel *)model
{
    _model = model;
    NSString *taskFlagKey = [NSString stringWithFormat:@"taskState%@%@", _userInfo.userId, model.taskId];
    _dateLabel.text = @"01-24";
    BOOL state = [model.taskState isEqualToString:@"1"];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:taskFlagKey] integerValue] == 100) {
        state = YES;
    } else if ([model.taskId isEqualToString:@"weijinpeng"]) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"Survey%@%@", _userInfo.group, _userInfo.cardId]] != nil){
            state = YES;
        }
    }
    
    _stateLabel.text = state ? @"已完成" : @"未完成";
    _stateLabel.textColor = state ? [UIColor themeColor] : [UIColor redColor];
    _taskTitleLabel.text = model.taskTitle;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
