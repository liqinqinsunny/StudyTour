//
//  SingleSelectView.m
//  StudyTour
//
//  Created by use on 15/12/17.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import "SingleSelectView.h"
#import "NSString+Frame.h"

//#define ScreenWidth [UIScreen mainScreen].bounds.size.width
//#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define INTERVAL 20
#define MiniInterval 8
#define TitleFontSize 12
#define TitleLabelHeight (TitleFontSize+4)

#define subTitleFontSize 10
#define subTitleLabelHeight (subTitleFontSize+4)

@interface SingleSelectView ()<UITextFieldDelegate>
{
    CGFloat _titleBottom;
    CGFloat _finalY;
}

@property (nonatomic, copy) NSString *otherStr;
//@property (nonatomic, copy) NSArray *selectArr;
//@property (nonatomic, copy) NSArray *specialSelectArr;

@end


@implementation SingleSelectView

- (instancetype)init
{
    if (self = [super init]) {
//        _selectArr = [[NSMutableArray alloc]init];
//        _selectArr = @[@"非常满意", @"满意", @"不满意,原因:"];
//        _specialSelectArr = @[@"参观名校、与校方代表交流院系设置及录取条件等",
//                       @"参加名校教育专家留学说明会、吸取留学申请经验",
//                       @"观摩(或旁听)美国本科生课程(纯英文授课，对语言水平要求较高，有可能听不懂)"];
    }
    return self;
}


- (void)setTheTitle:(NSString *)theTitle
{
    NSString * lastStr = [self.selectArr lastObject];
    if (lastStr.length > 10) {
        _type = 2;
    }
    
    _theTitle = theTitle;
    
    NSArray *curArr = _selectArr;
    
    CGFloat titleWidth = [theTitle widthWithFont:[UIFont boldSystemFontOfSize:TitleFontSize]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(INTERVAL, INTERVAL, titleWidth, TitleLabelHeight)];
    label.text = theTitle;
    label.font = [UIFont boldSystemFontOfSize:TitleFontSize];
    [self addSubview:label];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(INTERVAL+titleWidth+2, INTERVAL+2, 34, subTitleLabelHeight)];
    label2.textAlignment = NSTextAlignmentLeft;
    label2.font = [UIFont systemFontOfSize:subTitleFontSize];
    if (_type == 0 || _type == 2) {
        label2.textColor = [UIColor redColor];
        label2.text = @"必答";
        [self addSubview:label2];
    }
//    else if (_type == 1) {
//        label2.textColor = [UIColor blackColor];
//        label2.text = @"(若有)";
//        [self addSubview:label2];
//    }
//    else {
//        curArr = _specialSelectArr;
//    }
    
    _titleBottom = INTERVAL+TitleLabelHeight+INTERVAL;
    
    CGFloat width = ScreenWidth-INTERVAL*2;
    CGFloat cur_y = _titleBottom;
    for (NSInteger i = 0; i < curArr.count; ++i) {
        [_anwserDict setValue:@"0" forKey:[NSString stringWithFormat:@"%ld", i+1]];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(INTERVAL, cur_y-4, 24, 24);
        btn.tag = 100+i;
        [btn setImage:[UIImage imageNamed:@"round"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"round-green"] forState:UIControlStateSelected];
        
        [btn addTarget:self action:@selector(singleSelect:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        NSString *str = curArr[i];
        CGFloat lw = [str widthWithFont:[UIFont systemFontOfSize:TitleFontSize]];
        UILabel *label = [[UILabel alloc] init];
        CGFloat labelWidth = (i == curArr.count-1 && _type != 2) ? lw : width;
        CGFloat labelHeight = (i == curArr.count-1 && _type == 2) ? TitleLabelHeight*2-2 : TitleLabelHeight;
        label.frame = CGRectMake(INTERVAL+btn.frame.size.width+5, cur_y, labelWidth, labelHeight);
        label.font = [UIFont systemFontOfSize:TitleFontSize];
        label.numberOfLines =  (i == curArr.count-1 && _type == 2) ? 2 : 1;
        label.text = curArr[i];
        [self addSubview:label];
        
        if (i == curArr.count-1 && _type != 2) {
            UITextField *textF = [[UITextField alloc] init];
            textF.delegate = self;
            CGFloat t_x = label.frame.origin.x+label.frame.size.width+MiniInterval;
            textF.frame = CGRectMake(t_x, cur_y, ScreenWidth-INTERVAL-t_x, 20);
            textF.tag = 55;
            textF.borderStyle = UITextBorderStyleLine;
            [self addSubview:textF];
        }
        
        cur_y += (labelHeight+INTERVAL);
        
        if (_type == 2 && i == curArr.count-1) {
            NSString *str = @"你的期待和意见";
            CGFloat lw = [str widthWithFont:[UIFont systemFontOfSize:TitleFontSize]];
            UILabel *label = [[UILabel alloc] init];
            label.frame = CGRectMake(INTERVAL+btn.frame.size.width+5, cur_y, lw, TitleLabelHeight);
            label.font = [UIFont systemFontOfSize:TitleFontSize];
            label.numberOfLines = 2;
            label.text = str;
            [self addSubview:label];
            
            UITextField *textF = [[UITextField alloc] init];
            textF.delegate = self;
            CGFloat t_x = label.frame.origin.x+label.frame.size.width+MiniInterval;
            textF.frame = CGRectMake(t_x, cur_y, ScreenWidth-INTERVAL-t_x, 20);
            textF.tag = 55;
            textF.borderStyle = UITextBorderStyleLine;
            [self addSubview:textF];
            
            cur_y += (INTERVAL + 19);
        }
    }
    
    
    UIView *underLine = [[UIView alloc] init];
    underLine.frame = CGRectMake(INTERVAL, cur_y, width, 1);
    underLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:underLine];
    
    _finalY = cur_y+1;
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, _finalY);
}

- (void)singleSelect:(UIButton *)sender
{
    if (sender.selected) {
        return;
    }
    for (NSInteger i = 0; i < 3; ++i) {
        [_anwserDict setValue:@"0" forKey:[NSString stringWithFormat:@"%ld", i+1]];
        UIButton *btn = (UIButton *)[self viewWithTag:100+i];
        btn.selected = NO;
    }
    NSInteger selectIndex = sender.tag-100;
    NSString * selectAns = [self.selectArr objectAtIndex:selectIndex];
    
    sender.selected = YES;
    [_anwserDict setValue:selectAns forKey:[NSString stringWithFormat:@"%ld", sender.tag-99]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITextField *tf = (UITextField *)[self viewWithTag:55];
    _otherStr = tf.text;
    if (![tf.text isEqualToString:@""]) {
        [_anwserDict setValue:tf.text forKey:@"Other"];
    } else {
        [_anwserDict setValue:@"无" forKey:@"Other"];
    }
    [tf resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    _otherStr = textField.text;
    if (![textField.text isEqualToString:@""]) {
        [_anwserDict setValue:textField.text forKey:@"Other"];
    } else {
        [_anwserDict setValue:@"无" forKey:@"Other"];
    }
    
    return YES;
}

@end
