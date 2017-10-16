//
//  WJPCreateQRCodeView.h
//  StudyTour
//
//  Created by use on 16/6/17.
//  Copyright © 2016年 魏鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CloseBlock)();

@interface WJPCreateQRCodeView : UIView

@property (nonatomic, copy) NSString *QRCodeInfo;

@property (nonatomic, copy) CloseBlock closeBlock;

- (void)setCloseBlock:(CloseBlock)closeBlock;

@end
