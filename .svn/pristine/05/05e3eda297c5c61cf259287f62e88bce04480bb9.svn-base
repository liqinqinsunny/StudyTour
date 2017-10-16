
//
//  DetailFeedBackCell.m
//  StudyTour
//
//  Created by use on 16/6/12.
//  Copyright © 2016年 魏鹏. All rights reserved.
//

#import "DetailFeedBackCell.h"

@interface DetailFeedBackCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseButton;


@end

@implementation DetailFeedBackCell

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)chooseClicked:(UIButton *)sender {
    if (self.chooseBlock) {
        self.chooseBlock(!sender.isSelected);
        sender.selected = !sender.selected;
    }
}

- (void)setIconPath:(NSString *)iconPath
{
    _iconPath = iconPath;
    _iconView.image = [UIImage imageNamed:_iconPath];
}

- (void)setTypeName:(NSString *)typeName
{
    _typeName = typeName;
    _typeLabel.text = _typeName;
}

- (void)setChooseResult:(NSString *)chooseResult
{
    if ([chooseResult isEqualToString:@"1"]) {
        _chooseButton.selected = YES;
    } else {
        _chooseButton.selected = NO;
    }
}

@end
