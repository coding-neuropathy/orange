//
//  UIPlaceHolderTextView.m
//  basechem
//
//  Created by 谢 家欣 on 12-4-4.
//  Copyright (c) 2012年 QIN Network Technology Co., Ltd. All rights reserved.
//

#import "UIPlaceHolderTextView.h"

@interface UIPlaceHolderTextView ()

@property (nonatomic, strong) UILabel * placeholdeLabel;
@property (nonatomic, strong) UIView * backgroudView;
@end

@implementation UIPlaceHolderTextView

- (void)awakeFromNib
{
    [super awakeFromNib];
//    self.placeholder = @"";
//    self.placeholderColor = UIColorFromRGB(0x999999);
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    if (self)
    {
//        self.placeholder = @"";
//        self.placeholderColor = [UIColor lightGrayColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UITextViewTextDidChangeNotification];
}

- (UILabel *)placeholdeLabel
{
    if (!_placeholdeLabel) {
        _placeholdeLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, self.bounds.size.width - 16, 0)];
//        _placeholdeLabel.backgroundColor = [UIColor redColor];
        _placeholdeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _placeholdeLabel.numberOfLines = 0;
        _placeholdeLabel.font = self.font;
//        _placeholdeLabel.backgroundColor = [UIColor clearColor];
        _placeholdeLabel.textColor = UIColorFromRGB(0x999999);
        _placeholdeLabel.alpha = 0;
        _placeholdeLabel.tag = 999;
        [self addSubview:_placeholdeLabel];
    }
    return _placeholdeLabel;
}

- (UIView *)backgroudView
{
    if (!_backgroudView) {
        _backgroudView = [[UIView alloc] initWithFrame:self.bounds];
        _backgroudView.backgroundColor = UIColorFromRGB(0xf6f6f6);
    }
    return _backgroudView;
}

- (void)textChanged:(NSNotification *)notification
{
    if([[self placeholder] length] == 0)
    {
        return;
    }
    
    if([[self text] length] == 0)
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    else
    {
        [[self viewWithTag:999] setAlpha:0];
    }
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.placeholdeLabel.text = placeholder;
    [self.placeholdeLabel sizeToFit];
    [self setNeedsLayout];
//    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self textChanged:nil];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self addSubview:self.backgroudView];
    [self sendSubviewToBack:self.backgroudView];
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
//    if ([self.placeholder length] > 0)
//    {
//        self.placeholdeLabel.text = _placeholder;
//        [_placeholdeLabel sizeToFit];
////        [self sendSubviewToBack:_placeholdeLabel];
//    }
    if ([[self text] length] == 0 && [_placeholder length] > 0)
    {
        self.placeholdeLabel.alpha = 1;
    }
    
}
@end
