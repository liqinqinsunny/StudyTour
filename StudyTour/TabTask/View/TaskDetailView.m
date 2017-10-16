//
//  TaskDetailView.m
//  StudyTour
//
//  Created by use on 15/12/14.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import "TaskDetailView.h"
#import "NSString+Frame.h"
#import "TaskDetailModel.h"
#import "UserInfo.h"
#import "Downloader.h"

@interface TaskDetailView ()

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *desImage;

@property (weak, nonatomic) IBOutlet UIImageView *a_image;
@property (weak, nonatomic) IBOutlet UILabel *a_label;
@property (weak, nonatomic) IBOutlet UIImageView *b_image;
@property (weak, nonatomic) IBOutlet UILabel *b_label;
@property (weak, nonatomic) IBOutlet UIImageView *c_image;
@property (weak, nonatomic) IBOutlet UILabel *c_label;
@property (weak, nonatomic) IBOutlet UIImageView *d_image;
@property (weak, nonatomic) IBOutlet UILabel *d_label;

@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@property (weak, nonatomic) IBOutlet UIView *desView;

@property (weak, nonatomic) IBOutlet UIButton *a_button;
@property (weak, nonatomic) IBOutlet UIButton *b_button;
@property (weak, nonatomic) IBOutlet UIButton *c_button;
@property (weak, nonatomic) IBOutlet UIButton *d_button;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageAboutConstraint;

@property (nonatomic, copy) NSArray *images;


@property (assign, nonatomic) CGFloat curHeight;
@end

@implementation TaskDetailView

- (void)awakeFromNib
{
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-42);
    _images = @[_a_image, _b_image, _c_image, _d_image];
}

- (void)setModel:(TaskDetailModel *)model
{
    if (model == nil) {
        return;
    }
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
    
    _model = model;
    
    _questionLabel.text = model.taskQ;
    _a_label.text = model.taskA[@"1"];
    _b_label.text = model.taskA[@"2"];
    _c_label.text = model.taskA[@"3"];
    _d_label.text = model.taskA[@"4"];
    
    if (_a_label.text == nil) {
        _a_label.hidden = YES;
        _a_image.hidden = YES;
        _a_button.hidden = YES;
    } else {
        _a_label.hidden = NO;
        _a_image.hidden = NO;
        _a_button.hidden = NO;
    }
    if (_b_label.text == nil) {
        _b_label.hidden = YES;
        _b_image.hidden = YES;
        _b_button.hidden = YES;
    } else {
        _b_label.hidden = NO;
        _b_image.hidden = NO;
        _b_button.hidden = NO;
    }
    if (_c_label.text == nil) {
        _c_label.hidden = YES;
        _c_image.hidden = YES;
        _c_button.hidden = YES;
    } else {
        _c_label.hidden = NO;
        _c_image.hidden = NO;
        _c_button.hidden = NO;
    }
    if (_d_label.text == nil) {
        _d_label.hidden = YES;
        _d_image.hidden = YES;
        _d_button.hidden = YES;
    } else {
        _d_label.hidden = NO;
        _d_image.hidden = NO;
        _d_button.hidden = NO;
    }

    _desLabel.text = model.taskAnalysis;

    CGFloat qh = [_model.taskQ heightWithFont:[UIFont systemFontOfSize:17] withinWidth:[UIScreen mainScreen].bounds.size.width-40];
    base += 12;
    CGFloat ah = [_model.taskA[@"1"] heightWithFont:[UIFont systemFontOfSize:17] withinWidth:[UIScreen mainScreen].bounds.size.width-40];
    base += 17;
    CGFloat bh = [_model.taskA[@"2"] heightWithFont:[UIFont systemFontOfSize:17] withinWidth:[UIScreen mainScreen].bounds.size.width-40];
    base += 17;
    CGFloat ch = [_model.taskA[@"3"] heightWithFont:[UIFont systemFontOfSize:17] withinWidth:[UIScreen mainScreen].bounds.size.width-40];
    base += 17;
    CGFloat dh = [_model.taskA[@"4"] heightWithFont:[UIFont systemFontOfSize:17] withinWidth:[UIScreen mainScreen].bounds.size.width-40];
    base += 20;
    base += 41;
    CGFloat jiexih = [_model.taskAnalysis heightWithFont:[UIFont systemFontOfSize:17] withinWidth:[UIScreen mainScreen].bounds.size.width-40];
    base += 20;
//    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, base + qh + ah + bh + ch + dh + jiexih+20);
    
    _curHeight = base + qh + ah + bh + ch + dh + jiexih+20;
    
    // 本地保存的当前答案是 0 1 2 3
    // 网络保存的当前答案是 1 2 3 4
    // 所以要做相应的     +1 or -1
    if ([model.answer isEqualToString:@"1"]) {
        UIButton *btn = (UIButton *)[self viewWithTag:10];
        [self selectAnswer:btn];
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, base + qh + ah + bh + ch + dh + jiexih+20);
        return;
    } else if ([model.answer isEqualToString:@"2"]) {
        UIButton *btn = (UIButton *)[self viewWithTag:11];
        [self selectAnswer:btn];
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, base + qh + ah + bh + ch + dh + jiexih+20);
        return;
    } else if ([model.answer isEqualToString:@"3"]) {
        UIButton *btn = (UIButton *)[self viewWithTag:12];
        [self selectAnswer:btn];
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, base + qh + ah + bh + ch + dh + jiexih+20);
        return;
    } else if ([model.answer isEqualToString:@"4"]) {
        UIButton *btn = (UIButton *)[self viewWithTag:13];
        [self selectAnswer:btn];
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, base + qh + ah + bh + ch + dh + jiexih+20);
        return;
    }
    
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    NSString *myKey = [NSString stringWithFormat:@"%@-%@-%@", userInfo.userId, _taskId, _model.topicId];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:myKey] == nil) {
        _desView.hidden = YES;
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, base + qh + ah + bh + ch + dh + _imageAboutConstraint.constant);
    } else {
        NSString *curAStr = [[NSUserDefaults standardUserDefaults] objectForKey:myKey];
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, base + qh + ah + bh + ch + dh + jiexih+20 + _imageAboutConstraint.constant);
        NSInteger curA = [curAStr integerValue];
        UIButton *btn = (UIButton *)[self viewWithTag:curA+10];
        [self selectAnswer:btn];
    }
}

