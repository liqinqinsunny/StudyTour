//
//  MyTravel.m
//  StudyTour
//
//  Created by owen on 15/12/16.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import "MyTravel.h"

@implementation MyTravel

+(MyTravel *)infoFromDict:(NSDictionary *)dict
{
    MyTravel *info = [[MyTravel alloc] init];
    
    info.curDays = [dict objectForKey:@"curDays"];
    info.startravel = [dict objectForKey:@"startPlace"];
    info.travel = [dict objectForKey:@"travel"];
    info.tripDes = [dict objectForKey:@"tripDes"];
    info.tripDesImg = [dict objectForKey:@"tripDesImg"];
    info.liveHotel = [dict objectForKey:@"liveHotel"];
    return info;
}

+(NSArray *)readMyTravelData : (NSDictionary *)dict
{
    //操作出来网络返回的json串
    NSMutableArray *infos = [[NSMutableArray alloc] init];
    NSArray *travelData = [dict objectForKey:DataKey];
    if (travelData.count <= 0) {
        NSLog(@"没有行程数据");
    }

    for (NSDictionary *dict in travelData) {
        MyTravel * travel =[MyTravel infoFromDict:dict];
        [infos addObject : travel];
    }
    
//    for (NSInteger i = 0; i< 10; i++) {
//        MyTravel * travel =[[MyTravel alloc ]init];
//        travel.curDays = [NSString stringWithFormat:@"%ld",(i + 1)];
//        travel.tripDes = @"我们可以获得当前View的traitCollection，从而得知当前View处于什么样的Size Class下。并且当traitCollection有变化时，我们可以通过重写traitCollectionDidChange知道该事件的触发。默认情况下，这个方法什么都不执行,默认情况下，这个方法什么都不执行";
//         [infos addObject : travel];
//    }
    return infos;
}

@end
