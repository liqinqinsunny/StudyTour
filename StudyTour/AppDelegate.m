//
//  AppDelegate.m
//  StudyTour
//
//  Created by 魏鹏 on 15/12/1.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import "AppDelegate.h"
#import "JPTabBarController.h"
#import "LoginViewController.h"
#import "JPUSHService.h"
#import "JiPush.h"
#import "FxGlobal.h"
#import "UserInfo.h"
#import "MobClick.h"
#import "UMCheckUpdate.h"
#import <AVFoundation/AVFoundation.h>
#import "EnrollViewController.h"
#import "UserLoginViewController.h"

#import "WJPTravelNoteDetailControllerViewController.h"

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "WXApi.h"

//#import "WJPTravelNoteDetailControllerViewController.h"
#import "WJPTravelNoteHomePageController.h"


#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "WXApi.h"
#import "UserInfoModel.h"
#import "TraveIntroViewController.h"
#import <JSPatch/JSPatch.h>

@interface AppDelegate ()


@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    UserInfoModel *userinfo = [UserInfoModel sharedUserInfo];
    
    if (![userinfo isUserLogin]) {
        UserLoginViewController *loginVc = [[UserLoginViewController alloc]init];
        RootNavigationController *nc = [[RootNavigationController alloc]initWithRootViewController:loginVc];
        self.window.rootViewController = nc;
    } else {
        if (userinfo.isAgree){
            WJPTravelNoteHomePageController *homePage = [[WJPTravelNoteHomePageController alloc]init];
            RootNavigationController *navi = [[RootNavigationController alloc]initWithRootViewController:homePage];
            self.window.rootViewController = navi;
        } else {
            TraveIntroViewController *intro = [[TraveIntroViewController alloc]init];
            RootNavigationController *navi = [[RootNavigationController alloc]initWithRootViewController:intro];
            self.window.rootViewController = navi;
        }
    }

    //设置程序文件 不备份到iCloud和iTunes上；
    NSString *filePath = [FxGlobal getRootPath];
    [FxGlobal setNotBackUp:filePath];
    
    //推送注册
    [JiPush registerPush];
    [JPUSHService setupWithOption:launchOptions appKey:JPushAppKey channel:@"AppStore" apsForProduction:YES];
    
    //友盟统计
    [MobClick startWithAppkey:UMengAppKey reportPolicy:BATCH channelId:@""];
    [UMCheckUpdate checkUpdateWithDelegate:self selector:@selector(updateApp:) appkey:UMengAppKey channel: @""];

    //指定消息页面
    if (launchOptions) {
        NSDictionary * remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        //这个判断是在程序没有运行的情况下收到通知，点击通知跳转页面
        if (remoteNotification) {
            [self goToMssageViewControllerWith:remoteNotification];
        }
    }
    
    //注册播放视频 有声音
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    BOOL ok;
    NSError *setCategoryError = nil;
    ok = [audioSession setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
    if (!ok) {
        NSLog(@"%s setCategoryError=%@", __PRETTY_FUNCTION__, setCategoryError);
    }
    
    // 友盟分享
    [UMSocialData setAppKey:UMengAppKey];
    
    [WXApi registerApp:WxAppId withDescription:@"gjyx"];
    
    
    //打开调试log的开关
    [UMSocialData openLog:YES];
    
    //如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
    
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:WxAppId appSecret:WxAppSecret url:@"http://www.umeng.com/social"];
    
    // JSPatch
    [JSPatch startWithAppKey:@"6c99a23c21db5ed1"];
    [JSPatch sync];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self updateNotification : application];
//    [JiPush registerLocalPush];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self updateNotification : application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}



#pragma mark - APNS

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JiPush bindDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


//  [UIApplication sharedApplication].applicationIconBadgeNumber ++;

#pragma mark 消息推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required
    [JiPush handleNotification:userInfo];
    [self goToMssageViewControllerWith:userInfo];
}

 // IOS 7 Support Required
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    
    if (application.applicationState == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"查看消息" message:userInfo[@"aps"][@"alert"]delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil ,nil];
        
        [alert setTag:11];
        [alert show];
    }
    else{
        [JiPush handleNotification:userInfo];
        completionHandler(UIBackgroundFetchResultNewData);

        [self goToMssageViewControllerWith:userInfo];
    }
}

//本地通知  应用在前台时的通知 badge
- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JiPush showLocalNotificationAtFront:notification identifierKey:nil];
}

- (void)updateNotification:(UIApplication *)application
{
//    [application cancelAllLocalNotifications];
    [application setApplicationIconBadgeNumber:0];
    [JiPush clearBadge];
}

- (void)goToMssageViewControllerWith:(NSDictionary*)msgDic{
    //跳转一个页面，
    UIViewController * viewcontroller = self.window.rootViewController;
    if ([viewcontroller isKindOfClass:[JPTabBarController class]])
    {
        ((JPTabBarController *)viewcontroller).selectedIndex = 2;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger tag = alertView.tag;
    if (tag == 11) {
        if (buttonIndex == 0) {
            [self goToMssageViewControllerWith:nil];
        }
    }
    else
    {
        if (buttonIndex == 0) {
            if (self.AppStorePath != nil) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.AppStorePath]];
            }
            
        }
    }
}

#pragma mark -- 友盟自动更新
-(void)updateApp : (NSDictionary *)appDicData
{
    BOOL isUpdate = [[appDicData objectForKey:@"update"] boolValue];
    if(isUpdate)
    {
        self.AppStorePath =[appDicData objectForKey:@"path"];
        NSString * version = [appDicData objectForKey:@"version"];
        NSString * title = [NSString stringWithFormat:@"%@ %@",UMengTips,version];
        NSString * contens = [appDicData objectForKey:@"update_log"];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:title message:contens  delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert setTag:12];
        [alert show];
    }
}




@end