- (IBAction)selectAnswer:(UIButton *)sender {
    _model.curA = sender.tag - 10;
    for (NSInteger i = 10; i < 14; ++i) {
        UIButton *btn = (UIButton *)[self viewWithTag:i];
        btn.userInteractionEnabled = NO;
    }
    
    UIImageView *imageView = _images[sender.tag-10];
    if (sender.tag-10 == [_model.taskCorrectA integerValue] || _model.taskCorrectA == nil) {
        imageView.image = [UIImage imageNamed:@"Rounded-right"];
    }
    else {
        imageView.image = [UIImage imageNamed:@"Rounded-wrong"];
        UIImageView *imageView1 = _images[[_model.taskCorrectA integerValue]];
        imageView1.image = [UIImage imageNamed:@"Rounded-right"];
    }
    
    [UIView animateWithDuration:1.0 animations:^{
        _desView.hidden = NO;
        if (self.taskClickedBlock) {
            self.taskClickedBlock(_curHeight);
        }
    }];

    UserInfo *userInfo = [UserInfo sharedUserInfo];
    NSString *myKey = [NSString stringWithFormat:@"%@-%@-%@", userInfo.userId, _taskId, _model.topicId];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:myKey] != nil) {
        return;
    }

    NSString *curAStr = [NSString stringWithFormat:@"%ld", _model.curA+1];
    NSDictionary *param = @{@"userId":userInfo.userId,
                            @"topicId":_model.topicId,
                            @"taskId":_taskId,
                            @"taskState":@"1",
                            @"tokenId":userInfo.tokenId,
                            @"answer":curAStr};
    NSLog(@"提交题目数据%@", param);
    Downloader *downloader = [[Downloader alloc] init];
    [downloader POST:TaskSubmitURL param:param wating:^{
        
    } fail:^{
        
    } success:^(NSDictionary *originData) {
        NSLog(@"题目提交成功 -> %@", originData);
//        NSString *myKey = [NSString stringWithFormat:@"%@-%@-%@", userInfo.userId, _taskId, _model.topicId];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", sender.tag - 10] forKey:myKey];
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
