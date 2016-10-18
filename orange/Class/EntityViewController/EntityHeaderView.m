//
//  EntityHeaderView.m
//  orange
//
//  Created by 谢家欣 on 15/3/12.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "EntityHeaderView.h"
#import "NSString+Helper.h"
#import <iCarousel/iCarousel.h>

@interface EntityHeaderView () <iCarouselDelegate, iCarouselDataSource>

@property (strong, nonatomic) UILabel           *brandLabel;
@property (strong, nonatomic) UILabel           *titleLabel;
@property (strong, nonatomic) UIButton          *buyBtn;
@property (strong, nonatomic) UIButton          *likeBtn;
@property (strong, nonatomic) UIPageControl     *pageCtr;
@property (strong, nonatomic) iCarousel         *imagesView;

@property (strong, nonatomic) UIButton          *gotoEntityLikeListBtn;

@property (strong, nonatomic) NSMutableArray    *imageURLArray;
@property (assign, nonatomic) BOOL warp;

@end

static CGFloat kEntityViewMarginLeft    = 16.;


@implementation EntityHeaderView

//@synthesize delegate = _delegate;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.warp = NO;
        self.backgroundColor = [UIColor colorFromHexString:@"#ffffff"];
    }
    return self;
}

- (UILabel *)brandLabel
{
    if (!_brandLabel) {
        _brandLabel                 = [[UILabel alloc] initWithFrame:CGRectZero];
        _brandLabel.deFrameSize     = CGSizeMake(self.deFrameWidth - 32., 22.);
        _brandLabel.numberOfLines   = 1;
        _brandLabel.font            = [UIFont fontWithName:@"PingFangSC-Semibold" size:16.];
        _brandLabel.textAlignment   = NSTextAlignmentCenter;
        _brandLabel.textColor       = [UIColor colorFromHexString:@"#212121"];
        [self addSubview:_brandLabel];
    }
    return _brandLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel                 = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.deFrameSize     = CGSizeMake(self.deFrameWidth - 32., 22.);
        _titleLabel.numberOfLines   = 2;
        _titleLabel.font            =  [UIFont fontWithName:@"PingFangSC-Semibold" size:16.];
        _titleLabel.textAlignment   = NSTextAlignmentCenter;
        _titleLabel.textColor       = [UIColor colorFromHexString:@"#212121"];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIButton *)buyBtn
{
    if (!_buyBtn) {
        _buyBtn                     = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyBtn.deFrameSize         = IS_IPAD ? CGSizeMake(200., 40.) :   CGSizeMake( (kScreenWidth - 44.) / 2., 40.);
//        _buyBtn.layer.cornerRadius  = _buyBtn.deFrameHeight / 2.;
        _buyBtn.layer.cornerRadius  = 4.;
        _buyBtn.layer.masksToBounds = YES;
        _buyBtn.titleLabel.font     = [UIFont fontWithName:@"PingFangSC-Regular" size:12.];
        
        [_buyBtn setTitleColor:[UIColor colorFromHexString:@"#ffffff"] forState:UIControlStateNormal];
        [_buyBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromHexString:@"#6192ff"] andSize:_buyBtn.deFrameSize] forState:UIControlStateNormal];
        [_buyBtn addTarget:self action:@selector(buyBtnAction:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:_buyBtn];
    }
    return _buyBtn;
}

- (UIButton *)likeBtn
{
    if (!_likeBtn) {
        _likeBtn                        = [[UIButton alloc] initWithFrame:CGRectZero];
        _likeBtn.deFrameSize            = IS_IPAD ? CGSizeMake(200., 40.) : CGSizeMake( (kScreenWidth - 44.) / 2., 40.);
//        _likeBtn.layer.cornerRadius     = _likeBtn.deFrameHeight / 2.;
        _likeBtn.layer.cornerRadius     = 4.;
        _likeBtn.layer.masksToBounds    = YES;
        _likeBtn.layer.borderWidth      = 1.;
        _likeBtn.layer.borderColor      = [UIColor colorFromHexString:@"#f1f2f6"].CGColor;
        _likeBtn.titleLabel.font        = [UIFont fontWithName:@"PingFangSC-Regular" size:12.];
        [_likeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0., 0, 0., -10.)];
        
        [_likeBtn setImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"hearted"] forState:UIControlStateSelected];
        [_likeBtn setTitle:NSLocalizedStringFromTable(@"like", kLocalizedFile, nil) forState:UIControlStateNormal];
        [_likeBtn setTitleColor:[UIColor colorFromHexString:@"#757575"] forState:UIControlStateNormal];
        
        [_likeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromHexString:@"#f8f8f8"] andSize:_likeBtn.deFrameSize] forState:UIControlStateNormal];
        [_likeBtn addTarget:self action:@selector(likeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_likeBtn];
    }
    return _likeBtn;
}

