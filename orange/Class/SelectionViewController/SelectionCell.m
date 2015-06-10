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
#import "LoginView.h"
//#import "NewEntityViewController.h"
#import "EntityViewController.h"

#define kWidth (kScreenWidth - 20)
@interface SelectionCell()<RTLabelDelegate>
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UIImageView *tmp;
@property (nonatomic, strong) UIView *box;
//@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) RTLabel * contentLabel;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *timeButton;
@property (nonatomic, strong) UIView *H;

@end

@implementation SelectionCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
        self.backgroundColor = UIColorFromRGB(0xffffff);
//        _H = [[UIView alloc] initWithFrame:CGRectMake(0,self.frame.size.height-1, kScreenWidth, 0.5)];
//        self.H.backgroundColor = UIColorFromRGB(0xebebeb);
//        [self.contentView addSubview:self.H];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)dealloc
{
    [self removeObserver];
}

#pragma mark - components
- (UIImageView *)image
{
    if (!_image) {
        _image = [[UIImageView alloc] initWithFrame:CGRectZero];
        _image.contentMode = UIViewContentModeScaleAspectFit;
        _image.backgroundColor = [UIColor clearColor];
        _image.userInteractionEnabled = YES;
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(imageButtonAction)];
        [_image addGestureRecognizer:tap];
        [self.contentView addSubview:_image];
    }
    return _image;
}

- (RTLabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[RTLabel alloc] initWithFrame:CGRectMake(16, kScreenWidth, kScreenWidth - 32, 20)];
        _contentLabel.paragraphReplacement = @"";
        _contentLabel.lineSpacing = 7.0;
        _contentLabel.delegate = self;
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

- (void)setDict:(NSDictionary *)dict
{
    _dict = dict;

    if (self.entity) {
        [self removeObserver];
    }
    
    self.entity = dict[@"content"][@"entity"];
    [self addObserver];
    self.likeButton.selected = self.entity.liked;
    
    self.note = dict[@"content"][@"note"];
    self.contentLabel.text = [NSString stringWithFormat:@"<font face='Helvetica' color='^414243' size=14>%@</font>", self.note.text];
    
    NSTimeInterval timestamp = [dict[@"time"] doubleValue];
    self.date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    __block UIImageView *block_img = self.image;
//    __weak __typeof(&*self)weakSelf = self;
    {
        NSURL * imageURL = self.entity.imageURL_640x640;
        if (IS_IPHONE_6P) {
            imageURL = self.entity.imageURL_800x800;
        }
        
        [self.image sd_setImageWithURL:imageURL placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xf7f7f7) andSize:CGSizeMake(kScreenWidth -32, kScreenWidth-32)] options:SDWebImageRetryFailed  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,NSURL*imageURL) {
            
            UIImage * newimage = [UIImage imageWithCGImage:image.CGImage scale:2 orientation:UIImageOrientationUp];
            
            block_img.image = newimage;
//            [weakSelf.activityIndicator stopAnimating];
//            weakSelf.activityIndicator.hidden = YES;
        }];
    }
    
    
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    
//    if (!self.box) {
//        _box = [[UIView alloc] initWithFrame:CGRectMake(15.0f, 7.0f,kScreenWidth -30, 300)];
//        self.box.contentMode = UIViewContentModeScaleAspectFit;
//        self.box.backgroundColor = [UIColor whiteColor];
//        self.box.layer.borderColor = UIColorFromRGB(0xebebeb).CGColor;
//        self.box.layer.borderWidth = 0.5;
//        //[self.contentView addSubview:self.box];
//    }
    
    self.image.frame = CGRectMake(16.0f, 16.0f, kScreenWidth - 32, kScreenWidth - 32);
    
//    if(!self.contentLabel) {
//        _contentLabel = [[RTLabel alloc] initWithFrame:CGRectMake(16, kScreenWidth, kScreenWidth - 32, 20)];
//        self.contentLabel.paragraphReplacement = @"";
//        self.contentLabel.lineSpacing = 7.0;
//        self.contentLabel.delegate = self;
//        [self.contentView addSubview:self.contentLabel];
//    }
    

    self.contentLabel.deFrameHeight = self.contentLabel.optimumSize.height + 5.f;
    
    self.likeButton.frame = CGRectMake(0, 0, 40, 40.);
    self.likeButton.deFrameLeft = self.contentLabel.deFrameLeft;
    self.likeButton.deFrameTop = self.contentLabel.deFrameBottom + 12;
