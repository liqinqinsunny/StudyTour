//
//  WriteWordsOfTravelNoteViewController.h
//  StudyTour
//
//  Created by use on 16/7/8.
//  Copyright © 2016年 魏鹏. All rights reserved.
//

#import "RootViewController.h"
#import "WJPTemplateDetailModel.h"

@interface WriteWordsOfTravelNoteViewController : RootViewController

@property (nonatomic, copy) NSString *contentString;
@property (nonatomic, strong) WJPTemplateDetailModel *dataModel;

@end