- (iCarousel *)imagesView
{
    if (!_imagesView) {
        _imagesView                 = [[iCarousel alloc] initWithFrame:CGRectZero];
        _imagesView.type            = iCarouselTypeLinear;
        _imagesView.pagingEnabled   = YES;
        _imagesView.dataSource      = self;
        _imagesView.delegate        = self;
        
        [self addSubview:_imagesView];
    }
    return _imagesView;
}

- (UIPageControl *)pageCtr
{
    if (!_pageCtr) {
        _pageCtr = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pageCtr.hidden = YES;
        _pageCtr.currentPage = 0;
        _pageCtr.backgroundColor = [UIColor clearColor];
        _pageCtr.pageIndicatorTintColor = [UIColor colorFromHexString:@"#e6e6e6"];
        _pageCtr.currentPageIndicatorTintColor = [UIColor colorFromHexString:@"#5ba9ff"];
        _pageCtr.layer.cornerRadius = 16.0;
        [self addSubview:_pageCtr];
    }
    
    return _pageCtr;
}

- (UIButton *)gotoEntityLikeListBtn
{
    if (!_gotoEntityLikeListBtn) {
        _gotoEntityLikeListBtn                  = [UIButton buttonWithType:UIButtonTypeCustom];
        _gotoEntityLikeListBtn.deFrameSize      = CGSizeMake(140., 20.);
        _gotoEntityLikeListBtn.titleLabel.font  = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.];
//        _gotoEntityLikeListBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        
        [_gotoEntityLikeListBtn setTitleColor:[UIColor colorFromHexString:@"#212121"] forState:UIControlStateNormal];
        [_gotoEntityLikeListBtn addTarget:self action:@selector(gotaoEntityLikeListAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_gotoEntityLikeListBtn];
    }
    return _gotoEntityLikeListBtn;
}


#pragma mark - set Entity data
- (void)setEntity:(GKEntity *)entity
{
    _entity = entity;
    
    self.brandLabel.text    = _entity.brand;
    self.titleLabel.text    = _entity.title;
        
    self.imageURLArray = [[NSMutableArray alloc] initWithArray:_entity.imageURLArray copyItems:YES];
    if (_entity.imageURL)
        [self.imageURLArray insertObject:_entity.imageURL atIndex:0];
        
    if (self.imageURLArray.count > 1) {
        self.imagesView.scrollEnabled = YES;
    } else {
        self.imagesView.scrollEnabled = NO;
    }
    
    if (_entity.purchaseArray.count > 0) {
        GKPurchase * purchase = self.entity.purchaseArray[0];
        switch (purchase.status) {
            case GKBuyREMOVE:
            {
                [self.buyBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
                [self.buyBtn setTitle:NSLocalizedStringFromTable(@"sold out", kLocalizedFile, nil) forState:UIControlStateNormal];
                [self.buyBtn setTitleColor:[UIColor colorFromHexString:@"#212121"] forState:UIControlStateNormal];
                //                    self.buyBtn.backgroundColor = [UIColor clearColor];
                [self.buyBtn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] andSize:_buyBtn.deFrameSize] forState:UIControlStateNormal];
                self.buyBtn.enabled = NO;
            }
                break;
            case GKBuySOLDOUT:
            {
                //                    self.buyBtn.backgroundColor = UIColorFromRGB(0x9d9e9f);
                [self.buyBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromHexString:@"#9d9e9f"] andSize:_buyBtn.deFrameSize] forState:UIControlStateNormal];
                [self.buyBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
                [self.buyBtn setTitle:NSLocalizedStringFromTable(@"sold out", kLocalizedFile, nil) forState:UIControlStateNormal];
            }
                break;
            default:
            {
                [self.buyBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
                [self.buyBtn setTitle:[NSString stringWithFormat:@"¥ %0.2f 去购买", self.entity.lowestPrice] forState:UIControlStateNormal];
            }
                break;
        }
    }
    
    [self.imagesView reloadData];

    [self setNeedsLayout];
}

