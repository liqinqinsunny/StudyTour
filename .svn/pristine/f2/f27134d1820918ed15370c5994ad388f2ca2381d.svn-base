//
//  WJPTemplateDetailModel.m
//  StudyTourLeaderSide
//
//  Created by use on 16/5/12.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import "WJPTemplateDetailModel.h"
#import "NSObject+Model.h"

@implementation WJPTemplateDetailModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_tagName forKey:@"tagName"];
    [aCoder encodeObject:_content forKey:@"content"];
    [aCoder encodeObject:_imageArray forKey:@"imageArray"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _title = [aDecoder decodeObjectForKey:@"title"];
        _tagName = [aDecoder decodeObjectForKey:@"tagName"];
        _content = [aDecoder decodeObjectForKey:@"content"];
        _imageArray = [aDecoder decodeObjectForKey:@"imageArray"];
    }
    return self;
}

@end
