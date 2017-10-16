//
//  FxGlobal.h
//  FxHejinbo
//
//  Created by hejinbo on 15/5/12.
//  Copyright (c) 2015年 MyCos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FxPush.h"

@interface FxGlobal : NSObject

@property(nonatomic, strong) FxPush     *push;

@property(nonatomic, strong) NSMutableArray *TagsArr;

+ (FxGlobal *)global;

// 系统版本
+ (BOOL)isSystemLowIOS9;
+ (BOOL)isSystemLowIOS8;
+ (BOOL)isSystemLowIOS7;
+ (BOOL)isSystemLowiOS6;
+ (NSString *)clientVersion;

// 缓存路径
+ (NSString *)getRootPath;


//设置不备份项目文件到iCloud
+ (BOOL)setNotBackUp:(NSString *)filePath;

// 系统提示
+ (void)alertMessage:(NSString *)message;
+ (void)alertMessageEx:(NSString *)message
                 title:(NSString *)title
              okTtitle:(NSString *)okTitle
           cancelTitle:(NSString *)cancelTitle
              delegate:(id)delegate;

// 退出
+ (void)logout;

@end
