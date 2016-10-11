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

@property (strong, nonatomic) NSMutableDictionary  *itemViews;
//@property (nonatomic, strong) NSMutableSet  *itemViewPool;
@property (nonatomic, strong) Class         cellClass;

@property (assign, nonatomic) NSInteger numberOfItems;

@end

@implementation ShareView

- (UIButton *)cancel
{
    if (!_cancel) {
        _cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancel.backgroundColor = [UIColor colorFromHexString:@"#f0f0f0"];
        [_cancel setTitle:NSLocalizedStringFromTable(@"cancel", kLocalizedFile, nil) forState:UIControlStateNormal];
        [_cancel setTitleColor:[UIColor colorFromHexString:@"#212121"] forState:UIControlStateNormal];
        
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
- (UIView *)dequeueItemViewIndex:(NSInteger)index
{
    UIView *view            = [self.itemViews objectForKey:@(index)];
    if (!view) {
        view                = [[self.cellClass alloc] init];
        view.deFrameSize    = [self.datasource shareView:self sizeForItemAtIndex:index];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [view addGestureRecognizer:tap];
        [self.itemViews setObject:view forKey:@(index)];
        [self addSubview:view];
    }
    return view;
}

- (void)loadCellViews
{
    CGFloat itemSpace       = [self.datasource itemSpaceInShareView];
    CGFloat margin          = [self.datasource shareViewMargin];
//    CGSize  itemSize    = [self.datasource sha]
//    NSInteger lineNumber            = 0;
    NSInteger cellNumberInLine      = 5;
    
//    for (UIView *view in self.itemViews.allValues) {
//        [view removeFromSuperview];
//    }
    
    for (NSInteger index = 0; index < self.numberOfItems; index++) {
        
        UIView *view        = [_datasource shareView:self viewForItemAtIndex:index reusingView:[self dequeueItemViewIndex:index]];

        view.deFrameLeft    = margin + (view.deFrameWidth + itemSpace) * (index % cellNumberInLine);

        view.deFrameTop     = self.titleLabel.deFrameBottom + 15. + (view.deFrameHeight + 30.) * (index / cellNumberInLine);
        view.tag            = index;


//        [self addSubview:view];
    }
}

#pragma mark - 
- (void)reloadData
{
    self.numberOfItems  = [self.datasource numberOfcellInShareView:self];
    
    for (UIView *view in self.itemViews.allValues) {
        [view removeFromSuperview];
    }
    self.itemViews = [NSMutableDictionary dictionary];

    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.center      = self.center;
    self.titleLabel.deFrameTop  = 15.;
    
    [self loadCellViews];

    self.cancel.deFrameSize = CGSizeMake(kScreenWidth, 52.);
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
#pragma mark - tap tap tap
- (void)tapAction:(UITapGestureRecognizer *)tapGesture
{
    UIView * view = [tapGesture view];
//    DDLogInfo(@"view view %ld", view.tag);
    if (_delegate && [_delegate respondsToSelector:@selector(ShareView:didSelectItemAtIndex:)]) {
        [_delegate ShareView:self didSelectItemAtIndex:view.tag];
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
