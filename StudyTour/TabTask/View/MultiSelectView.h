//
//  MultiSelectView.h
//  StudyTour
//
//  Created by use on 15/12/17.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultiSelectView : UIView

@property (nonatomic, copy) NSMutableArray *dataArr;

@property (nonatomic, copy) NSString *theTitle;

@property (nonatomic, strong) NSDictionary *anwserDict;

// 0 必答    1 若有
@property (nonatomic, assign) NSInteger selelctType;

@end
