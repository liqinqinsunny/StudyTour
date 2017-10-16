//
//  LineImagesGroupView.h
//  ImgScrollView
//
//  Created by jeremy on 16/5/14.
//  Copyright © 2016年 lqq. All rights reserved.
//

#import "HZImagesGroupView.h"

@interface LineImagesGroupView : UIScrollView

@property (nonatomic,assign) CGFloat imgW;
@property (nonatomic,assign) CGFloat imgH;
@property (nonatomic,assign) CGFloat imgMargin;

@property (nonatomic,strong) NSArray *photoItemArray;
@end
