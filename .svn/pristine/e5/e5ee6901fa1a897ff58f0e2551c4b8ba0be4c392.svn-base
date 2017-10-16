//
//  OpinionDetailController.m
//  StudyTour
//
//  Created by use on 15/12/16.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import "OpinionDetailController.h"
#import "Downloader.h"
#import "UserInfo.h"

@interface OpinionDetailController ()<UITextViewDelegate>
{
    NSArray *_scoreArr;
}
@property (weak, nonatomic) IBOutlet UITextView *myTextView;

@property (nonatomic, copy) NSMutableArray *satisfiedArr;

@end

@implementation OpinionDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"每日评价";
    
    _satisfiedArr = [@[@(0), @(0), @(0), @(0)] mutableCopy];
    _scoreArr = @[@"eat", @"chu", @"live", @"leader"];
}

- (IBAction)satisfied:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    UIButton *btn = (UIButton *)[self.view viewWithTag:sender.tag%2==0?sender.tag+1:sender.tag-1];
    btn.selected = !btn.selected;
    sender.selected = !sender.selected;
    
    _satisfiedArr[sender.tag/10-1] = @(sender.tag%10);
    NSLog(@"%@", NSStringFromClass([_satisfiedArr[0] class]));
    NSLog(@"%@", _satisfiedArr);
}


- (IBAction)submit:(UIButton *)sender {
    //统计提交反馈
    [MobClick event:Click_Task_Feedback_Count];
    
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"" forKey:@"score"];
    [dict setValue:userInfo.group forKey:@"groupId"];
    [dict setValue:userInfo.tokenId forKey:@"tokenId"];
    [dict setValue:userInfo.userId forKey:@"userId"];
    NSString *assessIdKey = [NSString stringWithFormat:@"assessId%@", userInfo.userId];
    NSString *assessId = [[NSUserDefaults standardUserDefaults] objectForKey:assessIdKey];
    [dict setValue:assessId forKey:@"assessId"];
    [dict setValue:userInfo.cardId forKey:@"cardId"];
    for (NSInteger i = 0; i < 4; ++i) {
        [dict setValue:_satisfiedArr[i] forKey:_scoreArr[i]];
    }
    [dict setValue:_myTextView.text forKey:@"comment"];
    NSLog(@"%@", dict);
    Downloader *odcDownloader = [[Downloader alloc] init];
    [odcDownloader POST:FeedBackSubmitURL param:dict wating:^{
        
    } fail:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showTips:SubmitDataFailTips];
        });
        
        
    } success:^(NSDictionary *originData) {

        if ([originData[@"cardId"] isEqualToString:@"0"] || originData[@"error"] != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showTips:SubmitDataFailTips];
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showTips:SubmitDataSuceesTips];
            });
            
            double delayInSeconds = 1.2;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                NSString *opinionStateKey = [NSString stringWithFormat:@"OpinionState%@", userInfo.userId];
                [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:opinionStateKey];
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } refresh:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_myTextView resignFirstResponder];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    CGRect oldFrame = self.view.frame;
    CGRect newFrame = CGRectMake(0, -200, oldFrame.size.width, oldFrame.size.height);
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = newFrame;
    }];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    CGRect oldFrame = self.view.frame;
    CGRect newFrame = CGRectMake(0, 0, oldFrame.size.width, oldFrame.size.height);
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = newFrame;
    }];
    NSLog(@"1111");
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //统计满意
    [MobClick event:Click_Task_Url_Count];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
