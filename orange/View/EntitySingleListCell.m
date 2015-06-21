//
//  EntitySingleListCell.m
//  Blueberry
//
//  Created by huiter on 13-10-23.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import "EntitySingleListCell.h"
#import <QuartzCore/QuartzCore.h>
#import "API.h"
#import "EntityViewController.h"
#import "LoginView.h"



@interface EntitySingleListCell()

@property (nonatomic, strong) UIView *imageBG;
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UILabel *brandLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel * tipLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIView *H;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIImageView * entity_mark;
@end

@implementation EntitySingleListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonAction)];
        [self addGestureRecognizer:tap];
    
        _H = [[UIView alloc] initWithFrame:CGRectMake(0,self.frame.size.height-1, kScreenWidth, 0.5)];
        self.H.backgroundColor = UIColorFromRGB(0xebebeb);
        [self.contentView addSubview:self.H];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setEntity:(GKEntity *)entity
{
    if (_entity) {
        [self removeObserver];
    }
    _entity = entity;
    [self addObserver];
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if(!self.imageBG)
    {
        self.imageBG = [[UIView alloc]initWithFrame:CGRectMake(0, 1, 114, 113)];
        self.imageBG.backgroundColor = UIColorFromRGB(0xf6f6f6);
        //[self.contentView addSubview:self.imageBG];
    }
        
    // 商品主图
    if (!self.image) {
        self.image = [[UIImageView alloc] initWithFrame:CGRectMake(7.f, 7.f, 100, 100)];
        self.image.contentMode = UIViewContentModeScaleAspectFit;
        self.image.backgroundColor = UIColorFromRGB(0xffffff);
        [self.contentView addSubview:self.image];
    }
    
    // 品牌
    if (!self.brandLabel) {
        _brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.imageBG.deFrameRight+5,10, CGRectGetWidth(self.frame) - 190, 20*2)];
        self.brandLabel.numberOfLines = 2;
        self.brandLabel.font = [UIFont systemFontOfSize:14.f];
        self.brandLabel.textAlignment = NSTextAlignmentLeft;
        self.brandLabel.textColor = UIColorFromRGB(0x555555);
        [self.contentView addSubview:self.brandLabel];
    }
    
    // 标题
    if (!self.titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.brandLabel.deFrameLeft, self.brandLabel.deFrameBottom, CGRectGetWidth(self.frame)-190, 15)];
        self.titleLabel.numberOfLines = 1;
        self.titleLabel.font = [UIFont systemFontOfSize:13.f];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.textColor = UIColorFromRGB(0x666666);
        //[self.contentView addSubview:self.titleLabel];
    }
    NSString * brand = @"";
    NSString * title = @"";
    if((![self.entity.brand isEqual:[NSNull null]])&&(![self.entity.brand isEqualToString:@""])&&(self.entity.brand))
    {
        brand = [NSString stringWithFormat:@"%@ - ",self.entity.brand];
    }
    if((![self.entity.title isEqual:[NSNull null]])&&(self.entity.title))
    {
        title = self.entity.title;
    }
    
   self.brandLabel.text = [NSString stringWithFormat:@"%@%@",brand,title];
    
    
    if(!self.priceLabel)
    {
        _priceLabel = [[UILabel alloc] initWithFrame: CGRectMake(self.brandLabel.deFrameLeft, 0, 100, 20)];
        self.priceLabel.backgroundColor = [UIColor clearColor];
        self.priceLabel.font = [UIFont fontWithName:@"Georgia" size:16];
        self.priceLabel.textAlignment = NSTextAlignmentLeft;
        self.priceLabel.textColor = UIColorFromRGB(0x5e90c8);
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", self.entity.lowestPrice];
        
        [self.contentView addSubview:self.priceLabel];
    }
    self.priceLabel.deFrameTop = self.brandLabel.deFrameBottom+10;
    self.priceLabel.deFrameLeft = self.brandLabel.deFrameLeft;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", self.entity.lowestPrice];
    [self.priceLabel sizeToFit];
    
    if(!self.tipLabel)
    {
        _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.brandLabel.deFrameLeft, 0, 80, 10)];
        self.tipLabel.textAlignment = NSTextAlignmentRight;
        self.tipLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:12];
        [self.tipLabel setBackgroundColor:[UIColor clearColor]];
        self.tipLabel.textColor = UIColorFromRGB(0xcacaca);
       [self.contentView addSubview:self.tipLabel];
    }
    [self.tipLabel setText:[NSString stringWithFormat:@"%@ %ld  %@ %ld",[NSString fontAwesomeIconStringForEnum:FAHeart],self.entity.likeCount,[NSString fontAwesomeIconStringForEnum:FAComment],self.entity.noteCount]];
    self.tipLabel.deFrameTop = self.frame.size.height - 20;
    self.tipLabel.deFrameRight = self.frame.size.width - 10;
    
    if (!self.activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityIndicator.frame = CGRectMake(0, 0, 40, 40);
        self.activityIndicator.center = self.image.center;
        self.activityIndicator.hidesWhenStopped = YES;
        self.activityIndicator.tag = 30325;
        self.activityIndicator.color = UIColorFromRGB(0xbbbbbb);
        [self.contentView insertSubview:self.activityIndicator aboveSubview:self.image];
    }
    
    [self.activityIndicator startAnimating];
    
    __weak __typeof(&*self)weakSelf = self;
    [self.image sd_setImageWithURL:self.entity.imageURL_240x240 placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,NSURL *imageURL) {
        if (!error) {
            if (image && cacheType == SDImageCacheTypeNone) {
                weakSelf.image.alpha = 0.0;
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.image.alpha = 1.0;
                }];
            }
        }
        else
        {
            [weakSelf.image sd_setImageWithURL:weakSelf.entity.imageURL];
        }
        [weakSelf.activityIndicator stopAnimating];
        weakSelf.activityIndicator.hidden = YES;

    }];
    
    if (!self.likeButton) {
        _likeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
        self.likeButton.layer.masksToBounds = YES;
        self.likeButton.layer.cornerRadius = 2;
        self.likeButton.backgroundColor = [UIColor clearColor];
        self.likeButton.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14];;
        self.likeButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [self.likeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        /*
        [self.likeButton setImage:[UIImage imageNamed:@"icon_like"] forState:UIControlStateNormal];
        [self.likeButton setImage:[UIImage imageNamed:@"icon_like"] forState:UIControlStateHighlighted|UIControlStateNormal];
        [self.likeButton setImage:[UIImage imageNamed:@"icon_like_press"] forState:UIControlStateSelected];
        [self.likeButton setImage:[UIImage imageNamed:@"icon_like_press"] forState:UIControlStateHighlighted|UIControlStateSelected];
         */
        
        [self.likeButton setTitle:[NSString fontAwesomeIconStringForEnum:FAHeartO] forState:UIControlStateNormal];
        [self.likeButton setTitle:[NSString fontAwesomeIconStringForEnum:FAHeart] forState:UIControlStateSelected];
        [self.likeButton setTitleColor:UIColorFromRGB(0xFF1F77) forState:UIControlStateSelected];
        [self.likeButton setTitleColor:UIColorFromRGB(0x9d9e9f) forState:UIControlStateNormal];
        
        [self.likeButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, 10)];
        [self.contentView addSubview:self.likeButton];
    }

    self.likeButton.selected = self.entity.liked;
    [self.likeButton addTarget:self action:@selector(likeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.likeButton.deFrameRight = self.deFrameWidth;
    self.likeButton.deFrameTop = 0;
    
    if (!self.entity_mark) {
        _entity_mark = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 33, 33)];
        _entity_mark.backgroundColor = [UIColor clearColor];
        self.entity_mark.deFrameOrigin = _image.deFrameOrigin;
        [self.contentView addSubview: self.entity_mark];
    }
    if (self.entity.mark) {
        self.entity_mark.hidden = NO;
        self.image.layer.borderWidth = 0.5;
        self.image.layer.borderColor = UIColorFromRGB(0xf1f1f1).CGColor;
        if ([self.entity.mark isEqualToString:@"promoted"]) {
            self.entity_mark.image = [UIImage imageNamed:@"entity_mark_promoted"];
        }
        else if ([self.entity.mark isEqualToString:@"first"]) {
            self.entity_mark.image = [UIImage imageNamed:@"entity_mark_first"];
        }
        else if ([self.entity.mark isEqualToString:@"event"]) {
            self.entity_mark.image = [UIImage imageNamed:@"entity_mark_event"];
        }
        else if ([self.entity.mark isEqualToString:@"media"]) {
            self.entity_mark.image = [UIImage imageNamed:@"entity_mark_media"];
        }
        else if ([self.entity.mark isEqualToString:@"celebrity"]) {
            self.entity_mark.image = [UIImage imageNamed:@"entity_mark_celebrity"];
        }
        else if ([self.entity.mark isEqualToString:@"award"]) {
            self.entity_mark.image = [UIImage imageNamed:@"entity_mark_award"];
        }
        else
        {
            self.entity_mark.hidden = YES;
            self.image.layer.borderWidth = 0;
        }

    }
    else
    {
        self.entity_mark.hidden = YES;
        self.image.layer.borderWidth = 0;
    }
    
    [self bringSubviewToFront:self.H];
    _H.deFrameBottom = self.frame.size.height;
    

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
        //[self.likeButton setTitle:[NSString stringWithFormat:@" %ld",self.entity.likeCount] forState:UIControlStateNormal];
    }
    else if ([keyPath isEqualToString:@"liked"]) {
        self.likeButton.selected = self.entity.liked;
    }
    
}

- (void)dealloc
{
    [self removeObserver];
}

#pragma mark - Action
- (void)likeButtonAction
{
    if(!k_isLogin)
    {
        LoginView * view = [[LoginView alloc]init];
        [view show];
        return;
    }
    

    [API likeEntityWithEntityId:self.entity.entityId isLike:!self.likeButton.selected success:^(BOOL liked) {
        if (liked == self.likeButton.selected) {
            [SVProgressHUD showImage:nil status:@"\U0001F603喜爱成功"];
        }
        self.likeButton.selected = liked;
        self.entity.liked = liked;
        if (liked) {
            [SVProgressHUD showImage:nil status:@"\U0001F603喜爱成功"];
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

- (void)buttonAction
{
    EntityViewController * VC = [[EntityViewController alloc]init];
    VC.entity = self.entity;
    VC.hidesBottomBarWhenPushed = YES;
    [kAppDelegate.activeVC.navigationController pushViewController:VC animated:YES];
}

+ (CGFloat)height
{
    return 114;
}

@end
