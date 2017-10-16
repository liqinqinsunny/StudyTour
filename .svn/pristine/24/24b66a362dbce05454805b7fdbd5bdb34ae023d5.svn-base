//
//  surveyModel.m
//  StudyTour
//
//  Created by owen on 16/1/16.
//  Copyright © 2016年 魏鹏. All rights reserved.
//

#import "surveyModel.h"

@implementation surveyModel

+(NSArray *)readPlistData : (NSString *)seriesName
{
    //操作返回的json串
    NSMutableArray *infos = [[NSMutableArray alloc] init];
    
    NSString *configFile = [[NSBundle mainBundle] pathForResource:@"surveyData" ofType:@"plist"];
    NSDictionary *dataDic = [NSDictionary dictionaryWithContentsOfFile:configFile];
    
    if (dataDic == nil) {
        return infos;
    }
    
    //先读取公共题
    NSArray *publicTitleArr = [dataDic objectForKey:@"publicTitle"];
    if (publicTitleArr != nil || publicTitleArr.count > 0) {
        
        for (NSDictionary *dict in publicTitleArr) {
            surveyModel * model =  [[surveyModel alloc] initWithDictionary:dict error:nil];
            if(model != nil)
            {
                [infos addObject : model];
            }
        }
    }
    
    //再读取 个性题  判断个性名称中包含的 个性题
    NSArray * dataKeys = [dataDic allKeys];
    NSString *seriesKey = @"";
    for (NSString * keysName in dataKeys) {
        if ([seriesName containsString:keysName]) {
            seriesKey = keysName;
            break;
        }
    }
    
    if (![seriesKey isEqualToString:@""]) {
        NSArray * personalityArr = [dataDic objectForKey:seriesKey];
        if (personalityArr != nil && personalityArr.count > 0) {
            
            for (NSDictionary *dict in personalityArr) {
                surveyModel * model =  [[surveyModel alloc] initWithDictionary:dict error:nil];
                if(model != nil)
                {
                   [infos addObject : model];
                }
            }
        }
    }
    
    
    //最后读取 评价 调查题
//    BOOL personality1 = [seriesName containsString:@"特色主题"] || [seriesName containsString:@"名校"];
//    BOOL country1 = [seriesName containsString:@"日本"] || [seriesName containsString:@"韩国"] || [seriesName containsString:@"香港"] || [seriesName containsString:@"新加坡"];
//    
//    BOOL personality2 = [seriesName containsString:@"亲子"];
//    BOOL country2 = [seriesName containsString:@"美国"];
//    
//    //不包含这些系列 都要加
//    if ( !(personality1 && country1) && !(personality2 && country2)) {
//        NSArray * othersArr = [dataDic objectForKey:@"other"];
//        if (othersArr != nil && othersArr.count > 0) {
//            
//            for (NSDictionary *dict in othersArr) {
//                surveyModel * model =  [[surveyModel alloc] initWithDictionary:dict error:nil];
//                if(model != nil)
//                {
//                    [infos addObject : model];
//                }
//            }
//        }
//
//    }
    
    return infos;
}

@end
