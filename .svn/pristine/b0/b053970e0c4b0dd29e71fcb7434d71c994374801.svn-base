//
//  WJPPhotoCollectionCell.m
//  StudyTourLeaderSide
//
//  Created by use on 16/5/17.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import "WJPPhotoCollectionCell.h"
//#import "WJPWriteTemplateImageModel.h"

//#import "HZIndicatorView.h"

#import <objc/runtime.h>

@interface WJPPhotoCollectionCell () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, strong) UIButton *reloadButton;

@end

@implementation WJPPhotoCollectionCell

- (void)awakeFromNib {
    // Initialization code
    _scrollView.delegate = self;
}

- (void)setImageInfo:(id)imageInfo
{
    if (_imageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [_scrollView addSubview:imageView];
        imageView.backgroundColor = [UIColor lightGrayColor];
        _imageView = imageView;
    }
    
    _scrollView.zoomScale = 1;
    _imageInfo = imageInfo;
    
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    if ([_imageInfo isKindOfClass:[NSString class]]) {
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:_imageInfo];
//        NSNumber *orientation = objc_getAssociatedObject(_imageInfo, "ImageOrientation");
//        image = [UIImage imageWithCGImage:image.CGImage scale:1 orientation:[orientation integerValue]];
        _imageView.image = image;
        [self updateImageViewFrameWithImage:image];
    }
}


- (void)updateImageViewFrameWithImage:(UIImage *)image
{
    CGFloat screenWidth = ScreenWidth;
    CGFloat screenHeight = ScreenHeight - 64;
    
    CGFloat placeImageSizeW = image.size.width;
    CGFloat placeImageSizeH = image.size.height;
    if (placeImageSizeH <= 0 || placeImageSizeW <= 0) {
        return;
    }
    
    CGRect targetTemp;
    CGFloat placeHolderH = (placeImageSizeH * screenWidth)/placeImageSizeW;
    CGFloat placeHolderW = (placeImageSizeW * screenHeight)/placeImageSizeH;
    if (placeHolderH <= screenHeight) {
        targetTemp = CGRectMake(0, (screenHeight - placeHolderH) * 0.5 , screenWidth, placeHolderH);
    } else {
        targetTemp = CGRectMake((screenWidth - placeHolderW) * 0.5, 0, placeHolderW, screenHeight);
    }
    _imageView.frame = targetTemp;
}

#pragma mark -- UIScroll View Delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    NSLog(@"---------%f--------", scrollView.zoomScale);
    NSLog(@"%@", NSStringFromCGRect(_imageView.frame));
}

@end