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
        _brandLabel.font = [UIFont boldSystemFontOfSize:14.];
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
        _titleLabel.textColor = UIColorFromRGB(0x414243);
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
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
    if (IS_IPHONE_6) {
        [self.imageView sd_setImageWithPreviousCachedImageWithURL:_entity.imageURL_310x310 andPlaceholderImage:[UIImage imageWithColor:UIColorFromRGB(0xF0F0F0) andSize:CGSizeMake((SCREEN_WIDTH - 3)/2 - 32, (SCREEN_WIDTH - 3)/2 - 32)] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            //
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [weakSelf.loading stopAnimating];
        }];
    }

    self.brandLabel.text = _entity.brand;
    self.titleLabel.text = _entity.title;
    
    GKPurchase * purchase = [_entity.purchaseArray objectAtIndex:0];
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f", purchase.lowestPrice];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(16., 16., (SCREEN_WIDTH - 48)/2 - 8, (SCREEN_WIDTH - 48)/2 - 8);
    self.imageView.deFrameTop = 16;
    self.imageView.deFrameLeft = 16;
    
    
    self.brandLabel.frame = CGRectMake(16., 16., (SCREEN_WIDTH - 48)/2, 21);
    self.brandLabel.deFrameTop = self.imageView.deFrameBottom + 3;
    self.brandLabel.deFrameLeft = self.imageView.deFrameLeft;
    
    self.titleLabel.frame = CGRectMake(16., 16., (SCREEN_WIDTH - 48)/2., 42);
    self.titleLabel.deFrameTop = self.brandLabel.deFrameBottom - 10;
    self.titleLabel.deFrameLeft = self.brandLabel.deFrameLeft;
    
    self.priceLabel.frame = CGRectMake(16., 16., 100, 21);
    self.priceLabel.deFrameTop = self.titleLabel.deFrameBottom + 8;
    self.priceLabel.deFrameLeft = self.titleLabel.deFrameLeft;
    
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xebebeb).CGColor);
    CGContextSetLineWidth(context, kSeparateLineWidth);
    CGContextMoveToPoint(context, kScreenWidth, self.deFrameHeight);
    CGContextAddLineToPoint(context, kScreenWidth, self.deFrameHeight);
    
    CGContextStrokePath(context);
}


#pragma mark - button action
- (void)tapImageAction:(id)sender
{
    [[OpenCenter sharedOpenCenter] openEntity:self.entity];
}

@end
