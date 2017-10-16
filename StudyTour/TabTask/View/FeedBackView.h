//
//  FeedBackView.h
//  StudyTour
//
//  Created by use on 15/12/3.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedBackView : UIView

@property (nonatomic, copy) NSString *day;
@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) void(^satisfactionBlock)(NSInteger satisfaction);

- (void)setSatisfactionBlock:(void (^)(NSInteger satisfaction))satisfactionBlock;

@end
