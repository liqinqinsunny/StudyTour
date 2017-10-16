//
//  WriteWordsOfTravelNoteViewController.m
//  StudyTour
//
//  Created by use on 16/7/8.
//  Copyright © 2016年 魏鹏. All rights reserved.
//

#import "WriteWordsOfTravelNoteViewController.h"
#import "WJPLineTextView.h"

@interface WriteWordsOfTravelNoteViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet WJPLineTextView *contentTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewBottomToSuperBottomConstraint;
@property (nonatomic, assign) BOOL isChanged;
@end

@implementation WriteWordsOfTravelNoteViewController

#pragma mark -- UIText View Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self changeFont];
    return YES;
}

#pragma mark -- 保存游记文字
- (void)saveWordsOfTravelNote
{
    _dataModel.content = _contentTextView.text;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeFont
{
    if (_isChanged) {
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.lineSpacing = 18;// 字体的行间距
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSForegroundColorAttributeName:[UIColor colorWithHex:0x383838],
                                 NSParagraphStyleAttributeName:paragraphStyle};
    
    _contentTextView.attributedText = [[NSAttributedString alloc] initWithString:_contentTextView.text attributes:attributes];
    
    _isChanged = YES;
}

#pragma mark -- LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"随手记";
    _contentTextView.contentMode = UIViewContentModeRedraw;
    _contentTextView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    //保存
    UIBarButtonItem *itemSaveBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveWordsOfTravelNote)];
    self.navigationItem.rightBarButtonItem = itemSaveBtn;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_contentString.length <= 0) {
        _contentTextView.text = @"写点什么吧";
    } else {
        _contentTextView.text = _contentString;
    }
    
    [self changeFont];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSNotificationCenter *notifiCenter = [NSNotificationCenter defaultCenter];
    [notifiCenter addObserver:self selector:@selector(jp_KeyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [notifiCenter addObserver:self selector:@selector(jp_KeyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    NSNotificationCenter *notifiCenter = [NSNotificationCenter defaultCenter];
    [notifiCenter removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 键盘弹出/消失事件
- (void)jp_KeyBoardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSNumber *bValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDur = [bValue floatValue];
    
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int kbheight = keyboardRect.size.height;
    
    [UIView animateWithDuration:animationDur animations:^{
        _textViewBottomToSuperBottomConstraint.constant =  kbheight;
    }];
}

- (void)jp_KeyBoardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    id bValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDur = [bValue floatValue];
    [UIView animateWithDuration:animationDur animations:^{
        _textViewBottomToSuperBottomConstraint.constant =  8;
    }];
}

@end
