
//
//  TravelNoteCoverCell.m
//  StudyTour
//
//  Created by use on 16/6/3.
//  Copyright © 2016年 魏鹏. All rights reserved.
//

#import "TravelNoteCoverCell.h"
#import "TravelNoteCoverModel.h"

@interface TravelNoteCoverCell ()

@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UILabel *seeLabel;

@end

@implementation TravelNoteCoverCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(TravelNoteCoverModel *)model
{
    _model = model;
    _tagLabel.text = _model.tagName;
    if (_model.coverThumbnailUrl.length > 0) {
        NSURL *coverImageUrl = [NSURL URLWithString:_model.coverThumbnailUrl];
        [_coverImageView sd_setImageWithURL:coverImageUrl];
    } else {
        _coverImageView.image = [UIImage imageNamed:@"bg_TravelNoteHome_Default"];
    }
    _titleLabel.text = _model.title;
    if (_model.like == nil) {
        _model.like = @"0";
    }
    _likeLabel.text = _model.like;
    if (_model.view == nil) {
        _model.view = @"0";
    }
    _seeLabel.text = _model.view;
}

@end