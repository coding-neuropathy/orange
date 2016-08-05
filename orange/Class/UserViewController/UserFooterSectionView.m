//
//  UserFooterSectionView.m
//  orange
//
//  Created by 谢家欣 on 15/10/19.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "UserFooterSectionView.h"

@interface UserFooterSectionView ()

//@property (strong, nonatomic) UIButton * moreBtn;


@end

@implementation UserFooterSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xf8f8f8);
//        _H = [[UIView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, 0.5)];
//        self.H.backgroundColor = UIColorFromRGB(0xebebeb);
//        [self addSubview:self.H];
    }
    return self;
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
//- (void)setType:(UserPageType)type
//{
//    _type = type;
//    [self.moreBtn setTitle:NSLocalizedStringFromTable(@"more", kLocalizedFile, nil) forState:UIControlStateNormal];
//    [self.moreBtn setTitleColor:UIColorFromRGB(0x427ec0) forState:UIControlStateNormal];
//    [self setNeedsLayout];
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.H.deFrameTop = 0;
//    self.titleLabel.frame = CGRectMake(0., 0., kScreenWidth, 44.);
//    self.moreBtn.frame = CGRectMake(0., 0., kScreenWidth, 44.);
    
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xebebeb).CGColor);
    CGContextSetLineWidth(context, 0.5);
    CGContextMoveToPoint(context, 0., 0);
    CGContextAddLineToPoint(context, kScreenWidth, 0);
    CGContextStrokePath(context);
    
//    CGContextStrokePath(context);
}


@end
