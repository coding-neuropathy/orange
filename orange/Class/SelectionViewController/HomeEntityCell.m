//
//  HomeEntityCell.m
//  orange
//
//  Created by 谢家欣 on 15/9/7.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "HomeEntityCell.h"
#import "NSString+Helper.h"
#import "EntityViewController.h"
#import "LoginView.h"

@interface HomeEntityCell ()

@property (strong, nonatomic) UIImageView * imageView;
@property (strong, nonatomic) UILabel * titleLabel;
@property (strong, nonatomic) UILabel * detailLabel;
@property (strong, nonatomic) UILabel * tagLabel;
@property (strong, nonatomic) UIButton * likeBtn;

@property (strong, nonatomic) GKEntity * entity;
@property (strong, nonatomic) GKNote * note;
@end

@implementation HomeEntityCell

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
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(imageViewAction:)];
        [_imageView addGestureRecognizer:tap];
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 2;
        _titleLabel.textColor = UIColorFromRGB(0x414243);
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _detailLabel.font = [UIFont systemFontOfSize:14.];
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.numberOfLines = 2;
        _detailLabel.textColor = UIColorFromRGB(0x9d9e9f);
        [self.contentView addSubview:_detailLabel];
    }
    return _detailLabel;
}

- (UILabel *)tagLabel
{
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tagLabel.font = [UIFont systemFontOfSize:12.];
        _tagLabel.textAlignment = NSTextAlignmentLeft;
        _tagLabel.textColor = UIColorFromRGB(0x9d9e9f);
        [self.contentView addSubview:_tagLabel];
    }
    return _tagLabel;
}

- (UIButton *)likeBtn
{
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateSelected];
        [_likeBtn addTarget:self action:@selector(likeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_likeBtn];
    }
    return _likeBtn;
}

- (void)setData:(NSDictionary *)data
{
    if (self.entity) {
        [self removeObserver];
    }
    
    self.entity = data[@"entity"];
    self.note = data[@"note"];
    
    [self addObserver];
    
    [self.imageView sd_setImageWithURL:_entity.imageURL_310x310 placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xF0F0F0) andSize:CGSizeMake(self.imageView.deFrameWidth, self.imageView.deFrameHeight)]];
    self.titleLabel.text = _entity.title;
    self.detailLabel.text = _note.text;
    
    self.likeBtn.selected = self.entity.liked;
    
    self.tagLabel.text = @"精选商品";
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger x = 16;
    if (kScreenWidth == 320) {
        x = 10;
    }
    
    
    self.imageView.frame = CGRectMake(0., 0., kScreenWidth * 0.48, kScreenWidth * 0.48);
    self.titleLabel.frame = CGRectMake(0., 0., kScreenWidth * 0.52 - 2*x, 30.);
    self.titleLabel.deFrameHeight = [self.titleLabel.text heightWithLineWidth:self.titleLabel.deFrameWidth Font:self.titleLabel.font];
    if (self.titleLabel.deFrameHeight > 50) {
        self.titleLabel.deFrameHeight = 50;
    }

    self.titleLabel.deFrameTop = x;

    
    self.titleLabel.deFrameLeft = self.imageView.deFrameRight + x;
    
    self.detailLabel.frame = CGRectMake(0., 0., self.titleLabel.deFrameWidth, 40);
    self.detailLabel.center = self.titleLabel.center;
    if (kScreenWidth == 320) {
        self.detailLabel.deFrameTop = self.titleLabel.deFrameBottom + x - 5;
    }
    else{
        self.detailLabel.deFrameTop = self.titleLabel.deFrameBottom + x;
    }
    
    self.tagLabel.frame = CGRectMake(0., 0., 100., 44.);
    self.tagLabel.deFrameLeft = self.titleLabel.deFrameLeft;
    self.tagLabel.deFrameBottom = self.contentView.deFrameHeight;
    
    self.likeBtn.frame = CGRectMake(0., 0., 40., 44.);
    self.likeBtn.center = self.tagLabel.center;
    self.likeBtn.deFrameRight = self.contentView.deFrameWidth - 10;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xebebeb).CGColor);
    CGContextSetLineWidth(context, kSeparateLineWidth);

    CGContextMoveToPoint(context, kScreenWidth - self.imageView.deFrameWidth - 16, self.contentView.deFrameHeight - 44);
    CGContextAddLineToPoint(context, self.contentView.deFrameWidth, self.contentView.deFrameHeight - 44.);

    CGContextStrokePath(context);
}

#pragma mark - button action
- (void)imageViewAction:(id)sender
{
    [[OpenCenter sharedOpenCenter] openEntity:self.entity];
}

- (void)likeBtnAction:(id)sender
{
    if(!k_isLogin)
    {
        LoginView * view = [[LoginView alloc]init];
        [view show];
        return;
    }
    
    [AVAnalytics event:@"like_click" attributes:@{@"entity":self.entity.title} durations:(int)self.entity.likeCount];
    [MobClick event:@"like_click" attributes:@{@"entity":self.entity.title} counter:(int)self.entity.likeCount];
    
    [API likeEntityWithEntityId:self.entity.entityId isLike:!self.likeBtn.selected success:^(BOOL liked) {
        if (liked == self.likeBtn.selected) {
            [SVProgressHUD showImage:nil status:@"\U0001F603喜爱成功"];
        }
        self.likeBtn.selected = liked;
        self.entity.liked = liked;
        
        if (liked) {
            [SVProgressHUD showImage:nil status:@"\U0001F603喜爱成功"];
            self.entity.likeCount = self.entity.likeCount + 1;
        } else {
            self.entity.likeCount = self.entity.likeCount - 1;
            [SVProgressHUD dismiss];
        }
        
    } failure:^(NSInteger stateCode) {
        [SVProgressHUD showImage:nil status:NSLocalizedStringFromTable(@"like failure", kLocalizedFile, nil)];
        
    }];
}

#pragma mark - KVO
- (void)addObserver
{
//    [self.entity addObserver:self forKeyPath:@"likeCount" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [self.entity addObserver:self forKeyPath:@"liked" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver
{
//    [self.entity removeObserver:self forKeyPath:@"likeCount"];
    [self.entity removeObserver:self forKeyPath:@"liked"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"liked"]) {
        self.likeBtn.selected = self.entity.liked;
    }
    
}

@end
