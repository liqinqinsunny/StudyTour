//
//  WJPPhotoCollectionCell.h
//  StudyTourLeaderSide
//
//  Created by use on 16/5/17.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJPPhotoCollectionCell : UICollectionViewCell

@property (nonatomic, strong) id imageInfo;
@property (nonatomic, strong) UIImage *placeholdImage;

- (void)updateImageViewFrameWithImage:(UIImage *)image;


@end
