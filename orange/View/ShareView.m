//
//  ShareView.m
//  orange
//
//  Created by huiter on 15/7/5.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "ShareView.h"


@interface ShareView ()

@property (strong, nonatomic) UILabel   *titleLabel;
@property (strong, nonatomic) UIButton  *cancel;

@property (nonatomic, strong) NSMutableSet *itemViewPool;
@property (nonatomic, strong) Class cellClass;

@property (assign, nonatomic) NSInteger numberOfItems;

@end

@implementation ShareView

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self reloadData];
//    }
//    return self;
//}


- (UIButton *)cancel
{
    if (!_cancel) {
        _cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancel.deFrameSize = CGSizeMake(kScreenWidth, 52.);
        _cancel.backgroundColor = [UIColor colorFromHexString:@"#f0f0f0"];
        [_cancel setTitle:NSLocalizedStringFromTable(@"cancel", kLocalizedFile, nil) forState:UIControlStateNormal];
        [_cancel setTitleColor:[UIColor colorFromHexString:@"#414243"] forState:UIControlStateNormal];
        
        [_cancel addTarget:self action:@selector(TapCancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];

        _cancel.titleLabel.font = [UIFont systemFontOfSize:16];
        
        [self addSubview:_cancel];
    }
    return _cancel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel                 = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.text            = NSLocalizedStringFromTable(@"share", kLocalizedFile, nil);
        
        CGFloat titleWidth          = [_titleLabel.text widthWithLineWidth:0. Font:_titleLabel.font];
        _titleLabel.deFrameSize     = CGSizeMake(titleWidth, 30.);
        _titleLabel.textColor       = [UIColor colorFromHexString:@"#9d9e9f"];
        _titleLabel.textAlignment   = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        //        title.center = line.center;
        [self addSubview:_titleLabel];
    }
    
    return _titleLabel;
}

- (void)setDatasource:(id<ShareViewDataSource>)datasource
{
    _datasource = datasource;
    if (_datasource) {
        [self reloadData];
    }
}

- (void)registerClass:(nullable Class)cellClass
{
//    Class = cellClass;
    self.cellClass  = cellClass;
}

#pragma mark -
#pragma mark View queing

- (void)queueItemView:(UIView *)view
{
    if (view)
    {
        [_itemViewPool addObject:view];
    }
}

- (UIView *)dequeueItemView
{
    UIView *view = [_itemViewPool anyObject];
    if (view)
    {
        [_itemViewPool removeObject:view];
    }
    return view;
}

- (UIView *)dequeueItemViewIndex:(NSInteger)index
{
    UIView * view       = [[self.cellClass alloc] init];
    view.deFrameSize    = [self.datasource shareView:self sizeForItemAtIndex:index];
    [self queueItemView:view];
    return view;
}

- (void)loadCellViews
{
    CGFloat itemSpace       = [self.datasource itemSpaceInShareView];
    CGFloat margin          = [self.datasource shareViewMargin];
//    CGSize  itemSize    = [self.datasource sha]
//    NSInteger lineNumber            = 0;
    NSInteger cellNumberInLine      = 5;
    
    for (NSInteger index = 0; index < self.numberOfItems; index++) {
        
        UIView *view        = [_datasource shareView:self viewForItemAtIndex:index reusingView:[self dequeueItemView]];

        view.deFrameLeft    = margin + (view.deFrameWidth + itemSpace) * (index % cellNumberInLine);

        view.deFrameTop     = self.titleLabel.deFrameBottom + 15. + (view.deFrameHeight + 30.) * (index / cellNumberInLine);
//        view.tag            = index;
        [self addSubview:view];
    }
}

