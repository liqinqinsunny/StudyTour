//
//  RootViewController.m
//  StudyTour
//
//  Created by 魏鹏 on 15/12/1.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic,assign) NSInteger tasksCount;
@property (nonatomic, strong) UILabel *remindLabel;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tasksCount = 0;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setNavigationItemAppearence];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma -mark NavigationItem
- (void)setNavigationItemAppearence
{
    if (self.navigationController.viewControllers[0] != self && self.navigationController.viewControllers[0] != nil) {
        self.navigationItem.hidesBackButton = YES;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, 13, 13);
        btn.adjustsImageWhenHighlighted = NO;
        [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = back;
        
        self.tabBarController.tabBar.hidden = YES;
    }
    else {
        self.tabBarController.tabBar.hidden = NO;
    }
}

- (void)back:(UIBarButtonItem *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -mark HUD
- (void)showHud
{
    [self.hud show:NO];
    _tasksCount++;
}

- (void)hideHud
{
    _tasksCount--;
    if (_tasksCount <= 0) {
        [self.hud hide:NO];
    }
}

- (void)showReminder:(NSString *)title
{
    if (_remindLabel) {
        return;
    }
    CGFloat w = 150;
    CGFloat h = 80;
    _remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    _remindLabel.font = [UIFont boldSystemFontOfSize:20];
    _remindLabel.textAlignment = NSTextAlignmentCenter;
    _remindLabel.textColor = [UIColor themeColor];
    _remindLabel.backgroundColor = [UIColor whiteColor];
    _remindLabel.center = CGPointMake(ScreenWidth*0.5, ScreenHeight*0.5);
    _remindLabel.layer.cornerRadius = 5;
    _remindLabel.clipsToBounds = YES;
    _remindLabel.layer.borderColor = [[UIColor themeColor] CGColor];
    _remindLabel.layer.borderWidth = 1;

    _remindLabel.text = title;
    [self.view addSubview:_remindLabel];
    [self.view bringSubviewToFront:_remindLabel];
    [self performSelector:@selector(hideReminder) withObject:nil afterDelay:1.0];
}

- (void)hideReminder
{
    if (_remindLabel) {
        [UIView animateWithDuration:0.5 animations:^{
            _remindLabel.alpha = 0;
        } completion:^(BOOL finished) {
            [_remindLabel removeFromSuperview];
            _remindLabel = nil;
        }];

    }
}


- (void)showFailedView
{
    if ([UIDevice currentDevice].systemVersion.floatValue < 8) {
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"网络连接失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertV show];
    } else {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提醒" message:@"网络连接失败" preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:ac animated:YES completion:nil];
    }
}

- (MBProgressHUD *)hud
{
    if(!_hud){
        MBProgressHUD *hud = [[MBProgressHUD alloc] init];
        hud.labelText = @"正在努力加载";
        [self.view addSubview:hud];
        [self.view bringSubviewToFront:hud];
        _hud = hud;
    }
    [self.view bringSubviewToFront:_hud];
    return _hud;
}

- (void)showTips:(NSString *)str {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = str;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.yOffset = ScreenHeight/2 * 0.7f;

    
    [hud hide:YES afterDelay:1];
}

-(NSDictionary *)readSaveData : (NSString *)filePath
{
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (!data) {
        return nil;
    }
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    if(dict != nil){
        return dict;
    }
    return nil;
}

-(void)showNotDataTips : (NSString *)tipStr
{
    UILabel * txtlabel = [self.view viewWithTag:NotDataTxtTag];
    if (txtlabel != nil) {
        return;
    }
    txtlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    txtlabel.text = tipStr;
    [txtlabel setTextAlignment:NSTextAlignmentCenter];
    [txtlabel setTextColor:[UIColor colorWithHex:0x969695]];
    [txtlabel setFont:[UIFont systemFontOfSize : 18.0f]];
    txtlabel.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
    [txtlabel setTag:NotDataTxtTag];
    [self.view addSubview:txtlabel];
}

-(void)removeNotDataTips
{
    UILabel * labelTxt = [self.view viewWithTag:NotDataTxtTag];
    if (labelTxt != nil) {
        [labelTxt removeFromSuperview];
    }
}

@end