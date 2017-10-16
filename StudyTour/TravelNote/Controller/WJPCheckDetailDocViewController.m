//
//  WJPCheckDetailDocViewController.m
//  StudyTourLeaderSide
//
//  Created by use on 16/4/26.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import "WJPCheckDetailDocViewController.h"

@interface WJPCheckDetailDocViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *myWebView;

@end

@implementation WJPCheckDetailDocViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_myWebView setScalesPageToFit:YES];
}

- (void)loadLocalFile
{
    NSURL *fileUrl = [NSURL fileURLWithPath:_filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:fileUrl];
    [_myWebView loadRequest:request];
}

- (void)setNavTitle:(NSString *)navTitle
{
    _navTitle = navTitle;
    self.navigationItem.title = _navTitle;
}

#pragma mark -- LifeCircle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadLocalFile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
