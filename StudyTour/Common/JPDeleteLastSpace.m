//
//  JPDeleteLastSpace.m
//  StudyTourLeaderSide
//
//  Created by use on 16/3/31.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import "JPDeleteLastSpace.h"

@implementation JPDeleteLastSpace

+ (NSString *)deleteLastSpaceInString:(NSString *)originalString
{
    if (originalString.length <= 0) {
        return nil;
    }
    NSString *retString = originalString;
    for (NSInteger i = originalString.length-1; i > 0; --i) {
        NSString *lastChar = [retString substringFromIndex:i];
        if ([lastChar isEqualToString:@" "]) {
            retString = [retString substringToIndex:i];
        } else {
            break;
        }
    }
    return retString;
}

@end
