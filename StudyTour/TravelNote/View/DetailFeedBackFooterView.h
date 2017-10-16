//
//  DetailFeedBackFooterView.h
//  StudyTour
//
//  Created by use on 16/6/12.
//  Copyright © 2016年 魏鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SubmitBlock)(NSString *content);

@interface DetailFeedBackFooterView : UIView

@property (nonatomic, copy) SubmitBlock submitBlock;

- (void)setSubmitBlock:(SubmitBlock)submitBlock;

@end