- (void)setEntity:(GKEntity *)entity WithLikeUser:(NSArray *)likeUsers
{
    _entity = entity;
    self.brandLabel.text    = _entity.brand;
    self.titleLabel.text    = _entity.title;
    
    if (_entity.likeCount > 0 )
        [self.gotoEntityLikeListBtn setTitle:[NSString stringWithFormat:@"%ld 人喜爱 >", _entity.likeCount] forState:UIControlStateNormal];
    //        self.gotoEntityLikeListBtn.backgroundColor = [UIColor redColor];
        CGFloat width = [self.gotoEntityLikeListBtn.titleLabel.text widthWithLineWidth:0. Font:self.gotoEntityLikeListBtn.titleLabel.font];
        self.gotoEntityLikeListBtn.deFrameSize  = CGSizeMake(width, 20.);
    
    if (_entity.isLiked) {
        self.likeBtn.selected = YES;
    }
    
    NSInteger count = likeUsers.count > 4 ? 4 : likeUsers.count;
    
    for (int i = 0; i < count; i ++) {
        UIImageView * avatarImage       = [[UIImageView alloc] initWithFrame:CGRectZero];
        avatarImage.deFrameSize         = CGSizeMake(32., 32.);
        avatarImage.layer.cornerRadius  = avatarImage.deFrameHeight / 2.;
        avatarImage.layer.borderWidth   = 2.;
        avatarImage.layer.borderColor   = [UIColor colorFromHexString:@"#ffffff"].CGColor;
        avatarImage.layer.masksToBounds = YES;
        GKUser * user = [likeUsers objectAtIndex:i];
        
        [avatarImage sd_setImageWithURL:user.avatarURL placeholderImage:[UIImage imageWithColor:kPlaceHolderColor andSize:avatarImage.deFrameSize] options:SDWebImageRetryFailed];
        
        avatarImage.deFrameLeft         = 16. + i * 24.;
        avatarImage.deFrameBottom       = self.deFrameHeight - 16.;
        
        [self insertSubview:avatarImage atIndex:count - i];
    }
    
    if (_entity.purchaseArray.count > 0) {
        GKPurchase * purchase = self.entity.purchaseArray[0];
        switch (purchase.status) {
            case GKBuyREMOVE:
            {
                [self.buyBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
                [self.buyBtn setTitle:NSLocalizedStringFromTable(@"sold out", kLocalizedFile, nil) forState:UIControlStateNormal];
                [self.buyBtn setTitleColor:[UIColor colorFromHexString:@"#212121"] forState:UIControlStateNormal];
                //                    self.buyBtn.backgroundColor = [UIColor clearColor];
                [self.buyBtn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] andSize:_buyBtn.deFrameSize] forState:UIControlStateNormal];
                self.buyBtn.enabled = NO;
            }
                break;
            case GKBuySOLDOUT:
            {
                //                    self.buyBtn.backgroundColor = UIColorFromRGB(0x9d9e9f);
                [self.buyBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromHexString:@"#9d9e9f"] andSize:_buyBtn.deFrameSize] forState:UIControlStateNormal];
                [self.buyBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
                [self.buyBtn setTitle:NSLocalizedStringFromTable(@"sold out", kLocalizedFile, nil) forState:UIControlStateNormal];
            }
                break;
            default:
            {
                [self.buyBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
                [self.buyBtn setTitle:[NSString stringWithFormat:@"¥ %0.2f 去购买", self.entity.lowestPrice] forState:UIControlStateNormal];
            }
                break;
        }
    }
    
    
    self.imageURLArray = [[NSMutableArray alloc] initWithArray:_entity.imageURLArray copyItems:YES];
    if (_entity.imageURL)
        [self.imageURLArray insertObject:_entity.imageURL atIndex:0];
    
    if (self.imageURLArray.count > 1) {
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
//    DDLogInfo(@"header view width %f", self.deFrameWidth);
    if (IS_IPHONE) {
        CGFloat titleHeight = [self.titleLabel.text heightWithLineWidth:kScreenWidth - 32 Font:self.titleLabel.font LineHeight:5];
        
        self.imagesView.deFrameSize     = CGSizeMake(kScreenWidth, kScreenWidth);

        self.brandLabel.deFrameTop      = 24. + self.imagesView.deFrameBottom;
        self.brandLabel.deFrameLeft     = 16.;
        
        self.titleLabel.center          = self.brandLabel.center;
        self.titleLabel.deFrameHeight   = titleHeight;
        self.titleLabel.deFrameTop      = self.brandLabel.deFrameBottom + 8.;

        self.buyBtn.deFrameLeft         = (self.deFrameWidth - self.buyBtn.deFrameWidth - self.likeBtn.deFrameWidth) / 2.;
        self.buyBtn.deFrameTop          = self.titleLabel.deFrameBottom + 24.;
        
        self.likeBtn.center             = self.buyBtn.center;
        self.likeBtn.deFrameLeft        = self.buyBtn.deFrameRight + 8.;
        
        if ([_entity.imageURLArray count] > 0) {
            self.pageCtr.numberOfPages = [_entity.imageURLArray count] + 1;
            self.pageCtr.center = CGPointMake(kScreenWidth / 2., self.imagesView.deFrameBottom -10);
            self.pageCtr.bounds = CGRectMake(0.0, 0.0, 32 * (_pageCtr.numberOfPages - 1) + 32, 32);
            self.pageCtr.hidden = NO;
        }
        
        self.gotoEntityLikeListBtn.deFrameRight     = self.deFrameWidth - 36.;
        self.gotoEntityLikeListBtn.deFrameBottom    = self.deFrameHeight - 22.;
    }
    else
    {
        self.imagesView.frame           = CGRectMake(0., 20., self.deFrameWidth, 460.);
        
        self.brandLabel.center          = self.imagesView.center;
        self.brandLabel.deFrameTop      = 20. + self.imagesView.deFrameBottom;
        
        
//        self.titleLabel.frame = CGRectMake(0., 0., self.deFrameWidth - 40., 20);
        self.titleLabel.center          = self.brandLabel.center;
//        self.titleLabel.deFrameLeft = 20.;
        self.titleLabel.deFrameTop      = self.brandLabel.deFrameBottom + 5.;
        
        self.buyBtn.deFrameLeft         = 136.;
        self.buyBtn.deFrameTop          = self.titleLabel.deFrameBottom + 32.;
//        
        self.likeBtn.center             = self.buyBtn.center;
        self.likeBtn.deFrameRight       = self.deFrameWidth - 136.;
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
        view                        = [[UIImageView alloc] initWithFrame:CGRectZero];

        view.deFrameSize            = IS_IPAD ? CGSizeMake(460., 460.) : CGSizeMake(kScreenWidth, kScreenWidth);
        view.contentMode            = IS_IPAD ? UIViewContentModeScaleAspectFit : UIViewContentModeScaleAspectFill;
        view.layer.masksToBounds    = YES;
    }
    NSURL * imageURL_800;
    NSURL * url = [self.imageURLArray objectAtIndex:index];
    
    if ([url.absoluteString hasPrefix:@"http://imgcdn.guoku.com/images/"]) {
        imageURL_800 = IS_IPAD  ? [NSURL URLWithString:[url.absoluteString imageURLWithSize:800]]
                                : [NSURL URLWithString:[url.absoluteString imageURLWithSize:640]];
        
    } else {
        //        imageURL_800 = [NSURL URLWithString:[url.absoluteString stringByAppendingString:@"_800x800.jpg"]];
        imageURL_800 = [NSURL URLWithString:url.absoluteString];
    }
//    view.contentMode            = UIViewContentModeScaleAspectFill;

    DDLogInfo(@"url %lu %@ ", (long)index, imageURL_800);
    [(UIImageView *)view sd_setImageWithURL:imageURL_800
                           placeholderImage:[UIImage imageWithColor:kPlaceHolderColor
                            andSize:view.deFrameSize]];
    
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
            
            value = IS_IPAD ? value * 1.03 : value * 1.1;
            return value;
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

#pragma mark - <iCarouselDelegate>
//- (void)ca
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    if (IS_IPHONE) {
        if (_delegate && [_delegate respondsToSelector:@selector(handelTapImageWithIndex:)]) {
//            DDLogInfo(@"select item index %ld", index);
            [_delegate handelTapImageWithIndex:index];
        }
    }
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    NSInteger index = fabs(carousel.scrollOffset);
    [self.pageCtr setCurrentPage:index];
}

