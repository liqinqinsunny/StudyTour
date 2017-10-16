//
//  PlayerController.m
//  StudyTour
//
//  Created by owen on 16/1/14.
//  Copyright © 2016年 魏鹏. All rights reserved.
//

#import "PlayerController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface PlayerController ()

@end

@implementation PlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"安全视频";
    
    _myWebView.delegate = self;
    
    
    
    NSURL *url = [NSURL URLWithString:vedioUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_myWebView loadRequest:request];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
