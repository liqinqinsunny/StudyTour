//
//  KnowTopicView.m
//  StudyTour
//
//  Created by use on 15/12/15.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import "KnowTopicView.h"
#import "TaskDetailModel.h"
#import "NSString+Frame.h"
#import "Downloader.h"
#import "UserInfo.h"

@interface KnowTopicView ()
@property (weak, nonatomic) IBOutlet UIImageView *desImage;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;

@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@property (weak, nonatomic) IBOutlet UIView *desView;

@property (weak, nonatomic) IBOutlet UIButton *knowButton;

@property (assign, nonatomic) CGFloat curHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageAboutConstraint;
@end

@implementation KnowTopicView

- (void)setModel:(TaskDetailModel *)model
{
    if (model == nil) {
        return;
    }
    _model = model;
    
    CGFloat base = 20;
    
    _imageAboutConstraint.constant = 8+20+(ScreenWidth-20*2)*0.6;
    _desImage.hidden = NO;
    if (model.imageUrl == nil || [model.imageUrl isEqualToString:@""]) {
        _imageAboutConstraint.constant = 20;
        _desImage.hidden = YES;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@", ImageBaseUrl, model.imageUrl];
    [_desImage sd_setImageWithURL:[NSURL URLWithString:urlString]];
    
    base += _imageAboutConstraint.constant;
    
    
    _questionLabel.text = model.taskQ;
    
    _desLabel.text = model.taskAnalysis;
    
    CGFloat qh = [_model.taskQ heightWithFont:[UIFont systemFontOfSize:17] withinWidth:[UIScreen mainScreen].bounds.size.width-40];
    base += 40;
    base += (ScreenWidth-160)*0.25;
    base += 30;
    base += 41;
    CGFloat jiexih = [_model.taskAnalysis heightWithFont:[UIFont systemFontOfSize:17] withinWidth:[UIScreen mainScreen].bounds.size.width-40];
//        NSLog(@"%f", jiexih);
    base += 20;
    base += 20;
//    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, base + qh + jiexih);
    //新添加的，有问题 删掉
    _curHeight = base+qh+jiexih;
    
    BOOL state = [model.taskState isEqualToString:@"1"];
    
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    NSString *myKey = [NSString stringWithFormat:@"%@-%@-%@", userInfo.userId, _taskId, _model.topicId];
    if (state == NO && [[NSUserDefaults standardUserDefaults] objectForKey:myKey] == nil) {
        _desView.hidden = YES;
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, base + qh);
    } else {
        _knowButton.selected = YES;
        _knowButton.userInteractionEnabled = NO;
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, base + qh + jiexih);
    }
}

- (IBAction)knowMoreBtn:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    sender.selected = YES;
    [UIView animateWithDuration:1.0 animations:^{
        _desView.hidden = NO;
        if (self.taskClickedBlock) {
            self.taskClickedBlock(_curHeight);
        }
    }];
    UserInfo *userInfo = [UserInfo sharedUserInfo];
//    NSString *myKey = [NSString stringWithFormat:@"%@-%@-%@", userInfo.userId, _taskId, _model.topicId];
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:myKey] != nil) {
//        return;
//    }
    NSDictionary *param = @{@"userId":userInfo.userId,
                            @"topicId":_model.topicId,
                            @"taskId":_taskId,
                            @"taskState":@"1",
                            @"tokenId":userInfo.tokenId,
                            @"answer":@"0"};
    Downloader *downloader = [[Downloader alloc] init];
    [downloader POST:TaskSubmitURL param:param wating:^{
        
    } fail:^{
        
    } success:^(NSDictionary *originData) {
        NSLog(@"题目提交成功 -> %@", originData);
        NSString *myKey = [NSString stringWithFormat:@"%@-%@-%@", userInfo.userId, _taskId, _model.topicId];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:myKey];
        if (self.taskStateBlock) {
            self.taskStateBlock();
        }
    } refresh:YES];
}

- (void)setPosition:(NSString *)position
{
//    _numLabel.text = position;
}

@end
