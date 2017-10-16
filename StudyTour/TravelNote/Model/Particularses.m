//
//  Particularses.m
//  StudyTourLeaderSide
//
//  Created by Apple on 16/5/13.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import "Particularses.h"
#import "NSObject+Model.h"
#import "ParticularsesImages.h"
#import "NSString+Frame.h"
#import "WJPTaskModel.h"

#define contentFont [UIFont systemFontOfSize:14]

@implementation Particularses

+ (instancetype)createPartiModelWithDict:(NSDictionary *)dict
{
    Particularses *model = [[self alloc] initWithDict:dict];
    [model calculateCellHeight];
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([@"images" isEqualToString:key]) {
        NSMutableArray *tempArray = [NSMutableArray new];
        for (NSDictionary *dict in value) {
            ParticularsesImages *image_model = [ParticularsesImages createParticularsesImageModelWithDict:dict];
            [tempArray addObject:image_model];
        }
        _imageArray = [tempArray copy];
    } else if ([@"accessorys" isEqualToString:key]) {
        NSMutableArray *tempArray = [NSMutableArray new];
        for (NSDictionary *dict in value) {
            WJPTaskModel *task_model = [WJPTaskModel createWJPTaskModelWithDict:dict];
            [tempArray addObject:task_model];
        }
        _accessoryArray = [tempArray copy];
    }
}

- (void)calculateCellHeight
{
    CGFloat height = 0;
    CGFloat imagesWidth = ScreenWidth - 16*2;
    for (ParticularsesImages *imageModel in _imageArray) {
        height += ([imageModel.imgHeight floatValue] * imagesWidth / [imageModel.imgWidth floatValue]);
    }
    if (_imageArray.count > 0) {
        height += ((_imageArray.count-1) * 8);
    }
    height += [_content heightWithFont:contentFont withinWidth:imagesWidth];
    height += 110;
    
    _cellHeight = height;
}

@end
