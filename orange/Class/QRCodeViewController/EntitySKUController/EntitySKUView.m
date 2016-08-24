//
//  EntitySKUView.m
//  orange
//
//  Created by 谢家欣 on 16/8/24.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "EntitySKUView.h"
#import <iCarousel/iCarousel.h>

@interface EntitySKUView () <iCarouselDelegate, iCarouselDataSource>

@property (strong, nonatomic) iCarousel     *imagesView;
@property (strong, nonatomic) UILabel       *titleLabel;
@property (strong, nonatomic) UILabel       *priceLabel;
@property (strong, nonatomic) UIButton      *cartBtn;

@property (assign, nonatomic) BOOL          warp;

@end

@implementation EntitySKUView

- (instancetype)initWithFrame:(CGRect)frame
{
    self    = [super initWithFrame:frame];
    if (self) {
        self.warp       = NO;
    }
    return self;
}

#pragma mark - lazy load view
- (iCarousel *)imagesView
{
    if (!_imagesView) {
        _imagesView                     = [[iCarousel alloc] initWithFrame:CGRectZero];
        _imagesView.deFrameSize         = CGSizeMake(self.deFrameWidth, 206.);
        _imagesView.type                = iCarouselTypeLinear;
        _imagesView.pagingEnabled       = YES;
        
        _imagesView.dataSource          = self;
        _imagesView.delegate            = self;
        [self addSubview:_imagesView];
    }
    return _imagesView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel                     = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.deFrameSize         = CGSizeMake(self.deFrameWidth - 48., 24.);
        _titleLabel.font                = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.];
        _titleLabel.textColor           = UIColorFromRGB(0x212121);
        _titleLabel.textAlignment       = NSTextAlignmentCenter;
        _titleLabel.numberOfLines       = 1;
        
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel                     = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.deFrameSize         = CGSizeMake(120., 24.);
        _priceLabel.font                = [UIFont fontWithName:@"PingFangSC-Semibold" size:16.];
        _priceLabel.textColor           = UIColorFromRGB(0x5976c1);
        _priceLabel.textAlignment       = NSTextAlignmentLeft;
        
        [self addSubview:_priceLabel];
    }
    return _priceLabel;
}

- (UIButton *)cartBtn
{
    if (!_cartBtn) {
        _cartBtn                        = [UIButton buttonWithType:UIButtonTypeCustom];
        _cartBtn.deFrameSize            = CGSizeMake(128., 32.);
        _cartBtn.backgroundColor        = UIColorFromRGB(0x6192ff);
        _cartBtn.layer.cornerRadius     = _cartBtn.deFrameHeight / 2.;
        _cartBtn.layer.masksToBounds    = YES;
        
        _cartBtn.titleLabel.font        = [UIFont fontWithName:@"PingFangSC-Regular" size:14.];
        [_cartBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_cartBtn setTitle:NSLocalizedStringFromTable(@"add-cart", kLocalizedFile, nil) forState:UIControlStateNormal];
        
        [_cartBtn addTarget:self action:@selector(cartBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_cartBtn];
    }
    return _cartBtn;
}

#pragma mark - set data
- (void)setEntity:(GKEntity *)entity
{
    _entity                     = entity;
    
    if (self.entity.imageURLArray.count > 1) {
        self.imagesView.scrollEnabled = YES;
    } else {
        self.imagesView.scrollEnabled = NO;
    }
    [self.imagesView reloadData];
    
    
    self.titleLabel.text        = _entity.title;
    self.priceLabel.text        = [NSString stringWithFormat:@"￥ %.2f", _entity.lowestPrice];
    
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imagesView.deFrameTop          = 24.;
    
    self.titleLabel.deFrameTop          = self.imagesView.deFrameBottom + 39.;
    self.titleLabel.deFrameLeft         = 24.;
    
    self.priceLabel.deFrameTop          = self.titleLabel.deFrameBottom + 20.;
    self.priceLabel.deFrameLeft         = self.titleLabel.deFrameLeft;
    
    self.cartBtn.center                 = self.priceLabel.center;
    self.cartBtn.deFrameRight           = self.deFrameRight - 24.;

}

#pragma mark - button action
- (void)cartBtnAction:(id)sender
{
    
}


#pragma mark - <iCarouselDataSource>
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.entity.imageURLArray.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (!view) {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0., 0., 206, 206.)];
        view.contentMode = UIViewContentModeScaleAspectFit;
    }
    NSURL * imageURL_800;
    NSURL * url = [self.entity.imageURLArray objectAtIndex:index];
    
    if ([url.absoluteString hasPrefix:@"http://imgcdn.guoku.com/images/"]) {
        imageURL_800 = [NSURL URLWithString:[url.absoluteString imageURLWithSize:310]];
    } else {
        //        imageURL_800 = [NSURL URLWithString:[url.absoluteString stringByAppendingString:@"_800x800.jpg"]];
        imageURL_800 = [NSURL URLWithString:url.absoluteString];
    }
    DDLogInfo(@"url %lu %@ ", (long)index, imageURL_800);
    [(UIImageView *)view sd_setImageWithURL:imageURL_800 placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf7f7f7) andSize:view.deFrameSize]];
    
    return view;
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
            case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return self.warp;
        }
            case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.03f;
        }
            case iCarouselOptionFadeMax:
        {
            if (self.imagesView.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
            case iCarouselOptionShowBackfaces:
            case iCarouselOptionRadius:
            case iCarouselOptionAngle:
            case iCarouselOptionArc:
            case iCarouselOptionTilt:
            case iCarouselOptionCount:
            case iCarouselOptionFadeMin:
            case iCarouselOptionFadeMinAlpha:
            case iCarouselOptionFadeRange:
            case iCarouselOptionOffsetMultiplier:
            case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}

@end
