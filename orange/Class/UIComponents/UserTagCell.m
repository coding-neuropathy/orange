//
//  UserTagCell.m
//  orange
//
//  Created by 谢家欣 on 15/10/20.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "UserTagCell.h"

@interface UserTagCell ()

@property (strong, nonatomic) UILabel * tagLabel;
@property (strong, nonatomic) UILabel * numberLabel;
@property (strong, nonatomic) UILabel * indicatorLable;

@end

@implementation UserTagCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor= UIColorFromRGB(0xffffff);
    }
    return self;
}

- (UILabel *)tagLabel
{
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tagLabel.font = [UIFont systemFontOfSize:14.];
        _tagLabel.textColor = UIColorFromRGB(0x212121);
        _tagLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_tagLabel];
    }
    return _tagLabel;
}

- (UILabel *)numberLabel
{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _numberLabel.font = [UIFont systemFontOfSize:14.];
        _numberLabel.textColor = UIColorFromRGB(0x9d9e9f);
        _numberLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_numberLabel];
    }
    return _numberLabel;
}

- (UILabel *)indicatorLable
{
    if (!_indicatorLable) {
        _indicatorLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _indicatorLable.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14.];
        _indicatorLable.textAlignment = NSTextAlignmentLeft;
        _indicatorLable.textColor = UIColorFromRGB(0x9d9e9f);
        _indicatorLable.text = [NSString fontAwesomeIconStringForEnum:FAAngleRight];
        //        _indicatorLable.hidden = YES;
        //        _indicatorLable.backgroundColor = [UIColor redColor];
        [self addSubview:_indicatorLable];
    }
    return _indicatorLable;
}

- (void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    
    self.tagLabel.text = [NSString stringWithFormat:@"# %@", dict[@"tag"]];
    self.numberLabel.text = [NSString stringWithFormat:@"%@ 件商品", dict[@"entity_count"]];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = [self.tagLabel.text widthWithLineWidth:kScreenWidth Font:self.tagLabel.font];
//    DDLogInfo(@"width %f", width);
    self.tagLabel.frame = CGRectMake(0., 0., width, self.contentView.deFrameHeight);
    self.tagLabel.deFrameLeft += 16;
    
    self.numberLabel.frame = CGRectMake(0., 0., 100., self.contentView.deFrameHeight);
    self.numberLabel.center = self.tagLabel.center;
    self.numberLabel.deFrameLeft = self.tagLabel.deFrameRight + 5.;
    
    self.indicatorLable.frame = CGRectMake(0., 0., 20., 30.);
    self.indicatorLable.center = self.tagLabel.center;
    self.indicatorLable.deFrameRight = self.deFrameRight - 10.;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xebebeb).CGColor);
    CGContextSetLineWidth(context, 1);
    CGContextMoveToPoint(context, 0., self.deFrameHeight);
    CGContextAddLineToPoint(context, kScreenWidth, self.deFrameHeight);
    CGContextStrokePath(context);

}

@end
