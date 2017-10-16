//
//  WJPTravelNoteDetailControllerViewController.h
//  StudyTour
//
//  Created by use on 16/6/1.
//  Copyright © 2016年 魏鹏. All rights reserved.
//

#import "RootViewController.h"

@interface WJPTravelNoteDetailControllerViewController : RootViewController
{
    NSString *test;
}
// 游记概况Id
@property(nonatomic,copy) NSString *templateId;

// 团号
@property(nonatomic,copy) NSString *groupId;

// 事件Id
@property(nonatomic,copy) NSString *introId;

// 事件名称
@property(nonatomic,copy) NSString *introName;

@property (nonatomic, copy) NSArray *travelArray;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, assign) BOOL jp_scrollToLastCell;

@end