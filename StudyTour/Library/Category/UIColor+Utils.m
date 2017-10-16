//
//  UIColor+Utils.m
//  StudyTour
//
//  Created by 魏鹏 on 15/12/1.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#define ThemeColor colorWithHex:0x2dbe60
#define TabBarBackgroundColor colorWithHex:0xf4f4f4
#define CustomBackgroundColor colorWithHex:0xF7F3EC

#import "UIColor+Utils.h"

@implementation UIColor (Utils)

+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0
                           alpha:alpha];
}

+ (UIColor *)colorWithHex:(int)hexValue
{
    return [UIColor colorWithHex:hexValue alpha:1.0];
}

+ (UIColor *)themeColor
{
    return [UIColor ThemeColor];
}

+ (UIColor *)tabBarBackgroundColor
{
    return [UIColor TabBarBackgroundColor];
}

+ (UIColor *)customBackgroundColor
{
    return [UIColor CustomBackgroundColor];
}

@end
