//
//  WJPCreateQRCodeView.m
//  StudyTour
//
//  Created by use on 16/6/17.
//  Copyright © 2016年 魏鹏. All rights reserved.
//

#import "WJPCreateQRCodeView.h"
#import "NSString+Base64.h"

@interface WJPCreateQRCodeView ()

@property (nonatomic, weak) UIImageView *jp_imageView;
@property (nonatomic, weak) UIView *jp_contentView;

@end

@implementation WJPCreateQRCodeView

- (instancetype)init
{
    if (self = [super init]) {
        [self initViewConfig];
    }
    return self;
}

- (void)initViewConfig {
    self.frame = [UIScreen mainScreen].bounds;
    self.alpha = 0.1;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    if (_jp_contentView == nil) {
        UIView *contentView = [[UIImageView alloc] init];
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.layer.cornerRadius = 10;
        contentView.frame = CGRectMake(0, 0, ScreenWidth-75, (ScreenWidth-75)*7.0/6);
        contentView.center = self.center;
        [self addSubview:contentView];
        _jp_contentView = contentView;
    }
    
    if (_jp_imageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0, 0, 200, 200);
        imageView.center = CGPointMake(_jp_contentView.frame.size.width*0.5, _jp_contentView.frame.size.height*0.5);
        NSLog(@"%@\n%@", NSStringFromCGPoint(imageView.center), NSStringFromCGPoint(_jp_contentView.center));
        [_jp_contentView addSubview:imageView];
        _jp_imageView = imageView;
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 0, 150, 30);
        label.text = @"我的二维码";
        label.font = [UIFont systemFontOfSize:20];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor themeColor];
        label.center = CGPointMake(_jp_contentView.frame.size.width*0.5, _jp_contentView.frame.size.height-40);
        [_jp_contentView addSubview:label];
    }
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(ScreenWidth*0.5-30, ScreenHeight-100-30, 60, 60);
    [cancleButton addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
    [cancleButton setImage:[UIImage imageNamed:@"menu_qr_close"] forState:UIControlStateNormal];
    [self addSubview:cancleButton];
}

- (void)closeView:(UIButton *)sender
{
    if (self.closeBlock) {
        [UIView animateWithDuration:0.5f animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            self.closeBlock();
        }];
    }
}

- (void)setQRCodeInfo:(NSString *)QRCodeInfo
{
    _QRCodeInfo = QRCodeInfo;
    [self createQRCode];
}

#pragma mark -- 生成二维码
- (void)createQRCode {
    // 1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认
    [filter setDefaults];
    // 3.给过滤器添加数据
    NSString *dataString = [_QRCodeInfo base64EncodedString];
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    // 4.设置纠错级别
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    // 5.通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 6.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    // 7.将CIImage转换成UIImage，并放大显示
    UIImage *image =  [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];
    _jp_imageView.image = image;
}

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}


- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [UIView animateWithDuration:0.5f animations:^{
        self.alpha = 1;
    }];
}

- (void)dealloc
{
    NSLog(@"dealloc");
}

@end
