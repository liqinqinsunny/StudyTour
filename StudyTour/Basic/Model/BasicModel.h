//
//  BasicModel.h
//  StudyTour
//
//  Created by 魏鹏 on 15/12/1.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicModel : NSObject

+ (instancetype)modelWithDict:(NSDictionary *)dict;
+ (NSArray *)modelsWithArray:(NSArray *)array;

@end
