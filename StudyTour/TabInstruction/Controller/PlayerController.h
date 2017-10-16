//
//  PlayerController.h
//  StudyTour
//
//  Created by owen on 16/1/14.
//  Copyright © 2016年 魏鹏. All rights reserved.
//

#import "RootViewController.h"

@interface PlayerController : RootViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *myWebView;

@property (assign, nonatomic) BOOL isPlay;

@end
