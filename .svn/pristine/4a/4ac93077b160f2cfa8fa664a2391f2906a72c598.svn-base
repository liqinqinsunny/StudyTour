//
//  JiPush.m
//  NewsReader
//
//  Created by hejinbo on 15/7/27.
//  Copyright (c) 2015年 MyCos. All rights reserved.
//

#import "JiPush.h"

@implementation JiPush

+ (void)registerPush
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    //自定义 推动登陆成功后
    //    NSNotificationCenter * login = [NSNotificationCenter defaultCenter];
    //    [login addObserver:self selector:@selector(networkDidLogin:) name:kJPFNetworkDidLoginNotification object:nil];
    //
    //    //自定义 自定义数据推送
    //    NSNotificationCenter * message = [NSNotificationCenter defaultCenter];
    //    [message addObserver:self selector:@selector(networkDidMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
}

+ (void)unregisterPush
{
    
}

+ (void)bindDeviceToken:(NSData *)token
{
    [JPUSHService registerDeviceToken:token];
}

+ (void)handleNotification:(NSDictionary *)userInfo
{
    [JPUSHService handleRemoteNotification:userInfo];
}

+ (void)showLocalNotificationAtFront:(UILocalNotification *)notification identifierKey:(NSString *)notificationKey
{
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:notificationKey];
}

+ (void)setAlias:(NSString *)alias
{
    [JPUSHService setAlias:alias callbackSelector:nil object:self];
}
+ (void)unsetAlias
{
    
}

+ (void)setTopic:(NSString *)topic
{
    NSSet *set = [NSSet setWithObjects:topic,nil];
    [JPUSHService setTags:set callbackSelector:nil object:self];
}
+ (void)unsetTopic
{
    
}

+ (void)setTopics:(NSArray *)topicArr
{
    NSSet *set = [NSSet setWithArray:topicArr];
    [JPUSHService setTags:set callbackSelector:nil object:self];
}

+ (void)clearBadge
{
    [JPUSHService setBadge:0];
}


+ (void)networkDidLogin:(NSNotification *)notification {
    //登陆成功后返回的 标示符不为空0810b88d815
    
    if ([JPUSHService registrationID]) {
        //获取registrationID
        NSString * Uid = [JPUSHService registrationID];
        //存储标示符
        [[NSUserDefaults standardUserDefaults] setObject:Uid forKey:@"registrationID"];
        
        //注意：registrationID 注册号 暂时没有使用
        //NSLog(@"******* registrationID : %@",Uid);
    }
    //注销登陆成功
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPFNetworkDidLoginNotification object:nil];
}

+ (void)networkDidMessage:(NSNotification *)notification {
    
    //TODO:自定义推送内容
    //NSLog(@"notification :%@",notification);
    NSString * content = [[notification valueForKey:@"userInfo"] valueForKey:@"content"];
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"来自游学的消息" message:content delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:@"Ture", nil];
    
    [alert show];
}

+ (void)registerLocalPush
{
    if ([JPUSHService findLocalNotificationWithIdentifier:@"wjplocalpush"]) {
        [JPUSHService deleteLocalNotificationWithIdentifierKey:@"wjplocalpush"];
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    [df setTimeZone:[NSTimeZone localTimeZone]];
    NSDate *notidate = [df dateFromString:@"2016-07-08 16:58:30"];
    
    UILocalNotification * ln = [JPUSHService setLocalNotification:notidate
                             alertBody:@"冷不丁的一天又快结束了，今天游学的感受如何，去做评价吧"
                                 badge:-1
                           alertAction:@"知道了"
                         identifierKey:@"wjplocalpush"
                              userInfo:nil
                             soundName:nil];
    
    NSLog(@"\n\n\n\n\n\n注册成功\n%@\n\n\n\n", ln);
}

@end
