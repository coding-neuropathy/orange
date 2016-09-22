//
//  UserLikeCell.m
//  orange
//
//  Created by 谢家欣 on 16/9/9.
//  Copyright © 2016年 guoku.com. All rights reserved.
//

#import "UserLikeCell.h"
#import <iCarousel/iCarousel.h>

@interface UserLikeCell () <iCarouselDataSource, iCarouselDelegate>

@property (strong, nonatomic) iCarousel * userLikeCarousel;

@end

@implementation UserLikeCell

- (iCarousel *)userLikeCarousel
{
    if (!_userLikeCarousel) {
        _userLikeCarousel               = [[iCarousel alloc] initWithFrame:CGRectZero];
        
        _userLikeCarousel.type          = iCarouselTypeLinear;
        _userLikeCarousel.dataSource    = self;
        _userLikeCarousel.delegate      = self;
        
        [self addSubview:_userLikeCarousel];
    }
    return _userLikeCarousel;
}

- (void)setEntityArray:(NSArray *)entityArray
{
    _entityArray = entityArray;
//    if (_entityArray.count <= 1) {
    self.userLikeCarousel.scrollEnabled = _entityArray.count <= 1 ? NO : YES;
//    }
    [self.userLikeCarousel reloadData];
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.userLikeCarousel.deFrameSize   = self.contentView.deFrameSize;
}

#pragma mark - <iCarouselDataSource>
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.entityArray.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIImageView * entityImageView = (UIImageView *)view;
    if (!entityImageView) {
        entityImageView                     = [[UIImageView alloc] initWithFrame:CGRectZero];
        entityImageView.backgroundColor     = [UIColor colorFromHexString:@"#ffffff"];
        entityImageView.contentMode         = UIViewContentModeScaleAspectFit;
        
        entityImageView.layer.borderColor   = [UIColor colorFromHexString:@"#ebebeb"].CGColor;
        entityImageView.layer.borderWidth   = 0.5;
        entityImageView.layer.masksToBounds = YES;
    }
    
    if (IS_IPAD) {
        entityImageView.deFrameSize         = CGSizeMake(100., 100.);
    } else {
        entityImageView.deFrameSize         = IS_IPHONE_6P || IS_IPHONE_6 ? CGSizeMake(80., 80.) : CGSizeMake(64., 64.);
    }
    
    GKEntity * entity = [self.entityArray objectAtIndex:index];
    
    [entityImageView sd_setImageWithURL:entity.imageURL_120x120 placeholderImage:[UIImage imageWithColor:kPlaceHolderColor andSize:entityImageView.deFrameSize] options:SDWebImageRetryFailed];
    
    return entityImageView;
}


- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return YES;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.2;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.userLikeCarousel.type == iCarouselTypeCustom)
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
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    GKEntity * entity = [self.entityArray objectAtIndex:index];
    
    if (self.tapEntityImageBlock) {
        self.tapEntityImageBlock(entity);
    }
}

@end
