//
//  NetWorkErrorView.h
//  StudyTourLeaderSide
//
//  Created by use on 16/3/25.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetWorkErrorView : UIView

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *noticeTitle;

@property (nonatomic, copy) void(^operateBlock)();

- (void)setOperateBlock:(void (^)())operateBlock;

@end
