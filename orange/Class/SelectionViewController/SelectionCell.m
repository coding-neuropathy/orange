       //
//  SelectionCell.m
//  Blueberry
//
//  Created by huiter on 13-11-12.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import "SelectionCell.h"
#import "RTLabel.h"
#import "API.h"
#import "EntityViewController.h"
//#import "LoginView.h"
//#import "NewEntityViewController.h"
#import "EntityViewController.h"
#import "GKNotificationHUB.h"
#import "ImageLoadingView.h"


#define kWidth (kScreenWidth - 20)
@interface SelectionCell () <RTLabelDelegate>

//@property (nonatomic, strong) UIImageView *tmp;


@property (nonatomic, strong) GKNote *note;
@property (nonatomic, strong) GKEntityCategory * category;
@property (nonatomic, strong) NSDate * date;

@property (nonatomic, strong) UILabel * contentLabel;
@property (nonatomic, strong) UIButton * likeButton;
@property (nonatomic, strong) UIButton * likeCounterButton;
//@property (nonatomic, strong) UIButton * timeButton;
@property (nonatomic, strong) UIView *H;

@property (strong, nonatomic) ImageLoadingView * loading;
@property (strong, nonatomic) UILabel * timeLabel;
@end

@implementation SelectionCell

- (ImageLoadingView *)loading {
    if(!_loading) {
        _loading = [[ImageLoadingView alloc] init];
        _loading.hidesWhenStopped = YES;
        [self.image addSubview:_loading];
    }
    return _loading;
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
//        self.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        if (IS_IPHONE) {
            self.contentView.backgroundColor = UIColorFromRGB(0xffffff);
//            self.contentView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        }
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver];
}

#pragma mark - components

- (UIView *)H
{
    if (!_H) {
        _H = [[UIView alloc] initWithFrame:CGRectZero];
        _H.backgroundColor = UIColorFromRGB(0xf8f8f8);
        [self.contentView addSubview:_H];
    }
    return _H;
}

- (UIImageView *)image
{
    if (!_image) {
        _image                          = [[UIImageView alloc] initWithFrame:CGRectZero];
        _image.deFrameSize              = CGSizeMake(self.contentView.deFrameWidth - 32., self.contentView.deFrameWidth - 32.);
        _image.contentMode              = UIViewContentModeScaleAspectFit;
        _image.backgroundColor          = [UIColor clearColor];
        _image.userInteractionEnabled   = YES;
        
        UITapGestureRecognizer* tap     = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(imageViewButtonAction)];
        [_image addGestureRecognizer:tap];
        [self.contentView addSubview:_image];
    }
    return _image;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, kScreenWidth, kScreenWidth - 32, 20)];
        _contentLabel.font = [UIFont fontWithName:@"Helvetica" size:14.];
        _contentLabel.textColor = [UIColor colorFromHexString:@"#414243"];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.numberOfLines = 3;
        _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (UIButton *)likeButton
{
    if (!_likeButton) {
        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateSelected];
        [_likeButton addTarget:self action:@selector(likeButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.likeButton];
    }
    return _likeButton;
}

- (UIButton *)likeCounterButton
{
    if (!_likeCounterButton) {
        _likeCounterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeCounterButton.titleLabel.font = [UIFont systemFontOfSize:12.];
//        _likeCounterButton.titleLabel.textColor = UIColorFromRGB(0x9d9e9f);
        [_likeCounterButton setTitleColor:[UIColor colorFromHexString:@"#9d9e9f"] forState:UIControlStateNormal];
        
        UIImage * image =[[UIImage imageNamed:@"counter"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_likeCounterButton setBackgroundImage:image forState:UIControlStateNormal];
        [_likeCounterButton setTintColor:[UIColor colorFromHexString:@"#f8f8f8"]];
        [_likeCounterButton setTitleEdgeInsets:UIEdgeInsetsMake(0., 5., 0., 0.)];
//        _likeCounterButton.enabled = NO;
        _likeCounterButton.userInteractionEnabled = NO;
        [self.contentView addSubview:_likeCounterButton];

    }
    return _likeCounterButton;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel                          = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.deFrameSize              = CGSizeMake(160., 15.);
        _timeLabel.layer.masksToBounds      = YES;
        _timeLabel.layer.cornerRadius       = 2;
        _timeLabel.backgroundColor          = [UIColor clearColor];
        _timeLabel.font                     = [UIFont fontWithName:kFontAwesomeFamilyName size:12.];
        _timeLabel.textAlignment            = NSTextAlignmentRight;
        
        _timeLabel.textColor                = [UIColor colorFromHexString:@"#9d9e9f"];
        
        [self.contentView addSubview:self.timeLabel];
    }
    return _timeLabel;
}