//    UIFont* font = [UIFont systemFontOfSize:12];
//    self.likeButton.deFrameWidth = [self.likeButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:UIColorFromRGB(0x414243)}].width+40;
    
    if (!self.timeButton) {
        _timeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160, 15)];
        self.timeButton.layer.masksToBounds = YES;
        self.timeButton.layer.cornerRadius = 2;
        self.timeButton.backgroundColor = [UIColor clearColor];
        self.timeButton.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:12];
        self.timeButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [self.timeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [self.timeButton setTitleColor:UIColorFromRGB(0x9d9e9f) forState:UIControlStateNormal];
        [self.timeButton setTitleEdgeInsets:UIEdgeInsetsMake(0,4, 0, 0)];
        [self.contentView addSubview:self.timeButton];
    }
    [self.timeButton setTitle:[NSString stringWithFormat:@"%@ %@",[NSString fontAwesomeIconStringForEnum:FAClockO],[self.date stringWithDefaultFormat]] forState:UIControlStateNormal];
    self.timeButton.center = self.likeButton.center;
    self.timeButton.deFrameRight = self.contentLabel.deFrameRight;

}


+ (CGFloat)height:(GKNote *)note
{
    RTLabel *label = [[RTLabel alloc] initWithFrame:CGRectMake(60, 15, kScreenWidth - 32, 20)];
    label.paragraphReplacement = @"";
    label.lineSpacing = 7.0;
    label.text = [NSString stringWithFormat:@"<font face='Helvetica' color='^777777' size=14>%@</font>", note.text];
    return label.optimumSize.height + kScreenWidth + 70;
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
        if (self.entity.likeCount) {
//            [self.likeButton setTitle:[NSString stringWithFormat:@"%@ %ld",[NSString stringWithFormat:NSLocalizedStringFromTable(@"like", kLocalizedFile, nil)],self.entity.likeCount] forState:UIControlStateNormal];
        }
        else
        {
//            [self.likeButton setTitle:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:NSLocalizedStringFromTable(@"like", kLocalizedFile, nil)]] forState:UIControlStateNormal];
        }

    }
    else if ([keyPath isEqualToString:@"liked"]) {
        self.likeButton.selected = self.entity.liked;
//        if(self.likeButton.selected)
//        {
//            [self.likeButton setTintColor:UIColorFromRGB(0xFF1F77)];
//        }
//        else
//        {
//            [self.likeButton setTintColor:UIColorFromRGB(0x9d9e9f)];
//        }
    }
    
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
    
    [AVAnalytics event:@"like_click" attributes:@{@"entity":self.entity.title} durations:(int)self.entity.likeCount];
    [MobClick event:@"like_click" attributes:@{@"entity":self.entity.title} counter:(int)self.entity.likeCount];
    
    [API likeEntityWithEntityId:self.entity.entityId isLike:!self.likeButton.selected success:^(BOOL liked) {
        if (liked == self.likeButton.selected) {
            [SVProgressHUD showImage:nil status:@"\U0001F603喜爱成功"];
        }
        self.likeButton.selected = liked;
        self.entity.liked = liked;
        
        if (liked) {
            [SVProgressHUD showImage:nil status:@"\U0001F603喜爱成功"];
            self.entity.likeCount = self.entity.likeCount+1;
        } else {
            self.entity.likeCount = self.entity.likeCount-1;
            [SVProgressHUD dismiss];
        }
        
//        [self.likeButton setTitle:[NSString stringWithFormat:@"%@ %lu",[NSString stringWithFormat:NSLocalizedStringFromTable(@"like", kLocalizedFile, nil)],self.entity.likeCount] forState:UIControlStateNormal];
        
//        if(self.entity.likeCount == 0)
//        {
//            [self.likeButton setTitle:[NSString stringWithFormat:NSLocalizedStringFromTable(@"like", kLocalizedFile, nil)] forState:UIControlStateNormal];
//        }
        
//        if(self.likeButton.selected)
//        {
//            [self.likeButton setTintColor:UIColorFromRGB(0xFF1F77)];
//        }
//        else
//        {
//            [self.likeButton setTintColor:UIColorFromRGB(0x9d9e9f)];
//        }



    } failure:^(NSInteger stateCode) {
        [SVProgressHUD showImage:nil status:@"喜爱失败"];
  
    }];
}

#pragma mark - button action
- (void)imageButtonAction
{
    EntityViewController * VC = [[EntityViewController alloc] init];
    VC.hidesBottomBarWhenPushed = YES;
    VC.entity = self.entity;
    [kAppDelegate.activeVC.navigationController pushViewController:VC animated:YES];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xebebeb).CGColor);
    CGContextSetLineWidth(context, kSeparateLineWidth);
    CGContextMoveToPoint(context, 0., 0.);
    CGContextAddLineToPoint(context, kScreenWidth, 0.);
    CGContextStrokePath(context);
    
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xf8f8f8).CGColor);
    CGContextSetLineWidth(context, 10.);
    CGContextMoveToPoint(context, 0., self.deFrameHeight);
    CGContextAddLineToPoint(context, kScreenWidth, self.deFrameHeight);
    
    CGContextStrokePath(context);
}




@end