#pragma mark - button action
- (void)buyBtnAction:(id)sender
{
    if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(TapBuyButtonActionWithEntity:)]) {
        [_actionDelegate TapBuyButtonActionWithEntity:self.entity];
    }
}

- (void)likeBtnAction:(id)sender
{
    if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(TapLikeButtonWithEntity:Button:)]) {
        [_actionDelegate TapLikeButtonWithEntity:self.entity Button:self.likeBtn];
    }
}

- (void)gotaoEntityLikeListAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(handleGotoEntityLikeListBtn:)]) {
        [_delegate handleGotoEntityLikeListBtn:sender];
    }
}


#pragma mark - class method
+ (CGFloat)headerViewHightWithEntity:(GKEntity *)entity
{
    CGFloat titleHeight = [entity.title heightWithLineWidth:kScreenWidth - kEntityViewMarginLeft * 2.  Font:[UIFont fontWithName:@"PingFangSC-Semibold" size:17.f] LineHeight:5];
    if (titleHeight == 0 ) {
        titleHeight = 16.;
    }
    
    CGFloat brandHeight = [entity.brand heightWithLineWidth:kScreenWidth - 32. Font:[UIFont fontWithName:@"PingFangSC-Semibold" size:17.] LineHeight:5];
    if (brandHeight != 0) {
        brandHeight += 8;
    }
    
    if (entity.likeCount > 0) {
        return kScreenWidth + 123. + titleHeight + brandHeight + 64.;
    } else {
        return kScreenWidth + 123. + titleHeight + brandHeight;
    }
}

@end
