//
//  EntityHeaderSectionView.m
//  orange
//
//  Created by 谢家欣 on 15/6/8.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "EntityHeaderSectionView.h"

@interface EntityHeaderSectionView ()

@property (strong, nonatomic) UILabel   *textLabel;
@property (strong, nonatomic) UILabel   *indicatorLable;
@property (strong, nonatomic) UIButton  *postNoteBtn;

@property (nonatomic, strong, nonnull) UIView * H;

@end

@implementation EntityHeaderSectionView

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
////        self.backgroundColor = UIColorFromRGB(0xf8f8f8);
////        self.backgroundColor = UIColorFromRGB(0xffffff);
//        
//    }
//    return self;
//}

- (UIView *)H
{
    if (!_H) {
        _H = [[UIView alloc]initWithFrame:CGRectZero];
        _H.backgroundColor = UIColorFromRGB(0xf1f1f1);
        [self addSubview:_H];
    }
    return _H;
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.deFrameSize      = CGSizeMake(200., 30.);
        _textLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14.];
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.textColor = UIColorFromRGB(0x212121);
        [self addSubview:_textLabel];
    }
    return _textLabel;
}

//navagationBar上右侧的三个指示器
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

- (UIButton *)postNoteBtn
{
    if (!_postNoteBtn) {
        _postNoteBtn                        = [UIButton buttonWithType:UIButtonTypeCustom];
        _postNoteBtn.deFrameSize            = CGSizeMake(80., 32.);
        _postNoteBtn.hidden                 = YES;
        _postNoteBtn.titleLabel.font        = [UIFont fontWithName:@"HelveticaNeue" size:12.];
        
        _postNoteBtn.layer.masksToBounds    = YES;
        _postNoteBtn.layer.cornerRadius     = 4.;
        _postNoteBtn.layer.borderWidth      = 1.;
        _postNoteBtn.layer.borderColor      = [UIColor colorFromHexString:@"#6192ff"].CGColor;
        
        [_postNoteBtn setTitleColor:[UIColor colorFromHexString:@"#6192ff"] forState:UIControlStateNormal];
        [_postNoteBtn setTitle:[NSString stringWithFormat:@"+ %@", NSLocalizedStringFromTable(@"post note", kLocalizedFile, nil)] forState:UIControlStateNormal];
        [_postNoteBtn addTarget:self action:@selector(tapPostNoteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_postNoteBtn];
    }
    return _postNoteBtn;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_delegate && [_delegate respondsToSelector:@selector(TapHeaderView:)]) {
        [_delegate TapHeaderView:self];
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
        case CategoryHeaderType:
        {
            self.textLabel.text         = [NSString stringWithFormat:@"%@「%@」",NSLocalizedStringFromTable(@"from", kLocalizedFile, nil), [_text componentsSeparatedByString:@"-"][0]];
            self.indicatorLable.hidden  = NO;
            self.userInteractionEnabled = YES;
            self.postNoteBtn.hidden     = YES;
        }
            break;
        case LikeType:
        {
            self.textLabel.text         = [NSString stringWithFormat:@"%@ 人喜爱", text];
//            self.textLabel.backgroundColor = [UIColor clearColor];
            self.indicatorLable.hidden  = NO;
            self.userInteractionEnabled = YES;
            self.postNoteBtn.hidden     = YES;
        }
            break;
        case NoteType:
        {
            self.textLabel.text         = [NSString stringWithFormat:@"%@ 人点评", text];
            self.postNoteBtn.hidden     = NO;
            
            self.indicatorLable.hidden  = YES;
//            self.userInteractionEnabled = NO;
//            self.postNoteBtn.userInteractionEnabled = YES;
        }
            break;
        case RecommendType:
        {
            self.textLabel.text         = NSLocalizedStringFromTable(_text, kLocalizedFile, nil);
            self.indicatorLable.hidden  = YES;
            self.userInteractionEnabled = NO;
            self.postNoteBtn.hidden     = YES;
        }
            break;
        case ShopType:
        {
//            self.textLabel.text = NSLocalizedStringFromTable(_text, kLocalizedFile, nil);
            self.textLabel.text = _text;
            self.indicatorLable.hidden = NO;
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
    switch (self.headertype) {
        case LikeType:
        {
            self.backgroundColor                = UIColorFromRGB(0xffffff);
            self.textLabel.frame                = CGRectMake(16., 9., 200., 30.);
            self.indicatorLable.frame           = CGRectMake(0., 0., 20., 30.);
            self.indicatorLable.center          = self.textLabel.center;
            self.indicatorLable.deFrameRight    = self.deFrameRight - 10.;
            self.H.frame                        = CGRectMake(0., 0., kScreenWidth, 1.);
        }
            break;
        case NoteType:
        {
            self.backgroundColor                = [UIColor colorFromHexString:@"#ffffff"];
            self.textLabel.deFrameLeft          = 16.;
            self.textLabel.deFrameTop           = 9.;
//            self.textLabel.frame                = CGRectMake(16., 9., 200., 30.);
//            self.indicatorLable.frame           = CGRectMake(0., 0., 20., 30.);
//            self.indicatorLable.center          = self.textLabel.center;
//            self.indicatorLable.deFrameRight    = self.deFrameRight - 10.;
//            self.textLabel.deFrameSize          = CGSizeMake(200., 30.);
//            self.textLabel.center               = self.center;
//            self.textLabel.deFrameLeft          = 16.;
            
            self.postNoteBtn.center             = self.textLabel.center;
            self.postNoteBtn.deFrameRight       = self.deFrameWidth - 16.;
            
        }
            break;
        case ShopType:
        {
            self.backgroundColor = UIColorFromRGB(0xffffff);
            self.textLabel.frame = CGRectMake(16., 10., 200., 30.);
            self.indicatorLable.frame = CGRectMake(0., 0., 20., 30.);
            self.indicatorLable.center = self.textLabel.center;
            self.indicatorLable.deFrameRight = self.deFrameRight - 10.;
        }
            break;
        default:
        {
            self.backgroundColor = UIColorFromRGB(0xf8f8f8);
            self.textLabel.frame = CGRectMake(16., 10., 200., 30.);
            self.indicatorLable.frame = CGRectMake(0., 0., 20., 30.);
            self.indicatorLable.center = self.textLabel.center;
            self.indicatorLable.deFrameRight = self.deFrameRight - 10.;
        }
            break;
    }
    

}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
//    if (CategoryType == self.headertype) {
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        
//        CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xebebeb).CGColor);
//        CGContextSetLineWidth(context, kSeparateLineWidth);
//        
//        CGContextMoveToPoint(context, 0, kSeparateLineWidth);
//        CGContextAddLineToPoint(context, self.frame.size.width, kSeparateLineWidth);
//        
////        CGContextMoveToPoint(context, 0., self.frame.size.height - kSeparateLineWidth);
////        CGContextAddLineToPoint(context, kScreenWidth, self.frame.size.height - kSeparateLineWidth);
//        CGContextStrokePath(context);
//    }
    
    if (NoteType == self.headertype) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xebebeb).CGColor);
        CGContextSetLineWidth(context, kSeparateLineWidth);
        
        CGContextMoveToPoint(context, 0, kSeparateLineWidth);
        CGContextAddLineToPoint(context, self.frame.size.width, kSeparateLineWidth);
        
        CGContextStrokePath(context);
    }
}

#pragma mark - button action 
- (void)tapPostNoteBtnAction:(id)sender
{
    DDLogInfo(@"post post note note");
    if (self.postNoteBlock) {
        self.postNoteBlock();
    }
}

@end
