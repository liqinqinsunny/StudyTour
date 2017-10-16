//
//  WJPPhotoBrowseViewController.h
//  StudyTourLeaderSide
//
//  Created by use on 16/5/17.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import "RootViewController.h"

typedef void(^DeleteBlock)(NSInteger index);

@interface WJPPhotoBrowseViewController : RootViewController

@property (nonatomic, copy) DeleteBlock deleteBlock;

@property (nonatomic, copy) NSArray *imageArray;
@property (nonatomic, copy) NSArray *placeholdImageArray;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, assign) BOOL isFromSuperViewController;

- (void)setDeleteBlock:(DeleteBlock)deleteBlock;

@end
