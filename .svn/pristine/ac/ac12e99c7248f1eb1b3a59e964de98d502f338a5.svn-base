//
//  WebViewController.m
//  StudyTour
//
//  Created by owen on 15/12/20.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import "WebViewController.h"
#import "UserInfo.h"


@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"游学须知";
    self.automaticallyAdjustsScrollViewInsets = NO;
    //获得当前国家
    //1.第一种方式,使用loadRequest:方法加载本地文件NSURLRequest
    NSString* path = [[NSBundle mainBundle]
                      pathForResource:[self getCountry] ofType:@"html" inDirectory:@"Index"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
    self.webView.delegate = self;
    [self.webView loadRequest:request];
    
    
    //2.第二种方式,使用loadHTMLString:baseURL:加载HTML字符串
//    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
//    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
//    NSString *html = [NSString stringWithContentsOfFile:path1 encoding:NSUTF8StringEncoding error:nil];
//    [self.webView loadHTMLString:html baseURL:baseURL];
}


-(NSString *)getCountry
{
    NSString * country = [UserInfo sharedUserInfo].country;
    NSString * html = @"youxue_asia";
    if ([country isEqualToString:@"新西兰"]) {
        html = @"youxue_newzealand";
    }
    else if([country isEqualToString:@"韩国"]){
        html = @"youxue_asia";
    }
    else if([country isEqualToString:@"日本"]){
        html = @"youxue_asia";
    }
    else if([country isEqualToString:@"香港"]){
        html = @"youxue_asia";
    }
    else if([country isEqualToString:@"新加坡"]){
        html = @"youxue_asia";
    }
    else if([country isEqualToString:@"欧洲"]){
        html = @"youxue_europe";
    }
    else if([country isEqualToString:@"英欧"]){
        html = @"youxue_europe";
    }
    else if([country isEqualToString:@"澳大利亚"]){
        html = @"youxue_australia";
    }
    else if([country isEqualToString:@"英国"]){
        html = @"youxue_england";
    }
    else if([country isEqualToString:@"美国"]){
        html = @"youxue_usa";
    }
    else if([country isEqualToString:@"加拿大"]){
        html = @"youxue_canada";
    }
    return html;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showHud];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideHud];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //统计进入游前须知页面
    [MobClick event:Click_Notice_yxnotice_Count];
}

@end
