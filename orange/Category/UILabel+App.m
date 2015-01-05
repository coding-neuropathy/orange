//
//  UILabel+App.m
//  Blueberry
//
//  Created by 回特 on 13-9-29.
//  Copyright (c) 2013年 huiter. All rights reserved.
//

#import "UILabel+App.h"

@implementation UILabel (App)

- (void)fixText
{
    CGFloat originWidth = CGRectGetWidth(self.bounds);
    //CGSize newSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(originWidth, CGFLOAT_MAX) lineBreakMode:self.lineBreakMode];
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(originWidth, CGFLOAT_MAX)  options:NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil];
    
    self.deFrameSize = rect.size;
    self.deFrameWidth = originWidth;
}

- (void)fixTextChangeWidth
{
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX)  options:NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil];
    self.deFrameSize = rect.size;
}
@end
