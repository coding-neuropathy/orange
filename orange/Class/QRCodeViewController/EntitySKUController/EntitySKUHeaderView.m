//
//  EntitySKUHeaderView.m
//  orange
//
//  Created by 谢家欣 on 16/8/23.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "EntitySKUHeaderView.h"
#import <iCarousel/iCarousel.h>


@interface EntitySKUHeaderView () <iCarouselDelegate, iCarouselDataSource>

//@property (strong, nonatomic) UIImageView   *entityImageView;
@property (strong, nonatomic) UILabel       *titleLabel;
@property (strong, nonatomic) UILabel       *pricelLabel;
@property (strong, nonatomic) UIButton      *cartBtn;

@property (strong, nonatomic) iCarousel     *imagesView;
@property (assign, nonatomic) BOOL          warp;

@end

@implementation EntitySKUHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self            = [super initWithFrame:frame];
    if (self) {
        self.warp   = NO;
    }
    return self;
}

#pragma mark - lazy load view
- (iCarousel *)imagesView
{
    if (!_imagesView) {
        _imagesView                         = [[iCarousel alloc] initWithFrame:CGRectZero];
        _imagesView.deFrameSize             = CGSizeMake(self.deFrameWidth, 206. * kScreeenScale);
        _imagesView.type                    = iCarouselTypeLinear;
        _imagesView.pagingEnabled           = YES;
        
        _imagesView.dataSource              = self;
        _imagesView.delegate                = self;
        [self addSubview:_imagesView];
    }
    return _imagesView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel                         = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.deFrameSize             = CGSizeMake(self.deFrameWidth - 48., 24.);
        _titleLabel.numberOfLines           = 1;
        _titleLabel.font                    = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.];
        _titleLabel.textColor               = UIColorFromRGB(0x212121);
        _titleLabel.textAlignment           = NSTextAlignmentLeft;
        _titleLabel.lineBreakMode           = NSLineBreakByTruncatingTail;
        
        [self addSubview:_titleLabel];
    }
    
    return _titleLabel;
}

- (UILabel *)pricelLabel
{
    if (!_pricelLabel) {
        _pricelLabel                        = [[UILabel alloc] initWithFrame:CGRectZero];
        _pricelLabel.deFrameSize            = CGSizeMake(120. * kScreeenScale, 24.);
//        _pricelLabel.layer.cornerRadius     = _pricelLabel.deFrameHeight / 2.;
        _pricelLabel.numberOfLines          = 1;
        _pricelLabel.font                   = [UIFont fontWithName:@"PingFangSC-Semibold" size:16.];
        _pricelLabel.textColor              = UIColorFromRGB(0x5976c1);
        _pricelLabel.textAlignment          = NSTextAlignmentLeft;
        
        [self addSubview:_pricelLabel];
    }
    
    return _pricelLabel;
}

- (UIButton *)cartBtn
{
    if (!_cartBtn) {
        _cartBtn                            = [UIButton buttonWithType:UIButtonTypeCustom];
        _cartBtn.deFrameSize                = CGSizeMake(128., 32.);
        _cartBtn.layer.cornerRadius         = _cartBtn.deFrameHeight / 2.;
        _cartBtn.backgroundColor            = UIColorFromRGB(0x6192ff);
        _cartBtn.titleLabel.font            = [UIFont fontWithName:@"PingFangSC-Regular" size:14.];
        
        [_cartBtn setTitle:NSLocalizedStringFromTable(@"add-cart", kLocalizedFile, nil) forState:UIControlStateNormal];
        [_cartBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        
        [self addSubview:_cartBtn];
    
    }
    
    return _cartBtn;
}


#pragma mark - set data
- (void)setEntity:(GKEntity *)entity
{
    _entity                         = entity;
    self.titleLabel.text            = self.entity.title;
    self.pricelLabel.text           = [NSString stringWithFormat:@"￥ %.2f", _entity.lowestPrice];
    
    DDLogInfo(@"image url %@", _entity.imageURLArray);
//    [self.entityImageView sd_setImageWithURL:_entity.imageURL_640x640 placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf7f7f7) andSize:self.entityImageView.deFrameSize] options:SDWebImageLowPriority];
    
    if (self.entity.imageURLArray.count > 1) {
        
        self.imagesView.scrollEnabled = YES;
    } else {
        self.imagesView.scrollEnabled = NO;
    }
    
    [self.imagesView reloadData];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imagesView.deFrameTop              = 24.;
    
    self.titleLabel.deFrameTop              = self.imagesView.deFrameBottom + 24.;
    self.titleLabel.deFrameLeft             = 24.;
    
    self.pricelLabel.deFrameTop             = self.titleLabel.deFrameBottom + 20.;
    self.pricelLabel.deFrameLeft            = self.titleLabel.deFrameLeft;
    
    self.cartBtn.center                     = self.pricelLabel.center;
    self.cartBtn.deFrameRight               = self.deFrameRight - 24.;
    
}

#pragma mark - <iCarouselDataSource>
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.entity.imageURLArray.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (!view) {
        view                        = [[UIImageView alloc] initWithFrame:CGRectZero];
        view.deFrameSize            = CGSizeMake(206. * kScreeenScale, 206. * kScreeenScale);
        view.contentMode            = UIViewContentModeScaleAspectFit;
        view.layer.masksToBounds    = YES;
    }
    NSURL * imageURL_800;
    NSURL * url = [self.entity.imageURLArray objectAtIndex:index];
    
    if ([url.absoluteString hasPrefix:@"http://imgcdn.guoku.com/images/"]) {
        imageURL_800 = [NSURL URLWithString:[url.absoluteString imageURLWithSize:800]];
    } else {
        //        imageURL_800 = [NSURL URLWithString:[url.absoluteString stringByAppendingString:@"_800x800.jpg"]];
        imageURL_800 = [NSURL URLWithString:url.absoluteString];
    }
    DDLogInfo(@"url %lu %@ ", (long)index, imageURL_800);
    [(UIImageView *)view sd_setImageWithURL:imageURL_800 placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf7f7f7) andSize:CGSizeMake(460., 460.)]];
    
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
