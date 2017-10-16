//
//  BBSViewController.m
//  StudyTourLeaderSide
//
//  Created by use on 16/3/17.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import "BBSViewController.h"

//#import <WebKit/WebKit.h>

@interface BBSViewController () <UIWebViewDelegate>

@property (nonatomic, weak) UIWebView *webView;

@end

@implementation BBSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initWebView];
}

- (void)initWebView
{
    CGFloat x = 0;
    CGFloat y = 64;
    CGFloat w = ScreenWidth;
    CGFloat h = ScreenHeight - 64;
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    webView.delegate = self;
    [self.view addSubview:webView];
    _webView = webView;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
}

- (void)back:(UIBarButtonItem *)btn
{
    if (_webView.canGoBack) {
        [_webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    _webTitle = _webTitle == nil ? @"论坛" : _webTitle;
    self.navigationItem.title = _webTitle;
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