- (void)setDict:(NSDictionary *)dict
{
    _dict = dict;

    if (self.entity) {
        [self removeObserver];
    }
    
    self.entity = dict[@"content"][@"entity"];
    
    [self addObserver];
    self.likeButton.selected = self.entity.liked;
//    self.likeCounterLabel.text = [NSString stringWithFormat:@"%ld", self.entity.likeCount];
    
    if (self.entity.likeCount <= 0) {
        self.likeCounterButton.hidden = YES;
    } else {
        self.likeCounterButton.hidden = NO;
        [self.likeCounterButton setTitle:[NSString stringWithFormat:@"%ld", (long)self.entity.likeCount] forState:UIControlStateNormal];
    }
//    DDLogInfo(@"like count %@", self.likeCounterButton.titleLabel.text);
    
    self.note = dict[@"content"][@"note"];
//    self.contentLabel.text = [NSString stringWithFormat:@"<font face='Helvetica' color='^414243' size=14>%@</font>", self.note.text];
    self.contentLabel.text = self.note.text;
    NSTimeInterval timestamp = [dict[@"time"] doubleValue];
    self.date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
//    __block UIImageView *block_img = self.image;
    __weak __typeof(&*self)weakSelf = self;
    [self.loading startAnimating];
    {
        NSURL * imageURL = self.entity.imageURL_640x640;

        [self.image sd_setImageWithURL:imageURL
                      placeholderImage:[UIImage imageWithColor:[UIColor colorFromHexString:@"#f7f7f7"]
                            andSize:self.image.deFrameSize] options:SDWebImageRetryFailed
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,NSURL*imageURL) {
            [weakSelf.loading stopAnimating];
        }];
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.contentLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7.];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.contentLabel.text length])];
    self.contentLabel.attributedText = attributedString;
    _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [self setNeedsLayout];
    [self setNeedsDisplay];
}


#pragma mark - layout subviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.image.frame = CGRectMake(16.0f, 16.0f, self.contentView.deFrameWidth - 32, self.contentView.deFrameWidth - 32);
    self.image.deFrameLeft  = 16.;
    self.image.deFrameTop   = 16.;
    
    if (IS_IPHONE) {
//        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, kScreenWidth, kScreenWidth - 32, 20)];
        
        self.contentLabel.deFrameHeight = [self.note.text heightWithLineWidth:kScreenWidth - 32 Font:[UIFont fontWithName:@"Helvetica" size:14.] LineHeight:7];
        
        if (self.contentLabel.deFrameHeight > 65.) {
            self.contentLabel.deFrameHeight = 65.;
        }
        self.likeButton.frame = CGRectMake(0, 0, 40, 40.);
        self.likeButton.deFrameLeft = self.contentLabel.deFrameLeft-8;
        self.likeButton.deFrameTop = self.contentLabel.deFrameBottom + 12;
        
        self.likeCounterButton.frame = CGRectMake(0., 0., 40., 26.);
        self.likeCounterButton.center = self.likeButton.center;
        self.likeCounterButton.deFrameLeft = self.likeButton.deFrameRight;

        self.timeLabel.center = self.likeButton.center;
        self.timeLabel.deFrameRight = self.contentLabel.deFrameRight;
        
//        self.H.deFrameBottom = self.contentView.deFrameHeight;

        
        self.loading.center = CGPointMake(self.image.deFrameWidth/2, self.image.deFrameHeight/2);
        [self.contentView bringSubviewToFront:self.loading];
    }
    else
    {
        CGFloat imageWidth = self.deFrameWidth - 32.;
        self.image.frame = CGRectMake(16., 16., imageWidth, imageWidth);
        
        self.contentLabel.frame = CGRectMake(16., self.image.deFrameBottom + 10., imageWidth, 64.);
        //    CGFloat width = [self.likeBtn.titleLabel.text widthWithLineWidth:0. Font:self.likeBtn.titleLabel.font];
        
        self.likeButton.frame = CGRectMake(0., 0., 40, 40.);
        self.likeButton.deFrameLeft = self.contentLabel.deFrameLeft;
        self.likeButton.deFrameTop = self.contentLabel.deFrameBottom + 12;
        
        self.likeCounterButton.frame = CGRectMake(0., 0., 48., 30.);
        self.likeCounterButton.center = self.likeButton.center;
        self.likeCounterButton.deFrameLeft = self.likeButton.deFrameRight;
        
        self.timeLabel.frame = CGRectMake(0., 0., 160., 16.);
        self.timeLabel.center = self.likeButton.center;
        self.timeLabel.deFrameRight = self.contentLabel.deFrameRight;
        
    }
    [self.timeLabel setText:[NSString stringWithFormat:@"%@ %@",[NSString fontAwesomeIconStringForEnum:FAClockO],[self.date stringWithDefaultFormat]]];

    if (IS_IPHONE) {
        self.H.frame = CGRectMake(16., 0., self.deFrameWidth - 32., 1);
        self.H.deFrameBottom = self.contentView.deFrameHeight;
    }

}


