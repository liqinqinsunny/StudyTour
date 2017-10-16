//
//  MultiSelectView.m
//  StudyTour
//
//  Created by use on 15/12/17.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import "MultiSelectView.h"
#import "NSString+Frame.h"

#define INTERVAL 20
#define MiniInterval 8
#define TitleFontSize 13
#define TitleLabelHeight (TitleFontSize+4)
#define subTitleFontSize 10
#define subTitleLabelHeight (subTitleFontSize+4)

@interface MultiSelectView ()<UITextFieldDelegate>
{
    CGFloat _titleBottom;
    CGFloat _finalY;
}

@property (nonatomic, copy) NSString *otherStr;

@end

@implementation MultiSelectView

- (instancetype)init
{
    if (self = [super init]) {
//        _dataArr = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)setTheTitle:(NSString *)theTitle
{
    _theTitle = theTitle;
    CGFloat width = [theTitle widthWithFont:[UIFont boldSystemFontOfSize:TitleFontSize]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(INTERVAL, INTERVAL, width, TitleLabelHeight)];
    label.text = theTitle;
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize:TitleFontSize];
    [self addSubview:label];
    
//    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(INTERVAL+width, INTERVAL+2, 45, subTitleLabelHeight)];
//    label1.text = @"(可多选)";
//    label1.font = [UIFont systemFontOfSize:subTitleFontSize];
//    [self addSubview:label1];
    if (_selelctType == 0) {
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(INTERVAL+width+2, INTERVAL+2, 30, subTitleLabelHeight)];
        label2.textColor = [UIColor redColor];
        label2.text = @"必答";
        label2.font = [UIFont systemFontOfSize:subTitleFontSize];
        [self addSubview:label2];
    }
    
    _titleBottom = INTERVAL+TitleLabelHeight+INTERVAL;
}

- (void)setDataArr:(NSArray *)dataArr
{
    _dataArr = [dataArr mutableCopy];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width-INTERVAL*2;
    CGFloat cur_y = _titleBottom;
    
    for (NSInteger i = 0; i <= dataArr.count; ++i) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(INTERVAL, cur_y-4, 24, 24);
        btn.tag = 100+i;
        
        [btn setImage:[UIImage imageNamed:@"square"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"square-green"] forState:UIControlStateSelected];
        
        [btn addTarget:self action:@selector(multiSelect:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        if (i == dataArr.count) {
            if(dataArr.count)
            {
                UILabel *label = [[UILabel alloc] init];
                NSString *str = @"其他";
                CGFloat lw = [str widthWithFont:[UIFont systemFontOfSize:TitleFontSize]];
                label.frame = CGRectMake(INTERVAL+btn.frame.size.width+5, cur_y, lw, TitleLabelHeight);
                label.font = [UIFont systemFontOfSize:TitleFontSize];
                label.text = str;
                [self addSubview:label];
                
                UITextField *textF = [[UITextField alloc] init];
                textF.delegate = self;
                CGFloat t_x = label.frame.origin.x+label.frame.size.width+MiniInterval;
                textF.frame = CGRectMake(t_x, cur_y, ScreenWidth-INTERVAL-t_x, 20);
                textF.tag = 55;
                textF.borderStyle = UITextBorderStyleLine;
                [self addSubview:textF];
                
                cur_y += (TitleLabelHeight+INTERVAL);
            }
            else{
                UITextField *textF = [[UITextField alloc] init];
                textF.delegate = self;
                CGFloat t_x = INTERVAL+btn.frame.size.width+5;
                textF.frame = CGRectMake(t_x, cur_y, ScreenWidth-INTERVAL-t_x, 20);
                textF.tag = 55;
                textF.borderStyle = UITextBorderStyleLine;
                [self addSubview:textF];
                
                cur_y += (TitleLabelHeight+INTERVAL);
            }
            break;
        }
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(INTERVAL+btn.frame.size.width+5, cur_y, width, TitleLabelHeight);
        label.font = [UIFont systemFontOfSize:TitleFontSize];
        label.text = dataArr[i];
        [self addSubview:label];
        
        cur_y += (TitleLabelHeight+INTERVAL);
    }
    
    UIView *underLine = [[UIView alloc] init];
    underLine.frame = CGRectMake(INTERVAL, cur_y, width, 1);
    underLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:underLine];
    
    _finalY = cur_y+1;
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, _finalY);
//    NSLog(@"_anwserDict%@", _anwserDict);
}

- (void)multiSelect:(UIButton *)sender
{
    sender.selected = !sender.selected;
    NSInteger selectIndex = sender.tag-100;
    NSString * selectAns = @"";
    if (selectIndex < self.dataArr.count) {
        selectAns = [self.dataArr objectAtIndex:selectIndex];
    }
    if (![selectAns isEqualToString:@""]) {
        [_anwserDict setValue:sender.isSelected ? selectAns : @"0" forKey:[NSString stringWithFormat:@"%ld", selectIndex + 1]];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITextField *tf = (UITextField *)[self viewWithTag:55];
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
    if (![textField.text isEqualToString:@""]) {
        [_anwserDict setValue:textField.text forKey:@"Other"];
    } else {
        [_anwserDict setValue:@"无" forKey:@"Other"];
    }
    
    return YES;
}



@end
