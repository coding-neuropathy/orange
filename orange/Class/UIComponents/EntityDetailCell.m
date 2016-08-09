//
//  EntityDetailCell.m
//  orange
//
//  Created by D_Collin on 16/1/22.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "EntityDetailCell.h"
#import "ImageLoadingView.h"
#import "LoginView.h"

@interface EntityDetailCell ()

@property (nonatomic , strong)UIImageView * imageView;

@property (nonatomic , strong)UILabel * brandLabel;

@property (nonatomic , strong)UILabel * titleLabel;

@property (nonatomic , strong)UILabel * priceLabel;

@property (nonatomic , strong)UIView  * placeholderView;

@property (nonatomic , strong)ImageLoadingView * loading;

@end


@implementation EntityDetailCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return self;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageAction:)];
        [_imageView addGestureRecognizer:tap];
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)brandLabel
{
    if (!_brandLabel) {
        _brandLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _brandLabel.font = [UIFont boldSystemFontOfSize:13.];
        _brandLabel.textColor = UIColorFromRGB(0x9d9e9f);
        _brandLabel.numberOfLines = 0;
        _brandLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_brandLabel];
    }
    return _brandLabel;
}


- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14.];
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.textColor = UIColorFromRGB(0x414243);
        _titleLabel.numberOfLines = 2;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}


- (UIView *)placeholderView
{
    if (!_placeholderView) {
        _placeholderView = [[UIView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_placeholderView];
    }
    return _placeholderView;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _priceLabel.font = [UIFont boldSystemFontOfSize:14.];
        _priceLabel.textColor = UIColorFromRGB(0x6eaaf0);
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_priceLabel];
    }
    return _priceLabel;
}

- (ImageLoadingView *)loading
{
    if (!_loading) {
        _loading = [[ImageLoadingView alloc]init];
        _loading.hidesWhenStopped = YES;
        [self.contentView addSubview:_loading];
    }
    return _loading;
}

- (void)setEntity:(GKEntity *)entity
{
    
    _entity = entity;
    __weak __typeof(&*self)weakSelf = self;
    [self.loading startAnimating];

        [self.imageView sd_setImageWithPreviousCachedImageWithURL:_entity.imageURL_310x310 andPlaceholderImage:[UIImage imageWithColor:UIColorFromRGB(0xF0F0F0) andSize:CGSizeMake((SCREEN_WIDTH - 3)/2 - 32, (SCREEN_WIDTH - 3)/2 - 32)] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            //
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [weakSelf.loading stopAnimating];
        }];


    self.brandLabel.text = _entity.brand;
    self.titleLabel.text = _entity.title;
    
    GKPurchase * purchase = [_entity.purchaseArray objectAtIndex:0];
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f", purchase.lowestPrice];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0., 0., self.deFrameWidth - 32., self.deFrameWidth - 32.);
    self.imageView.deFrameTop = 16;
    self.imageView.deFrameLeft = 16;
    
    
    self.brandLabel.frame = CGRectMake(0., 0., (SCREEN_WIDTH - 48)/2 - 8, 21);
    self.brandLabel.deFrameTop = self.imageView.deFrameBottom + 8;
    self.brandLabel.deFrameLeft = self.imageView.deFrameLeft;
    
    CGSize size = [_titleLabel sizeThatFits:CGSizeMake(_titleLabel.frame.size.width, MAXFLOAT)];
    
    self.titleLabel.frame = CGRectMake(0., 0., (SCREEN_WIDTH - 48)/2 - 8., size.height);
    self.titleLabel.deFrameTop = self.brandLabel.deFrameBottom;
    self.titleLabel.deFrameLeft = self.brandLabel.deFrameLeft;
   
    
    self.placeholderView.frame = CGRectMake(0., 0., (SCREEN_WIDTH - 48)/2 - 8., 21);
    self.placeholderView.deFrameTop = self.brandLabel.deFrameBottom + 21;
    self.placeholderView.deFrameLeft = self.brandLabel.deFrameLeft;
    
    self.priceLabel.frame = CGRectMake(16., 16.,(SCREEN_WIDTH - 48)/2 - 8., 21);
    self.priceLabel.deFrameTop = self.brandLabel.deFrameBottom + 42;
    self.priceLabel.deFrameLeft = self.brandLabel.deFrameLeft;
    
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xebebeb).CGColor);
    CGContextSetLineWidth(context, kSeparateLineWidth);
    
    CGContextMoveToPoint(context, 0., self.deFrameHeight);
    CGContextAddLineToPoint(context, self.contentView.deFrameWidth, self.contentView.deFrameHeight);
    
    CGContextMoveToPoint(context, self.contentView.deFrameWidth, 0.);
    CGContextAddLineToPoint(context, self.contentView.deFrameWidth, self.contentView.deFrameHeight);
    
    CGContextStrokePath(context);
}


#pragma mark - button action
- (void)tapImageAction:(id)sender
{
    
    [[OpenCenter sharedOpenCenter] openEntity:self.entity hideButtomBar:YES];
}

@end
