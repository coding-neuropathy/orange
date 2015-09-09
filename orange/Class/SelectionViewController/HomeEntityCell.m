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

@interface HomeEntityCell ()

@property (strong, nonatomic) UIImageView * imageView;
@property (strong, nonatomic) UILabel * titleLabel;
@property (strong, nonatomic) UILabel * detailLabel;
@property (strong, nonatomic) UILabel * tagLabel;
@property (strong, nonatomic) UIButton * likeBtn;

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
        [self.contentView addSubview:_likeBtn];
    }
    return _likeBtn;
}

- (void)setEntity:(GKEntity *)entity
{
    
    _entity = entity;
 
    [self.imageView sd_setImageWithURL:_entity.imageURL_310x310];
    self.titleLabel.text = _entity.title;
    self.tagLabel.text = @"精选商品";
//    self.tagLabel.text = NSLocalizedStringFromTable(@"selected", kLocalizedFile, nil);
//    self.detailLabel.textColor = _entity.description;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0., 0., kScreenWidth * 0.48, kScreenWidth * 0.48);
    self.titleLabel.frame = CGRectMake(0., 0., kScreenWidth * 0.44, 30.);
//    CGFloat titleHeight =  [self.titleLabel.text heightWithLineWidth:self.titleLabel.deFrameWidth Font:self.titleLabel.font];
    self.titleLabel.deFrameHeight = [self.titleLabel.text heightWithLineWidth:self.titleLabel.deFrameWidth Font:self.titleLabel.font];
    self.titleLabel.deFrameTop = 16.;
    self.titleLabel.deFrameLeft = self.imageView.deFrameRight + 10;
    
    self.tagLabel.frame = CGRectMake(0., 0., 100., 20.);
    self.tagLabel.deFrameLeft = self.titleLabel.deFrameLeft;
    self.tagLabel.deFrameBottom = self.contentView.deFrameHeight - 10;
    
    self.likeBtn.frame = CGRectMake(0., 0., 40., 40.);
    self.likeBtn.center = self.tagLabel.center;
    self.likeBtn.deFrameRight = self.contentView.deFrameWidth - 10;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xebebeb).CGColor);
    CGContextSetLineWidth(context, kSeparateLineWidth);

    CGContextMoveToPoint(context, 190., self.contentView.deFrameHeight - 60);
    CGContextAddLineToPoint(context, self.contentView.deFrameWidth, self.contentView.deFrameHeight - 60.);

    CGContextStrokePath(context);
}

#pragma mark - button action
- (void)imageViewAction:(id)sender
{
    [[OpenCenter sharedOpenCenter] openEntity:self.entity];
//    EntityViewController * VC = [[EntityViewController alloc] initWithEntity:self.entity];
//    VC.hidesBottomBarWhenPushed = YES;
//    //    VC.entity = self.entity;
//    [kAppDelegate.activeVC.navigationController pushViewController:VC animated:YES];
}

@end
