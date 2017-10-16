//
//  MyTravelController.h
//  StudyTour
//
//  Created by owen on 15/12/16.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTravelController : RootViewController<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;

@property(assign,nonatomic)NSInteger curDay;

@property(strong,nonatomic)NSMutableArray * pagePointArr;

@property(assign,nonatomic)CGFloat posY;


//设置导航样式
-(void)setNavigationStyle;

//网络请求
-(void)operateNetwork : (NSString *)savePath;
;
@end
