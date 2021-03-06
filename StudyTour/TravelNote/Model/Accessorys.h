//
//  Accessorys.h
//  StudyTourLeaderSide
//
//  Created by Apple on 16/5/13.
//  Copyright © 2016年 lqq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Accessorys : NSObject
// 附件标题
@property(nonatomic,copy) NSString *title;
// 附件类型（1：附件类型，2：内容类型，3：外链类型）
@property(nonatomic,copy) NSString *type;
// 附件Id
@property(nonatomic,copy) NSString *taskId;
// 附件url
@property(nonatomic,copy) NSString *accessoryUrl;
// 附件下载量
@property(nonatomic,copy) NSString *downloadCount;

+ (instancetype)createAccessoryModelWithDict:(NSDictionary *)dict;

@end
