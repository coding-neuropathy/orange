//
//  CategoryGridItem.m
//  Blueberry
//
//  Created by 魏哲 on 13-9-24.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import "CategoryGridItem.h"
#import "CategoryViewController.h"


@interface CategoryGridItem()

@property (nonatomic, strong) UIImageView *categoryImageView;
@property (nonatomic, strong) UILabel *categoryNameLabel;
@property (nonatomic, strong) UIImageView *mask;
@end

@implementation CategoryGridItem


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonAction)];
        [self addGestureRecognizer:tap];
        self.backgroundColor = UIColorFromRGB(0xfafafa);
    }
    return self;
}

- (void)setCategory:(GKEntityCategory *)category
{
    _category = category;
    [self setNeedsLayout];
}
- (void)setType:(NSInteger)type
{
    _type = type;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    switch (self.type) {
        case CategoryCridItemTypeForFourWithIcon:
        {
            self.deFrameSize = CGSizeMake(kScreenWidth/4-8,kScreenWidth/4-8);
            break;
        }
        case CategoryCridItemTypeForFourWithOutIcon:
        {
            self.deFrameSize = CGSizeMake(kScreenWidth/4-8,kScreenWidth/4-8);
            break;
        }
        case CategoryCridItemTypeForThree:
        {
            self.deFrameSize = CGSizeMake(kScreenWidth/4-8,kScreenWidth/4+4);
            break;
        }
        default:
            self.deFrameSize = CGSizeMake(kScreenWidth/4-8,kScreenWidth/4-8);
            break;
    }
    if (!self.categoryImageView) {
        _categoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 32, 32)];
        _categoryImageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.width/2 -8);
        [self addSubview:self.categoryImageView];
    }
    
    if (!self.mask) {
        _mask = [[UIImageView alloc] initWithFrame:_categoryImageView.frame];
        [_mask setImage:[UIImage imageNamed:@"icon_mask.png"]];
        [self addSubview:self.mask];
    }
    
    if (!self.categoryNameLabel) {
        _categoryNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, CGRectGetHeight(self.frame) -20-4, CGRectGetWidth(self.frame), 20)];
        self.categoryNameLabel.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2+10);
        self.categoryNameLabel.backgroundColor = [UIColor clearColor];
        self.categoryNameLabel.font = [UIFont systemFontOfSize:12.f];
        self.categoryNameLabel.textAlignment = NSTextAlignmentCenter;
        self.categoryNameLabel.textColor = UIColorFromRGB(0x999999);
        [self addSubview:self.categoryNameLabel];
    }

    
    if (self.category) {
        self.hidden = NO;
        self.categoryNameLabel.text = [self.category.categoryName componentsSeparatedByString:@"-"][0];
        __block UIImageView *block_img = self.categoryImageView;
        if (self.category.iconURL) {
            self.categoryImageView.hidden = NO;
            self.categoryNameLabel.frame = CGRectMake(0.f, CGRectGetHeight(self.frame) -20-8, CGRectGetWidth(self.frame), 20);
            [self.categoryImageView sd_setImageWithURL:self.category.iconURL placeholderImage:Nil options:SDWebImageRetryFailed  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,NSURL * imageURL) {
                if (!error) {
                    if (image && cacheType == SDImageCacheTypeNone) {
                        block_img.alpha = 0.0;
                        [UIView animateWithDuration:0.25 animations:^{
                            block_img.alpha = 1.0;
                        }];
                    }
                }
            }];
        }
        else
        {
            self.categoryImageView.hidden = YES;
            self.categoryNameLabel.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        }

    } else {
        self.hidden = YES;
    }
    
    switch (self.type) {
        case CategoryCridItemTypeForFourWithIcon:
        {
            break;
        }
        case CategoryCridItemTypeForFourWithOutIcon:
        {
            self.categoryImageView.hidden = YES;
            self.categoryNameLabel.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
            break;
        }
        case CategoryCridItemTypeForThree:
        {
            break;
        }
        default:
            break;
    }
}
- (void)buttonAction
{
    CategoryViewController * VC = [[CategoryViewController alloc]init];
    VC.category = self.category;
    [kAppDelegate.activeVC.navigationController pushViewController:VC animated:YES];
}

@end
