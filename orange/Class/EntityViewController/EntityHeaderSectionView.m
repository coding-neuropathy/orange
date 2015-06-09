//
//  EntityHeaderSectionView.m
//  orange
//
//  Created by 谢家欣 on 15/6/8.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "EntityHeaderSectionView.h"

@interface EntityHeaderSectionView ()

@property (strong, nonatomic) UILabel * textLabel;
@property (strong, nonatomic) UILabel * indicatorLable;

@end

@implementation EntityHeaderSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xf8f8f8);
    }
    return self;
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.font = [UIFont systemFontOfSize:14.];
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.textColor = UIColorFromRGB(0x414243);
        _textLabel.hidden = YES;
        [self addSubview:_textLabel];
    }
    return _textLabel;
}

- (UILabel *)indicatorLable
{
    if (!_indicatorLable) {
        _indicatorLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _indicatorLable.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14.];
        _indicatorLable.textAlignment = NSTextAlignmentLeft;
        _indicatorLable.textColor = UIColorFromRGB(0x9d9e9f);
        _indicatorLable.text = [NSString fontAwesomeIconStringForEnum:FAAngleRight];
        _indicatorLable.hidden = YES;
        
        [self addSubview:_indicatorLable];
    }
    return _indicatorLable;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_delegate && [_delegate respondsToSelector:@selector(TapHeaderView)]) {
        [_delegate TapHeaderView];
    }
}


- (void)setHeadertype:(EntitySectionType)headertype
{
    _headertype = headertype;

}

- (void)setText:(NSString *)text
{
    _text = text;
    switch (self.headertype) {
        case CategoryType:
        {
            self.textLabel.text = [NSString stringWithFormat:@"%@「%@」",NSLocalizedStringFromTable(@"from", kLocalizedFile, nil), [_text componentsSeparatedByString:@"-"][0]];
            self.textLabel.hidden = NO;
            self.indicatorLable.hidden = NO;
            self.userInteractionEnabled = YES;
        }
            break;
        case RecommendType:
        {
            self.textLabel.text = NSLocalizedStringFromTable(_text, kLocalizedFile, nil);
            self.textLabel.hidden = NO;
            self.indicatorLable.hidden = YES;
            self.userInteractionEnabled = NO;
        }
            break;
        default:
            break;
    }
    
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(16., 10., 200., 30.);
    self.indicatorLable.frame = CGRectMake(0., 0., 20., 30.);
    self.indicatorLable.center = self.textLabel.center;
    self.indicatorLable.deFrameRight = self.deFrameRight - 10.;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (CategoryType == self.headertype) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xebebeb).CGColor);
        CGContextSetLineWidth(context, kSeparateLineWidth);
        
        CGContextMoveToPoint(context, 0, kSeparateLineWidth);
        CGContextAddLineToPoint(context, self.frame.size.width - kSeparateLineWidth, kSeparateLineWidth);
        
        CGContextMoveToPoint(context, 0., self.frame.size.height - kSeparateLineWidth);
        CGContextAddLineToPoint(context, kScreenWidth, self.frame.size.height - kSeparateLineWidth);
        CGContextStrokePath(context);
    }
}



@end
