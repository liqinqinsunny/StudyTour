//
//  InstructionViewController.m
//  StudyTour
//
//  Created by 魏鹏 on 15/12/1.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import "InstructionViewController.h"
#import "CheckQuestionController.h"
#import "MyTravelController.h"
#import "WebViewController.h"
#import "PlayerVedioController.h"
#import "PlayerController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface InstructionViewController ()

@property (weak, nonatomic) IBOutlet UIButton *button_xing;
@property (weak, nonatomic) IBOutlet UIButton *button_wo;
@property (weak, nonatomic) IBOutlet UIButton *button_pin;
@property (weak, nonatomic) IBOutlet UIButton *button_shi;

@property (nonatomic, strong) MPMoviePlayerViewController * moviePlayerController;
@end

@implementation InstructionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"行前须知";
    
    _button_xing.layer.cornerRadius = 5;
    _button_xing.clipsToBounds = YES;
    _button_xing.layer.borderWidth = 1;
    _button_xing.layer.borderColor = [UIColor colorWithHex:0xDBDBDB].CGColor;
    
    _button_wo.layer.cornerRadius = 5;
    _button_wo.clipsToBounds = YES;
    _button_wo.layer.borderWidth = 1;
    _button_wo.layer.borderColor = [UIColor colorWithHex:0xDBDBDB].CGColor;
    
    _button_pin.layer.cornerRadius = 5;
    _button_pin.clipsToBounds = YES;
    _button_pin.layer.borderWidth = 1;
    _button_pin.layer.borderColor = [UIColor colorWithHex:0xDBDBDB].CGColor;
    
    _button_shi.layer.cornerRadius = 5;
    _button_shi.clipsToBounds = YES;
    _button_shi.layer.borderWidth = 1;
    _button_shi.layer.borderColor = [UIColor colorWithHex:0xDBDBDB].CGColor;
    
    
}

- (void)jumpToPlayVideo
{

    NSURL *videoURL = [NSURL URLWithString:@"http://down.ffxia.com/mp4/457.mp4"];

    _moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];

    [_moviePlayerController.moviePlayer play];
    
    _moviePlayerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    
    _moviePlayerController.moviePlayer.shouldAutoplay = YES;
    
    _moviePlayerController.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
    
    [_moviePlayerController.moviePlayer prepareToPlay];
    
    
    [self presentMoviePlayerViewControllerAnimated:_moviePlayerController];
//    [self presentViewController:moviePlayerController animated:YES completion:nil];
    
    _moviePlayerController.view.transform = CGAffineTransformMakeRotation(M_PI/2);

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification object:_moviePlayerController.moviePlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerLoadStateChanged:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    
    
}

-(void)movieFinishedCallback:(NSNotification*)notify  {
//    [self dismissViewControllerAnimated:YES completion:nil];

    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未识别的网络");
                [self performSelector:@selector(showTips:) withObject:@"网络连接失败" afterDelay:1.0];
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"不可达的网络(未连接)");
                [self performSelector:@selector(showTips:) withObject:@"网络连接失败" afterDelay:1.0];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"2G,3G,4G...的网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"wifi的网络");
                break;
            default:
                break;
        }
    }];
    [manager startMonitoring];

    [self dismissMoviePlayerViewControllerAnimated];

}

//超时
-(void)moviePlayerLoadStateChanged:(NSNotification*)notify  {
    [self dismissMoviePlayerViewControllerAnimated];
}


- (IBAction)studyTourKnowledge:(UIButton *)sender {
    UIImageView * image = [self.view viewWithTag:11];
    [image setImage:[UIImage imageNamed:@"know_button.jpg"]];
    WebViewController *know = [[WebViewController alloc]init];
    
    [self.navigationController pushViewController:know animated:YES];
    
}

- (IBAction)checkTravel:(UIButton *)sender
{
    UIImageView * image = [self.view viewWithTag:12];
    [image setImage:[UIImage imageNamed:@"know_button.jpg"]];
    MyTravelController *mytravel = [[MyTravelController alloc]init];
    [self.navigationController pushViewController:mytravel animated:YES];
    
}

- (IBAction)safeTest:(UIButton *)sender {
    UIImageView * image = [self.view viewWithTag:14];
    [image setImage:[UIImage imageNamed:@"know_button.jpg"]];
    CheckQuestionController *questionview = [[CheckQuestionController alloc]init];
    [self.navigationController pushViewController:questionview animated:YES];

}

- (IBAction)safeVideo:(UIButton *)sender {
    UIImageView * image = [self.view viewWithTag:13];
    [image setImage:[UIImage imageNamed:@"know_button.jpg"]];
    PlayerController *pvvc = [[PlayerController alloc] init];
    pvvc.isPlay = YES;
//    pvvc.myvc = self;
    [self.navigationController pushViewController:pvvc animated:YES];
//    [self jumpToPlayVideo];
}

- (IBAction)KnowledgeDown:(UIButton *)sender
{
    UIImageView * image = [self.view viewWithTag:11];
    [image setImage:[UIImage imageNamed:@"know_button_hight.jpg"]];
}

- (IBAction)checkTravelDown:(UIButton *)sender
{
    UIImageView * image = [self.view viewWithTag:12];
    [image setImage:[UIImage imageNamed:@"know_button_hight.jpg"]];
}


- (IBAction)safeTestDown:(UIButton *)sender
{
    UIImageView * image = [self.view viewWithTag:14];
    [image setImage:[UIImage imageNamed:@"know_button_hight.jpg"]];
}

- (IBAction)safeVideoDown:(UIButton *)sender
{
    UIImageView * image = [self.view viewWithTag:13];
    [image setImage:[UIImage imageNamed:@"know_button_hight.jpg"]];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //统计进入须知次数
    [MobClick event:Click_Notice_Count];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
