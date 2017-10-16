//
//  RootViewController.h
//  StudyTour
//
//  Created by 魏鹏 on 15/12/1.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController
{
@protected
    MBProgressHUD *_hud;
}

- (void)showHud;
- (void)hideHud;


- (void)showReminder:(NSString *)title;
- (void)hideReminder;

- (void)showFailedView;

//页签提示
- (void)showTips:(NSString *)str;

//读取缓存数据
-(NSDictionary *)readSaveData : (NSString *)filePath;

//无数据 文案页面显示
-(void)showNotDataTips : (NSString *)tipStr;
//删除无数据提示
-(void)removeNotDataTips;

@end
