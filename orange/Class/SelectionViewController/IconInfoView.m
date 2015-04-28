//
//  IconInfoView.m
//  orange
//
//  Created by 谢家欣 on 15/4/28.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "IconInfoView.h"
#import "NSString+Helper.h"

@interface IconInfoView ()

@property (strong, nonatomic) UIImageView * iconView;
@property (strong, nonatomic) UILabel * infoLabel;
@property (strong, nonatomic) UILabel * arrowLabel;

@end

@implementation IconInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _iconView.image = [[UIImage imageNamed:@"logo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //        icon.tintColor = UIColorFromRGB(0x8b8b8b);
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self addSubview:_iconView];
        //        icon.userInteractionEnabled = YES;
        //        self.navigationItem.titleView = icon;
        
//        UILabel * arrowLabel = [[UILabel alloc] initWithFrame:CGRectMake(0., 0., 16, 25)];
//        //        arrowLabel.font = [UIFont]
//        arrowLabel.deFrameLeft = icon.deFrameRight + 8.;
//        //        arrowLabel.backgroundColor = [UIColor redColor];
//        arrowLabel.textColor = UIColorFromRGB(0x9d9e9f);
//        arrowLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:16.];
//        arrowLabel.text = [NSString fontAwesomeIconStringForEnum:FASortAsc];
    }
    return _iconView;
}

- (UILabel *)infoLabel
{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _infoLabel.textColor = UIColorFromRGB(0x414243);
        _infoLabel.font = [UIFont boldSystemFontOfSize:17.];
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_infoLabel];
    }
    return _infoLabel;
}

- (UILabel *)arrowLabel
{
    if (!_arrowLabel) {
        _arrowLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                //        arrowLabel.font = [UIFont]
//                _arrowLabel.deFrameLeft = icon.deFrameRight + 8.;
                //        arrowLabel.backgroundColor = [UIColor redColor];
        _arrowLabel.textColor = UIColorFromRGB(0x9d9e9f);
        _arrowLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:16.];
        _arrowLabel.text = [NSString fontAwesomeIconStringForEnum:FASortAsc];
        [self addSubview:_arrowLabel];
    }
    return _arrowLabel;
}

- (void)setCategroyText:(NSString *)categroyText
{
    _categroyText = categroyText;
    
    if (!_categroyText) {
        self.infoLabel.hidden = YES;
        self.iconView.hidden = NO;
    } else {
        self.infoLabel.text = _categroyText;
        self.iconView.hidden = YES;
        self.infoLabel.hidden = NO;
    }
    
    [self setNeedsLayout];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.categroyText) {
        self.iconView.frame = CGRectMake(0., 0., 43., 25.);
        self.arrowLabel.frame = CGRectMake(0., 0., 16., 25.);
        self.iconView.center = CGPointMake(self.frame.size.width / 2., self.frame.size.height / 2.);
        
        self.arrowLabel.deFrameLeft = self.iconView.deFrameRight + 8.;
    } else {
        
        CGFloat width = [self.categroyText widthWithLineWidth:0 Font:[UIFont boldSystemFontOfSize:17.]];
        self.infoLabel.frame = CGRectMake(0., 0., width, 25.);
        self.infoLabel.center = CGPointMake(self.frame.size.width / 2., self.frame.size.height / 2.);
        self.arrowLabel.deFrameLeft = self.infoLabel.deFrameRight + 8.;
    }
}

@end
