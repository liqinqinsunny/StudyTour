//
//  PlayerVedioController.m
//  StudyTour
//
//  Created by owen on 15/12/29.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import "PlayerVedioController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface PlayerVedioController ()

@end

@implementation PlayerVedioController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //统计视频页面
    [MobClick event:Click_Notice_Video_Count];
    
    NSURL *videoURL = [NSURL URLWithString:@"http://player.ku6.com/refer/mY3ATiYuOeucaA47uQhENQ../v.swf"];
    
    MPMoviePlayerViewController * moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
    
    [moviePlayerController.moviePlayer prepareToPlay];

    moviePlayerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    
    moviePlayerController.moviePlayer.shouldAutoplay = YES;
    
    moviePlayerController.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
    
    moviePlayerController.moviePlayer.repeatMode = MPMovieRepeatModeNone;
    
    [moviePlayerController.moviePlayer play];
//    [self presentModalViewController:moviePlayerController animated:YES];
//    [self presentViewController:moviePlayerController animated:NO completion:nil];
   
    [self presentMoviePlayerViewControllerAnimated:moviePlayerController];
    
    moviePlayerController.view.transform = CGAffineTransformMakeRotation(M_PI/2);
    
    //done
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieDoneCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerLoadStateChanged:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];

    
    //获得时长
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerLoadStateChanged:) name:MPMovieDurationAvailableNotification object:nil];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)movieDoneCallback:(NSNotification*)notify  {
    
    NSNumber * number = notify.userInfo[@"MPMoviePlayerPlaybackDidFinishReasonUserInfoKey"];
    if ([number intValue] == MPMovieFinishReasonPlaybackEnded) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_myvc showTips:VideoFinished];
        });
    }
    else if([number intValue] == MPMovieFinishReasonPlaybackError)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_myvc showTips:NetWorkTips];
        });
    }
    else if([number intValue] == MPMovieFinishReasonUserExited)
    {
        
    }
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