#pragma mark - 
- (void)reloadData
{
    self.numberOfItems  = [self.datasource numberOfcellInShareView:self];
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.center      = self.center;
    self.titleLabel.deFrameTop  = 15.;
    
    [self loadCellViews];
    
    
//    {
//    
//        NSInteger width = (kScreenWidth -30 - 12*4)/5;
//        UIButton * icon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, width)];
//        [icon setImage:[UIImage imageNamed:@"share_moment.png"] forState:UIControlStateNormal];
//        [icon addTarget:self action:@selector(ShareActionForMoment:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:icon];
//        
//        icon.center = CGPointMake(15+ width/2, width/2+62);
//        
//        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, 60, 30)];
//        title.text = NSLocalizedStringFromTable(@"wechat-moments", kLocalizedFile, nil);
//        title.font = [UIFont systemFontOfSize:10];
//        title.numberOfLines = 0;
//        title.textColor = UIColorFromRGB(0x000000);
//        title.textAlignment = NSTextAlignmentCenter;
//        title.backgroundColor = [UIColor clearColor];
//        [title sizeToFit];
//        [self addSubview:title];
//        
//        title.center = icon.center;
//        title.deFrameTop = icon.deFrameBottom + 10;
//    }
//    
//    {
//        
//        NSInteger width = (kScreenWidth -30 - 12*4)/5;
//        UIButton * icon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, width)];
//        [icon setImage:[UIImage imageNamed:@"share_wechat.png"] forState:UIControlStateNormal];
//        [icon addTarget:self action:@selector(ShareActionForWechat:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:icon];
//        
//        icon.center = CGPointMake(15+ width*3/2+12, width/2+62);
//        
//        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, 60, 30)];
//        title.text = NSLocalizedStringFromTable(@"wechat", kLocalizedFile, nil);
//        title.font = [UIFont systemFontOfSize:10];
//        title.numberOfLines = 0;
//        title.textColor = UIColorFromRGB(0x000000);
//        title.textAlignment = NSTextAlignmentCenter;
//        title.backgroundColor = [UIColor clearColor];
//        [title sizeToFit];
//        [self addSubview:title];
//        
//        title.center = icon.center;
//        title.deFrameTop = icon.deFrameBottom + 10;
//    }
//    
//    {
//        
//        NSInteger width = (kScreenWidth -30 - 12*4)/5;
//        UIButton * icon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, width)];
//        [icon setImage:[UIImage imageNamed:@"share_weibo.png"] forState:UIControlStateNormal];
//        [icon addTarget:self action:@selector(ShareActionForWeibo:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:icon];
//        
//        icon.center = CGPointMake(15+ width*5/2+12*2, width/2+62);
//        
//        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, 60, 30)];
//        title.text = NSLocalizedStringFromTable(@"weibo", kLocalizedFile, nil);
//        title.font = [UIFont systemFontOfSize:10];
//        title.numberOfLines = 0;
//        title.textColor = UIColorFromRGB(0x000000);
//        title.textAlignment = NSTextAlignmentCenter;
//        title.backgroundColor = [UIColor clearColor];
//        [title sizeToFit];
//        [self addSubview:title];
//        
//        title.center = icon.center;
//        title.deFrameTop = icon.deFrameBottom + 10;
//    }
//    
//    {
//        
//        NSInteger width = (kScreenWidth -30 - 12*4)/5;
//        UIButton * icon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, width)];
//        [icon setImage:[UIImage imageNamed:@"share_safari.png"] forState:UIControlStateNormal];
//        [icon addTarget:self action:@selector(ShareActionForSafari:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:icon];
//        
//        icon.center = CGPointMake(15+ width*7/2+12*3, width/2+62);
//        
//        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, 60, 30)];
//        title.text = @"在 Safari 中打开";
//        title.font = [UIFont systemFontOfSize:10];
//        title.numberOfLines = 0;
//        title.textColor = UIColorFromRGB(0x000000);
//        title.textAlignment = NSTextAlignmentCenter;
//        title.backgroundColor = [UIColor clearColor];
//        [title sizeToFit];
//        [self addSubview:title];
//        
//        title.center = icon.center;
//        title.deFrameTop = icon.deFrameBottom + 10;
//    }
//    
//    {
//        
//        NSInteger width = (kScreenWidth -30 - 12*4)/5;
//        UIButton * icon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, width)];
//        [icon setImage:[UIImage imageNamed:@"share_mail.png"] forState:UIControlStateNormal];
//        [icon addTarget:self action:@selector(ShareActionForMail:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:icon];
//        
//        icon.center = CGPointMake(15+ width*9/2+12*4, width/2+62);
//        
//        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, 60, 30)];
//        title.text = NSLocalizedStringFromTable(@"mail", kLocalizedFile, nil);
//        title.font = [UIFont systemFontOfSize:10];
//        title.numberOfLines = 0;
//        title.textColor = [UIColor colorFromHexString:@"#212121"];
//        title.textAlignment = NSTextAlignmentCenter;
//        title.backgroundColor = [UIColor clearColor];
//        [title sizeToFit];
//        [self addSubview:title];
//        
//        title.center = icon.center;
//        title.deFrameTop = icon.deFrameBottom + 10;
//    }
//    
////    {
////        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(15,  178, kScreenWidth - 30, 0.5)];
////        line.backgroundColor = UIColorFromRGB(0xe6e6e6);
////        [self.board addSubview:line];
////    }
//    
//    {
//        NSInteger width = (kScreenWidth -30 - 12*4)/5;
//        UIButton * icon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, width)];
//        [icon setImage:[UIImage imageNamed:@"share_refresh.png"] forState:UIControlStateNormal];
//        [icon addTarget:self action:@selector(ShareActionForRefresh:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:icon];
//        
//        icon.center = CGPointMake(15+ width/2, width/2+202);
//        
//        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, 60, 30)];
//        title.text = NSLocalizedStringFromTable(@"refresh", kLocalizedFile, nil);
//        title.font = [UIFont systemFontOfSize:10];
//        title.numberOfLines = 0;
//        title.textColor = UIColorFromRGB(0x000000);
//        title.textAlignment = NSTextAlignmentCenter;
//        title.backgroundColor = [UIColor clearColor];
//        [title sizeToFit];
//        [self addSubview:title];
//        
//        title.center = icon.center;
//        title.deFrameTop = icon.deFrameBottom + 10;
//    }
//    
//    {
//        
//        NSInteger width = (kScreenWidth -30 - 12*4)/5;
//        UIButton * icon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, width)];
//        [icon setImage:[UIImage imageNamed:@"share_copy.png"] forState:UIControlStateNormal];
//        [icon addTarget:self action:@selector(ShareActionForCopy:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:icon];
//        
//        icon.center = CGPointMake(15+ width*3/2+12, width/2+202);
//        
//        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, width, 30)];
//        title.text = @"复制链接";
//        title.font = [UIFont systemFontOfSize:10];
//        title.numberOfLines = 0;
//        title.textColor = [UIColor colorFromHexString:@"#212121"];
//        title.textAlignment = NSTextAlignmentCenter;
//        title.backgroundColor = [UIColor clearColor];
//        [title sizeToFit];
//        [self addSubview:title];
//        
//        title.center = icon.center;
//        title.deFrameTop = icon.deFrameBottom + 10;
//    }
//    
////    if(![self.type isEqualToString:@"url"]){
//    if (self.type == EntityType) {
//        NSInteger width = (kScreenWidth -30 - 12*4)/5;
//        UIButton * icon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, width)];
//        [icon setImage:[UIImage imageNamed:@"share_report.png"] forState:UIControlStateNormal];
//        [icon addTarget:self action:@selector(ShareActionForReport:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:icon];
//        
//        icon.center = CGPointMake(15+ width*5/2+12*2, width/2+202);
//        
//        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, 60, 30)];
//        title.text = NSLocalizedStringFromTable(@"tipoff", kLocalizedFile, nil);
//        title.font = [UIFont systemFontOfSize:10];
//        title.numberOfLines = 0;
//        title.textColor = UIColorFromRGB(0x000000);
//        title.textAlignment = NSTextAlignmentCenter;
//        title.backgroundColor = [UIColor clearColor];
//        [title sizeToFit];
//        [self addSubview:title];
//        
//        title.center = icon.center;
//        title.deFrameTop = icon.deFrameBottom + 10;
//    }

    
    self.cancel.deFrameBottom = self.deFrameHeight;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorFromHexString:@"#e6e6e6"].CGColor);
    CGContextSetLineWidth(context, kSeparateLineWidth);
    
    CGContextMoveToPoint(context, 15., 30.);
    CGContextAddLineToPoint(context, self.titleLabel.deFrameLeft - 10., 30.);
    
    CGContextMoveToPoint(context, self.titleLabel.deFrameRight + 10., 30.);
    CGContextAddLineToPoint(context, self.deFrameWidth - 15., 30.);
    
    CGContextStrokePath(context);
    
}


