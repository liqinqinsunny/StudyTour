//
//  NSObject+Model.h
//  Esports
//
//  Created by 魏鹏 on 15/10/22.
//  Copyright © 2015年 AerialSeeding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Model)

+ (id)createModelWithDict:(NSDictionary *)dict;
- (id)initWithDict:(NSDictionary *)dict;

@end
