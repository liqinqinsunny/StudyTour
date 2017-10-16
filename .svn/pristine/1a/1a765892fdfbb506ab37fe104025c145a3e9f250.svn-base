//
//  NSString+Json.m
//  StudyTour
//
//  Created by Apple on 16/6/22.
//  Copyright © 2016年 魏鹏. All rights reserved.
//

#import "NSString+Json.h"

@implementation NSString (Json)

+ (NSString *)getJsonString:(id)thedata
{
    NSString *jsonString = [NSString string];
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:thedata
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
@end
