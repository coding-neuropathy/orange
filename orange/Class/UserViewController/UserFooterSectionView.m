//
//  UserFooterSectionView.m
//  orange
//
//  Created by 谢家欣 on 15/10/19.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "UserFooterSectionView.h"

@interface UserFooterSectionView ()

@property (strong, nonatomic) UIButton * moreBtn;

@end

@implementation UserFooterSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return self;
}

- (UIButton *)moreBtn
{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:14.];
//        _moreBtn.titleLabel.textColor = UIColorFromRGB(0x427ec0);
        _moreBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [_moreBtn addTarget:self action:@selector(moreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_moreBtn];
    }
    return _moreBtn;
}

//- (void)setTitle:(NSString *)title
//{
//    _title = title;
////    self.titleLabel.text = _title;
//    [self.moreBtn setTitle:_title forState:UIControlStateNormal];
//    [self.moreBtn setTitleColor:UIColorFromRGB(0x427ec0) forState:UIControlStateNormal];
//    
//    [self setNeedsLayout];
//}
- (void)setType:(UserPageType)type
{
    _type = type;
    [self.moreBtn setTitle:NSLocalizedStringFromTable(@"more", kLocalizedFile, nil) forState:UIControlStateNormal];
    [self.moreBtn setTitleColor:UIColorFromRGB(0x427ec0) forState:UIControlStateNormal];
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.titleLabel.frame = CGRectMake(0., 0., kScreenWidth, 44.);
    self.moreBtn.frame = CGRectMake(0., 0., kScreenWidth, 44.);
    
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xebebeb).CGColor);
    CGContextSetLineWidth(context, kSeparateLineWidth);
    CGContextMoveToPoint(context, 0., 0);
    CGContextAddLineToPoint(context, kScreenWidth, 0);
    CGContextStrokePath(context);
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xf8f8f8).CGColor);
    CGContextSetLineWidth(context, 20.);
    CGContextMoveToPoint(context, 0., self.deFrameHeight);
    CGContextAddLineToPoint(context, kScreenWidth, self.deFrameHeight);
    CGContextStrokePath(context);
}

#pragma mark - button action
- (void)moreBtnAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(TapMoreButtonWithType:)]) {
        [_delegate TapMoreButtonWithType:self.type];
    }
}


@end