#pragma mark - button action

-(void)ShareActionForMoment:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(handleShareOnMomentsAction:)]) {
        [_delegate handleShareOnMomentsAction:sender];
    }
}

-(void)ShareActionForWechat:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(handleShareToWeChat:)]) {
        [_delegate handleShareToWeChat:sender];
    }
}

-(void)ShareActionForWeibo:(id)sender
{
//    [self weiboShare];
//    [self dismiss];
    if (_delegate && [_delegate respondsToSelector:@selector(handleShareToWeibo:)]) {
        [_delegate handleShareToWeibo:sender];
    }
}

-(void)ShareActionForSafari:(id)sender
{
//    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.url]];
//    [self dismiss];
    if (_delegate && [_delegate respondsToSelector:@selector(handleOpenInSafari:)]) {
        [_delegate handleOpenInSafari:sender];
    }
}

-(void)ShareActionForMail:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(handleSendMail:)]) {
        [_delegate handleSendMail:sender];
    }

}


-(void)ShareActionForRefresh:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(handlePageRefreshRequest:)])
    {
        [_delegate handlePageRefreshRequest:sender];
    }
}

-(void)ShareActionForCopy:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(handlerCopyURL:)]) {
        [_delegate handlerCopyURL:sender];
    }
}

-(void)ShareActionForReport:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(handlerTipOff:)]) {
        [_delegate handlerTipOff:sender];
    }
}

#pragma mark - button action
- (void)TapCancelBtnAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(handleCancelBtnAction:)]) {
        [_delegate handleCancelBtnAction:sender];
    }
}


@end
