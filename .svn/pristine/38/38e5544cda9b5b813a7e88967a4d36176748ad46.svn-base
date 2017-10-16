//
//  LineImagesGroupView.m
//  ImgScrollView
//
//  Created by jeremy on 16/5/14.
//  Copyright © 2016年 lqq. All rights reserved.
//

#import "LineImagesGroupView.h"
#import "HZPhotoBrowser.h"
#import "UIButton+WebCache.h"
#import "HZPhotoItemModel.h"
#import "ParticularsesImages.h"
@interface LineImagesGroupView()<HZPhotoBrowserDelegate>

@end

@implementation LineImagesGroupView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    long imageCount = self.photoItemArray.count;
    __block CGFloat conW = 0;
    if (imageCount > 1) {
        [self.subviews enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat y = 0;
            CGFloat w = self.imgW;
            CGFloat h = self.imgH;
            CGFloat x = (w + self.imgMargin) * idx - self.imgMargin;
            btn.frame = CGRectMake(x, y, w, h);
        }];
        conW = self.imgW * imageCount + self.imgMargin * (imageCount - 2);
        self.contentSize = CGSizeMake(conW, self.frame.size.height);
    }else
    {
        UIButton *btn = self.subviews[0];
        CGFloat x = ( self.frame.size.width - self.imgW - self.frame.origin.x) * 0.5 ;
        CGFloat y = 0;
        CGFloat w = self.imgW;
        CGFloat h = self.imgH;
        btn.frame  = CGRectMake(x, y, w, h);
        self.contentSize = self.frame.size;
    }
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 清除图片缓存，便于测试
//        [[SDWebImageManager sharedManager].imageCache clearDisk];
    }
    return self;
}

- (void)setPhotoItemArray:(NSArray *)photoItemArray
{
    _photoItemArray = photoItemArray;
    [photoItemArray enumerateObjectsUsingBlock:^(ParticularsesImages *obj, NSUInteger idx, BOOL *stop) {
        UIButton *btn = [[UIButton alloc] init];
        
        //让图片不变形，以适应按钮宽高，按钮中图片部分内容可能看不到
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        btn.clipsToBounds = YES;
        [btn sd_setImageWithURL:[NSURL URLWithString:obj.imageThumbnailUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"traveldetails_img"]];

        btn.tag = idx;
        
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }];
}


- (void)buttonClick:(UIButton *)button
{
    //启动图片浏览器
    HZPhotoBrowser *browserVc = [[HZPhotoBrowser alloc] init];
    browserVc.sourceImagesContainerView = self; // 原图的父控件
    browserVc.imageCount = self.photoItemArray.count; // 图片总数
    browserVc.currentImageIndex = (int)button.tag;
    browserVc.delegate = self;
    [browserVc show];
}


#pragma mark - photobrowser代理方法

- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = [self.photoItemArray[index] imageUrl];
    return [NSURL URLWithString:urlStr];
}

@end
