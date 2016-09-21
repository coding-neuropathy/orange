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

@property (strong, nonatomic) iCarousel         *imagesView;
@property (strong, nonatomic) UILabel           *titleLabel;
@property (strong, nonatomic) UILabel           *priceLabel;
//@property (strong, nonatomic) UIButton      *cartBtn;
@property (strong, nonatomic) NSMutableDictionary       *skuBtnItems;

@property (strong, nonatomic) UILabel           *skuInfoLabel;

@property (strong, nonatomic) GKEntitySKU       *selectedSKU;
@property (strong, nonatomic) NSMutableArray    *imageURLArray;

@property (assign, nonatomic) BOOL          warp;

@end

@implementation EntitySKUView

- (instancetype)initWithFrame:(CGRect)frame
{
    self    = [super initWithFrame:frame];
    if (self) {
        self.warp           = NO;
        
    }
    return self;
}

- (NSMutableArray *)imageURLArray
{
    if (!_imageURLArray) {
        _imageURLArray      = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _imageURLArray;
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

- (UILabel *)skuInfoLabel
{
    if (!_skuInfoLabel) {
        _skuInfoLabel                   = [[UILabel alloc] initWithFrame:CGRectZero];
        _skuInfoLabel.deFrameSize       = CGSizeMake(self.deFrameWidth - 48., 20.);
        _skuInfoLabel.font              = [UIFont fontWithName:@"PingFangSC-Semibold" size:14.];
        _skuInfoLabel.textColor         = UIColorFromRGB(0x212121);
        _skuInfoLabel.textAlignment     = NSTextAlignmentLeft;
        _skuInfoLabel.text              = NSLocalizedStringFromTable(@"item-sku", kLocalizedFile, nil);
        
        [self addSubview:_skuInfoLabel];
    }
    
    return _skuInfoLabel;
    
}

#pragma mark - set data
- (void)setEntity:(GKEntity *)entity
{
    _entity                     = entity;
//    [self.imageURLArray insertObject:_entity.imageURL atIndex:0];
    [self.imageURLArray addObject:_entity.imageURL];
    [self.imageURLArray addObjectsFromArray:_entity.imageURLArray];
    
    DDLogInfo(@"image url %@", self.imageURLArray);
    
    if (self.imageURLArray.count > 1) {
        self.imagesView.scrollEnabled = YES;
    } else {
        self.imagesView.scrollEnabled = NO;
    }
    [self.imagesView reloadData];
    
    
    self.titleLabel.text        = _entity.title;
    self.priceLabel.text        = [NSString stringWithFormat:@"￥ %.2f", _entity.lowestPrice];
    
    [self setupSKU];
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
    
//    self.cartBtn.center                 = self.priceLabel.center;
//    self.cartBtn.deFrameRight           = self.deFrameRight - 24.;

    self.skuInfoLabel.deFrameTop        = self.priceLabel.deFrameBottom + 38.;
    self.skuInfoLabel.deFrameLeft       = self.priceLabel.deFrameLeft;
    
    
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}

#pragma mark - setup entity sku
- (void)setupSKU
{
//    for (UIView * view in self.subviews) {
//        if ([view isKindOfClass:[UIButton class]] && view != self.cartBtn) {
//            [view removeFromSuperview];
//        }
//    }
    self.skuBtnItems    = [NSMutableDictionary dictionaryWithCapacity:0];
    
    CGFloat maxWidth                = self.deFrameWidth - 48.;
    CGFloat xOffset                 = 0.;
    CGFloat yOffset                 = self.skuInfoLabel.deFrameBottom + 16.;
    
//    for (GKEntitySKU * sku in self.entity.skuArray)
    for (NSInteger i = 0; i < self.entity.skuArray.count; i++ ) {
        GKEntitySKU * sku = [self.entity.skuArray objectAtIndex:i];
        
        if ([sku.attr_string length] == 0) continue;
        
        UIButton * skuBtn           = [UIButton buttonWithType:UIButtonTypeCustom];
        skuBtn.backgroundColor      = UIColorFromRGB(0xf1f1f1);
        skuBtn.titleLabel.font      = [UIFont fontWithName:@"PingFangSC-Regular" size:14.];
        skuBtn.tag                  = i;
        
        [skuBtn setTitle:sku.attr_string forState:UIControlStateNormal];
        [skuBtn setTitleColor:UIColorFromRGB(0x757575) forState:UIControlStateNormal];
        [skuBtn setTitleColor:UIColorFromRGB(0x3f6ff0) forState:UIControlStateSelected];
        [skuBtn addTarget:self action:@selector(skuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat btnWidth            = [sku.attr_string widthWithLineWidth:0. Font:skuBtn.titleLabel.font];
        skuBtn.deFrameSize          = CGSizeMake(btnWidth + 16., 24.);
        skuBtn.layer.masksToBounds  = YES;
        skuBtn.layer.cornerRadius   = skuBtn.deFrameHeight / 2.;
        
        /**
         *  set sku btn layout
         */
        if (xOffset == 0) {
            skuBtn.deFrameLeft      = 24.;
            skuBtn.deFrameTop       = yOffset;
        } else {
            
            skuBtn.deFrameLeft      = xOffset + 10.;
            skuBtn.deFrameTop       = yOffset;
        }
        xOffset                     = skuBtn.deFrameRight;
        yOffset                     = skuBtn.deFrameTop;
        
        if (xOffset > maxWidth) {
            yOffset                 += 34.;
            skuBtn.deFrameLeft      = 24.;
            skuBtn.deFrameTop       = yOffset;
            xOffset                 = skuBtn.deFrameRight;
        }
        
        DDLogInfo(@"width %f btn %@", xOffset, skuBtn);
        [self.skuBtnItems setObject:skuBtn forKey:@(i)];
        [self addSubview:skuBtn];
    }
    
}

#pragma mark - button action
//- (void)cartBtnAction:(id)sender
//{
//    if (_SKUDelegate && [_SKUDelegate respondsToSelector:@selector(TapAddCartWithSKU:)]) {
//        [_SKUDelegate TapAddCartWithSKU:self.selectedSKU];
//    }
//}

- (void)skuBtnAction:(id)sender
{
    for (UIButton * button in self.skuBtnItems.allValues) {
        button.selected             = NO;
        button.backgroundColor      = UIColorFromRGB(0xf1f1f1);
        button.layer.borderWidth    = 0.;
    }
    
    
    UIButton * btn = (UIButton *)sender;
    
    btn.selected                = YES;
    btn.backgroundColor         = [UIColor colorFromHexString:@"#e6ecff"];
    btn.layer.borderWidth       = 1.;
    btn.layer.borderColor       = [UIColor colorFromHexString:@"#3f6ff0"].CGColor;
    
//    self.cartBtn.enabled        = YES;
    self.selectedSKU            = [self.entity.skuArray objectAtIndex:btn.tag];
    
    self.priceLabel.text        = [NSString stringWithFormat:@"￥ %.2f", self.selectedSKU.promoPrice];

    if (_SKUDelegate && [_SKUDelegate respondsToSelector:@selector(TapSKUTagWithSKU:)]) {
        [_SKUDelegate TapSKUTagWithSKU:self.selectedSKU];
    }
}


#pragma mark - <iCarouselDataSource>
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.imageURLArray.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (!view) {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0., 0., 206, 206.)];
        view.contentMode = UIViewContentModeScaleAspectFit;
    }
    NSURL * imageURL_800;
    NSURL * url = [self.imageURLArray objectAtIndex:index];
    
    if ([url.absoluteString hasPrefix:@"http://imgcdn.guoku.com/images/"]) {
        imageURL_800 = [NSURL URLWithString:[url.absoluteString imageURLWithSize:310]];
    } else {
        //        imageURL_800 = [NSURL URLWithString:[url.absoluteString stringByAppendingString:@"_800x800.jpg"]];
        imageURL_800 = [NSURL URLWithString:url.absoluteString];
    }
    [(UIImageView *)view sd_setImageWithURL:imageURL_800 placeholderImage:[UIImage imageWithColor:kPlaceHolderColor andSize:view.deFrameSize]];
    
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
