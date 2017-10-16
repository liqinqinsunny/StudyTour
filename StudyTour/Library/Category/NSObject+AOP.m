//
//  NSObject+AOP.m
//  StudyTour
//
//  Created by 魏鹏 on 15/12/1.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import "NSObject+AOP.h"
#import <objc/runtime.h>

@implementation NSObject (AOP)

+ (void)AOP_ExchangeSelector:(SEL)oldSel andNewSelector:(SEL)newSel
{
    Method oldMethod =  class_getInstanceMethod([self class], oldSel);
    Method newMethod  = class_getInstanceMethod([self class], newSel);
    
    //改变两个方法的具体指针指向
    method_exchangeImplementations(oldMethod, newMethod);
}

@end
