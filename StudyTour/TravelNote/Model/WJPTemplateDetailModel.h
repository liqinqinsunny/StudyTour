//
//  WJPTemplateDetailModel.h
//  StudyTourLeaderSide
//
//  Created by use on 16/5/12.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJPTemplateDetailModel : NSObject <NSCoding>

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* tagName;
@property (nonatomic, copy) NSString* content;
@property (nonatomic, copy) NSArray* imageArray;

@end
