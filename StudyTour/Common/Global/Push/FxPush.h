//
//  FxPush.h
//  FxHejinbo
//
//  Created by hejinbo on 15/6/9.
//  Copyright (c) 2015年 MyCos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FxPush : NSObject 

@property(nonatomic, strong) NSString   *userId;
@property(nonatomic, strong) NSString   *aliasName;
@property(nonatomic, strong) NSString   *topicName;

//注册
- (void)registerPush;

//卸载
- (void)unregisterPush;

//绑定
- (void)bindDeviceToken:(NSData *)token;

//处理收到的APNS消息，向服务器上报收到APNS消息
- (void)handleNotification:(NSDictionary *)userInfo;

//本地消息(打开应用时)
-(void)showLocalNotificationAtFront:(UILocalNotification *)notification;

//设置别名 (会覆盖其他的设置)
- (void)setAlias:(NSString *)alias;
- (void)unsetAlias;

//这是主题/标签(会覆盖其他的设置)
- (void)setTopic:(NSString *)topic;
- (void)unsetTopic;

//设置多个标签
- (void)setTopics:(NSArray *)topicArr;

//设置标签和别名
- (void)setTopic:(NSString *)tags Andalias:(NSString *)alias;

//清空角标计数
- (void)clearBadge;

// 注册本地通知 wjp
- (void)registerLocalPush;

@end
