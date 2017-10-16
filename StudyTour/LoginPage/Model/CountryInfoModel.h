//
//  CountryInfoModel.h
//  StudyTourLeaderSide
//
//  Created by use on 16/3/15.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountryInfoModel : NSObject

@property (nonatomic, copy) NSString *countryPicture;
@property (nonatomic, copy) NSString *countryName;
@property (nonatomic, copy) NSString *countryContent;

+ (id)createCountryInfoModelWithDict:(NSDictionary *)dict;

@end
