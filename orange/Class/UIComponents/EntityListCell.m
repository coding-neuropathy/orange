//
//  EntityListCell.m
//  orange
//
//  Created by 谢家欣 on 15/9/17.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "EntityListCell.h"
#import "ImageLoadingView.h"
//#import "LoginView.h"

@interface EntityListCell ()

@property (strong, nonatomic) UIImageView * imageView;
@property (strong, nonatomic) UILabel * titleLabel;
@property (strong, nonatomic) UILabel * tipLabel;
@property (strong, nonatomic) UILabel * priceLabel;
@property (strong, nonatomic) UIButton * likeBtn;

@property (strong, nonatomic) ImageLoadingView * loading;

@end

@implementation EntityListCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.contentView.backgroundColor = UIColorFromRGB(0xffffff);
        self.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return self;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageAction:)];
        [_imageView addGestureRecognizer:tap];
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16.];
        _titleLabel.textColor = UIColorFromRGB(0x414243);
        _titleLabel.numberOfLines = 2.;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.font = [UIFont fontWithName:@"Georgia" size:18.];
        _priceLabel.textColor = UIColorFromRGB(0x427ec0);
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_priceLabel];
    }
    return _priceLabel;
}

- (UIButton *)likeBtn
{
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_likeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        _likeBtn.layer.masksToBounds = YES;
        _likeBtn.layer.cornerRadius = 2;
        _likeBtn.backgroundColor = [UIColor clearColor];
        _likeBtn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14];;
        _likeBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [_likeBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        
        [_likeBtn setTitle:[NSString fontAwesomeIconStringForEnum:FAHeartO] forState:UIControlStateNormal];
        [_likeBtn setTitle:[NSString fontAwesomeIconStringForEnum:FAHeart] forState:UIControlStateSelected];
        [_likeBtn setTitleColor:UIColorFromRGB(0xFF1F77) forState:UIControlStateSelected];
        [_likeBtn setTitleColor:UIColorFromRGB(0x9d9e9f) forState:UIControlStateNormal];
        
        [_likeBtn addTarget:self action:@selector(likeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_likeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, 10)];
        [self.contentView addSubview:_likeBtn];
    }
    return _likeBtn;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:12.];
        _tipLabel.textColor = UIColorFromRGB(0x9d9e9f);
        _tipLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_tipLabel];
    }
    return _tipLabel;
}

- (ImageLoadingView *)loading {
    if(!_loading) {
        _loading = [[ImageLoadingView alloc] init];
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
    if (IS_IPHONE_6P) {
        [self.imageView sd_setImageWithURL:_entity.imageURL_310x310 placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xF0F0F0) andSize:CGSizeMake(90., 90.)] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [weakSelf.loading stopAnimating];
        }];
    } else {
        [self.imageView sd_setImageWithURL:_entity.imageURL_240x240 placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xF0F0F0) andSize:CGSizeMake(90., 90.)] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [weakSelf.loading stopAnimating];
        }];
    }
    
    self.likeBtn.selected = _entity.isLiked;
    
    self.titleLabel.text = _entity.entityName;
    GKPurchase * purchase = [_entity.purchaseArray objectAtIndex:0];
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f", purchase.lowestPrice];
    
    [self.tipLabel setText:[NSString stringWithFormat:@"%@ %ld  %@ %ld",[NSString fontAwesomeIconStringForEnum:FAHeart], (long)_entity.likeCount,[NSString fontAwesomeIconStringForEnum:FAComment], _entity.noteCount]];

    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0., 0., 90., 90.);
    self.imageView.deFrameTop = 10.;
    self.imageView.deFrameLeft = 10.;

    self.titleLabel.frame = CGRectMake(0., 0., kScreenWidth - 180., 44);
    self.titleLabel.deFrameLeft = self.imageView.deFrameRight + 10.;
    self.titleLabel.deFrameTop = self.imageView.deFrameTop;
    
    self.priceLabel.frame = CGRectMake(0., 0., 100., 20);
    self.priceLabel.deFrameLeft = self.imageView.deFrameRight + 10;
    self.priceLabel.deFrameBottom = self.contentView.deFrameBottom - 10;
    
    self.likeBtn.frame = CGRectMake(0., 0., 70., 40.);
    self.likeBtn.deFrameTop = 10.;
    self.likeBtn.deFrameRight = self.contentView.deFrameRight;
    
    self.tipLabel.frame = CGRectMake(0., 0., 80., 14);
    self.tipLabel.deFrameRight = self.contentView.deFrameRight - 10;
    self.tipLabel.deFrameBottom = self.contentView.deFrameHeight - 10;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xebebeb).CGColor);
    CGContextSetLineWidth(context, kSeparateLineWidth);
    CGContextMoveToPoint(context, 0., self.deFrameHeight);
    CGContextAddLineToPoint(context, kScreenWidth, self.deFrameHeight);
    
    CGContextStrokePath(context);
}

#pragma mark - button action
- (void)likeBtnAction:(id)sender
{
    if(!k_isLogin)
    {
//        LoginView * view = [[LoginView alloc]init];
//        [view show];
        [[OpenCenter sharedOpenCenter] openAuthPageWithSuccess:^{
            
        }];
        return;
    }
    
    
    [API likeEntityWithEntityId:self.entity.entityId isLike:!self.likeBtn.selected success:^(BOOL liked) {
        if (liked == self.likeBtn.selected) {
            //[SVProgressHUD showImage:nil status:@"\U0001F603喜爱成功"];
        }
        self.likeBtn.selected = liked;
        self.entity.liked = liked;
        if (liked) {
            //[SVProgressHUD showImage:nil status:@"\U0001F603喜爱成功"];
            self.entity.likeCount = self.entity.likeCount + 1;
        } else {
            self.entity.likeCount = self.entity.likeCount - 1;
            [SVProgressHUD dismiss];
        }
        //[self.likeButton setTitle:[NSString stringWithFormat:@" %ld",self.entity.likeCount] forState:UIControlStateNormal];
    } failure:^(NSInteger stateCode) {
        [SVProgressHUD showImage:nil status:@"喜爱失败"];
        
    }];
}

- (void)tapImageAction:(id)sender
{
    [[OpenCenter sharedOpenCenter] openEntity:self.entity];
}


@end
