//
//  WJPLineTextView.m
//  StudyTour
//
//  Created by use on 16/7/12.
//  Copyright © 2016年 魏鹏. All rights reserved.
//

#import "WJPLineTextView.h"

#define lineHeight 35.9

@implementation WJPLineTextView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
        self.contentMode = UIViewContentModeRedraw;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.textAlignment = NSTextAlignmentCenter;
        self.contentMode = UIViewContentModeRedraw;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    NSLog(@"TEST");
    //Get the current drawing context
    CGContextRef context = UIGraphicsGetCurrentContext();
    //Set the line color and width
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHex:0xebebeb].CGColor);
    CGContextSetLineWidth(context, 1.0f);
    //Start a new Path
    CGContextBeginPath(context);
    
    //Find the number of lines in our textView + add a bit more height to draw lines in the empty part of the view
//    NSUInteger numberOfLines = (self.contentSize.height + self.bounds.size.height) / self.font.leading;
    
    NSUInteger numberOfLines = (self.contentSize.height + self.bounds.size.height) / lineHeight;
    
    //Set the line offset from the baseline. (I'm sure there's a concrete way to calculate this.)
//    CGFloat baselineOffset = 6.0f;
    CGFloat baselineOffset = 0.0f;
    
    //iterate over numberOfLines and draw each line
    for (int x = 1; x < numberOfLines; x++) {
        //0.5f offset lines up line with pixel boundary
//        CGContextMoveToPoint(context, self.bounds.origin.x, self.font.leading*x + 0.5f + baselineOffset);
//        CGContextAddLineToPoint(context, self.bounds.size.width, self.font.leading*x + 0.5f + baselineOffset);
        CGContextMoveToPoint(context, self.bounds.origin.x, lineHeight*x + 0.5f + baselineOffset);
        CGContextAddLineToPoint(context, self.bounds.size.width, lineHeight*x + 0.5f + baselineOffset);
    }
    
    CGContextClosePath(context);
    CGContextStrokePath(context);
}

- (CGRect)caretRectForPosition:(UITextPosition *)position {
    CGRect originalRect = [super caretRectForPosition:position];
    originalRect.size.height = 21;
    originalRect.size.width = 2;
//    originalRect.origin.y = 8;
//    originalRect.origin.x = 0;
    return originalRect;
}



@end
