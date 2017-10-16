//
//  BasicModel.m
//  StudyTour
//
//  Created by 魏鹏 on 15/12/1.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import "BasicModel.h"

@implementation BasicModel

/**
 
 Json 通用模型
 
 */

- (instancetype)initWithDict:(NSDictionary *)dict

{
    
    self = [super init];
    
    if (self) {
        
        [self setValuesForKeysWithDictionary:dict];
        
    }
    
    return self;
    
}

+ (instancetype)modelWithDict:(NSDictionary *)dict
{
    
    return [[self alloc]initWithDict:dict];
    
}

+ (NSArray *)modelsWithArray:(NSArray *)array
{
    
    NSMutableArray * arrayM = [NSMutableArray array];
    
    for (NSDictionary *dict in array) {
        
        [arrayM addObject:[self modelWithDict:dict]];
        
    }
    
    return arrayM;
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    NSLog(@"%@",key);
    
}

- (NSString *)description
{
    return nil;
}

@end