+ (CGFloat)height:(GKNote *)note
{

    CGFloat height =  [note.text heightWithLineWidth:kScreenWidth - 32 Font:[UIFont fontWithName:@"Helvetica" size:14.] LineHeight:7.];
    if (height > 65) {
        return 65. + kScreenWidth + 65;
    }
    return height + kScreenWidth + 65;
}

- (void)drawRect:(CGRect)rect
{
    
    if (IS_IPAD ) {
        CGContextRef context = UIGraphicsGetCurrentContext();
    
        CGContextSetStrokeColorWithColor(context, [UIColor colorFromHexString:@"#ebebeb"].CGColor);
        CGContextSetLineWidth(context, kSeparateLineWidth);
    
        CGContextMoveToPoint(context, self.contentView.deFrameWidth, 0.);
        CGContextAddLineToPoint(context, self.contentView.deFrameWidth, self.contentView.deFrameHeight);
    
        CGContextMoveToPoint(context, 0., self.contentView.deFrameHeight);
        CGContextAddLineToPoint(context, self.contentView.deFrameWidth, self.contentView.deFrameHeight);
    
        CGContextStrokePath(context);
    }
    
    [super drawRect:rect];
}

#pragma mark - KVO
- (void)addObserver
{
    [self.entity addObserver:self forKeyPath:@"likeCount" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [self.entity addObserver:self forKeyPath:@"liked" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver
{
    [self.entity removeObserver:self forKeyPath:@"likeCount"];
    [self.entity removeObserver:self forKeyPath:@"liked"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"likeCount"]) {
        if (self.entity.likeCount <= 0) {
            self.likeCounterButton.hidden = YES;
        }
        else
        {
            self.likeCounterButton.hidden = NO;
            [self.likeCounterButton setTitle:[NSString stringWithFormat:@"%ld", (long)self.entity.likeCount] forState:UIControlStateNormal];
        }

    }
    else if ([keyPath isEqualToString:@"liked"]) {
        self.likeButton.selected = self.entity.liked;
    }
    
}

- (void)likeAction
{
    [API likeEntityWithEntityId:self.entity.entityId isLike:!self.likeButton.selected success:^(BOOL liked) {
        if (liked == self.likeButton.selected) {
            UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"liked"]];
            image.frame = self.likeButton.imageView.frame;
            [self.likeButton addSubview:image];
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                image.transform = CGAffineTransformScale(image.transform, 1.5, 1.5);
                image.deFrameTop = image.deFrameTop - 10;
                image.alpha = 0.1;
            }completion:^(BOOL finished) {
                [image removeFromSuperview];
            }];
            
        }
        self.likeButton.selected = liked;
        self.entity.liked = liked;
        
        if (liked) {
            
            UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"liked"]];
            image.frame = self.likeButton.imageView.frame;
            [self.likeButton addSubview:image];
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                image.transform = CGAffineTransformScale(image.transform, 1.5, 1.5);
                image.deFrameTop = image.deFrameTop - 10;
                image.alpha = 0.1;
            }completion:^(BOOL finished) {
                [image removeFromSuperview];
            }];
            self.entity.likeCount = self.entity.likeCount + 1;
            [MobClick event:@"like_click" attributes:@{@"entity":self.entity.title} counter:(int)self.entity.likeCount];
        } else {
            self.entity.likeCount = self.entity.likeCount - 1;
            [MobClick event:@"unlike_click" attributes:@{@"entity":self.entity.title} counter:(int)self.entity.unlikeCount];
            [SVProgressHUD dismiss];
        }
        
    } failure:^(NSInteger stateCode) {
        [SVProgressHUD showImage:nil status:NSLocalizedStringFromTable(@"like failure", kLocalizedFile, nil)];
        
    }];
}

#pragma mark - Action
- (void)likeButtonAction
{    
    if(!k_isLogin)
    {
        [[OpenCenter sharedOpenCenter] openAuthPageWithSuccess:^{
            [self likeAction];
        }];
    } else {
        [self likeAction];
    }
}

#pragma mark - button action
- (void)imageViewButtonAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(TapEntityImage:)]) {
        [_delegate TapEntityImage:self.entity];
    }
}




@end
