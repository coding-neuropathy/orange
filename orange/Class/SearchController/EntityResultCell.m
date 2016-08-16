//
//  EntityCell.m
//  orange
//
//  Created by D_Collin on 16/7/12.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "EntityResultCell.h"
#import "EntityViewController.h"
//#import "LoginView.h"


@interface EntityResultCell ()

//@property (nonatomic, strong) UIView *imageBG;
@property (nonatomic, strong) UIImageView *imageView;
//@property (nonatomic, strong) UILabel *brandLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel * tipLabel;
@property (nonatomic, strong) UILabel *priceLabel;
//@property (nonatomic, strong) UIView *H;
//@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
//@property (nonatomic, strong) UIImageView * entity_mark;

@end

@implementation EntityResultCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return self;
}

- (UIActivityIndicatorView *)activityIndicator
{
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicator.frame = CGRectMake(0, 0, 40, 40);
        
        _activityIndicator.hidesWhenStopped = YES;
//        self.activityIndicator.tag = 30325;
        _activityIndicator.color = UIColorFromRGB(0xbbbbbb);
        [self.contentView insertSubview:_activityIndicator aboveSubview:self.imageView];
    
    }
    return _activityIndicator;
}


- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.backgroundColor = UIColorFromRGB(0xffffff);
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = UIColorFromRGB(0x212121);
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.backgroundColor = [UIColor clearColor];
        _priceLabel.font = [UIFont fontWithName:@"Georgia" size:16.];
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        _priceLabel.textColor = UIColorFromRGB(0x5e90c8);
        _priceLabel.text = [NSString stringWithFormat:@"￥%.2f", self.entity.lowestPrice];
        
        [self.contentView addSubview:_priceLabel];
    }
    return _priceLabel;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _tipLabel.textAlignment = NSTextAlignmentRight;
        _tipLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:12.];
//        [ setBackgroundColor:[UIColor clearColor]];
        _tipLabel.backgroundColor = [UIColor clearColor];
//        _tipLabel.textColor = UIColorFromRGB(0x9d9e9f);
        _tipLabel.textColor = [UIColor colorWithRed:0. green:0. blue:0. alpha:0.26];
        [self.contentView addSubview:self.tipLabel];
    }
    return _tipLabel;
}

- (void)setEntity:(GKEntity *)entity
{
    _entity = entity;

    // set entity title content
    NSString * brand = @"";
    NSString * title = @"";
    if((![self.entity.brand isEqual:[NSNull null]])&&(![_entity.brand isEqualToString:@""])&&(_entity.brand))
    {
        brand = [NSString stringWithFormat:@"%@ - ", _entity.brand];
    }
    if((![self.entity.title isEqual:[NSNull null]])&&(_entity.title))
    {
        title = self.entity.title;
    }
    self.titleLabel.text = [NSString stringWithFormat:@"%@%@",brand,title];
    
    // set entity like and dig number
    self.tipLabel.text = [NSString stringWithFormat:@"%@ %ld  %@ %ld",
                          [NSString fontAwesomeIconStringForEnum:FAHeart], (long)_entity.likeCount,
                          [NSString fontAwesomeIconStringForEnum:FAComment], (long)_entity.noteCount];
    
    // setup activiyIndicator for imageView
    self.activityIndicator.center = self.imageView.center;
    [self.activityIndicator startAnimating];
    
    // loading entity image from cdn
    __weak __typeof(&*self)weakSelf = self;
    [self.imageView sd_setImageWithURL:_entity.imageURL_240x240
                    placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xebebeb) andSize:CGSizeMake(90., 90.)]
                    options:SDWebImageRetryFailed
                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,NSURL *imageURL)
    {
        if (!error) {
            if (image && cacheType == SDImageCacheTypeNone) {
                weakSelf.imageView.alpha = 0.0;
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.imageView.alpha = 1.0;
                }];
            }
        }
        else
        {
            [weakSelf.imageView sd_setImageWithURL:_entity.imageURL];
        }
        [weakSelf.activityIndicator stopAnimating];
        weakSelf.activityIndicator.hidden = YES;
        
    }];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 商品主图
    self.imageView.frame = CGRectMake(0., 0., 90., 90.);
    self.imageView.deFrameTop = 12.;
    self.imageView.deFrameLeft = 12.;
    
    // 标题
    self.titleLabel.frame = CGRectMake(0., 0.,
                                       self.contentView.deFrameWidth - (self.imageView.deFrameWidth + 12. * 2.), 40.);
    self.titleLabel.deFrameTop = 19.;
    self.titleLabel.deFrameLeft = self.imageView.deFrameRight + 12.;
    
    // 价格
    self.priceLabel.frame = CGRectMake(0., 0., 100., 20.);
//    self.priceLabel.deFrameTop = self.titleLabel.deFrameBottom+10;
    self.priceLabel.deFrameLeft = self.titleLabel.deFrameLeft;
    self.priceLabel.deFrameBottom = self.contentView.deFrameBottom - 19.;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", self.entity.lowestPrice];
    [self.priceLabel sizeToFit];
    
    CGFloat tipLabelWidth = [self.tipLabel.text widthWithLineWidth:0. Font:self.tipLabel.font];
    self.tipLabel.frame = CGRectMake(0., 0., tipLabelWidth, 16.);
//    self.tipLabel.deFrameTop = self.frame.size.height - 20;
    self.tipLabel.deFrameRight = self.frame.size.width - 12.;
    self.tipLabel.deFrameBottom = self.contentView.deFrameBottom - 19.;
    
//    if (!self.activityIndicator) {
//
//    }
//    [self.activityIndicator startAnimating];

}

@end
