//
//  ImageSlideView.m
//  StudyTour
//
//  Created by Apple on 16/6/1.
//  Copyright © 2016年 lqq. All rights reserved.
//

#import "ImageSlideView.h"
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"
@interface ImageSlideView()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageView;

@end

@implementation ImageSlideView

- (void)setImages:(NSArray *)images
{
    _images = images;
    
    [images enumerateObjectsUsingBlock:^(NSString *url, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIImageView *imgView = [[UIImageView alloc]init];
        [imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"mainbg_default"]];
        [self.scrollView addSubview:imgView];
        
    }];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.subviews enumerateObjectsUsingBlock:^(UIImageView *imgView, NSUInteger idx, BOOL * _Nonnull stop) {
        imgView.width = self.scrollView.width;
        imgView.height = self.scrollView.height;
        imgView.x = self.width * idx;
        imgView.y = 0;
    }];
    
    CGFloat w = self.scrollView.width * self.scrollView.subviews.count;
    self.scrollView.contentSize = CGSizeMake(w, self.height);
}

@end