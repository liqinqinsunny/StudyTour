//
//  DetailFeedBackCell.h
//  StudyTour
//
//  Created by use on 16/6/12.
//  Copyright © 2016年 魏鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChooseBlock)(BOOL choose);

@interface DetailFeedBackCell : UITableViewCell

@property (nonatomic, copy) NSString *iconPath;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, copy) NSString *chooseResult;
@property (nonatomic, copy) ChooseBlock chooseBlock;

- (void)setChooseBlock:(ChooseBlock)chooseBlock;

@end
