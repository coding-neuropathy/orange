//
//  WelcomeViewController.m
//  pomelo
//
//  Created by 谢家欣 on 15/6/2.
//  Copyright (c) 2015年 guoku. All rights reserved.
//

#import "WelcomeViewController.h"

#define NUMBER_OF_PAGES 4

#define timeForPage(page) (NSInteger)(self.view.frame.size.width * (page - 1))

static CGFloat LabelMargin = 50.;

@interface WelcomeViewController ()

//@property (strong, nonatomic) UIImageView *wordmark;
//@property (strong, nonatomic) UIImageView *unicorn;

@property (strong, nonatomic) UIImageView * firstImageView;
@property (strong, nonatomic) UIImageView * firstDetailImageView;
@property (strong, nonatomic) UILabel * firstLabel;
@property (strong, nonatomic) UILabel * firstDetailLabel;

@property (strong, nonatomic) UIImageView * secondImageView;
@property (strong, nonatomic) UIImageView * secondDetailImageView;
@property (strong, nonatomic) UIImageView * secondCaseImageView;
@property (strong, nonatomic) UILabel * secondLabel;
@property (strong, nonatomic) UILabel * secondDetailLabel;

@property (strong, nonatomic) UIImageView * thirdImageView;
@property (strong, nonatomic) UIImageView * thirdDetailImageView;
@property (strong, nonatomic) UILabel * thirdLabel;
@property (strong, nonatomic) UILabel * thirdDetailLabel;

@property (strong, nonatomic) UILabel * lastLabel;
@property (strong, nonatomic) UILabel * lastDetailLabel;
@property (strong, nonatomic) UIImageView * beginIcon;
@property (strong, nonatomic) UILabel * verLabel;
@property (strong, nonatomic) UIButton * beginBtn;

@property (strong, nonatomic) UIPageControl * pageControl;

@end


@implementation WelcomeViewController

#pragma mark - IFTTTAnimatedScrollViewControllerDelegate

- (id)init
{
    if ((self = [super init])) {
//        self.animator = [IFTTTAnimation new];
//        self.animator = [IFTTTAnimator new];
    
    }
    
    return self;
}


- (void)loadView
{
    [super loadView];
    if (IS_IPAD) {
        self.view.frame = CGRectMake(0., 0., 512., 686);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.scrollView.contentSize = CGSizeMake(NUMBER_OF_PAGES * CGRectGetWidth(self.view.frame),
                                             CGRectGetHeight(self.view.frame));
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.accessibilityLabel = @"JazzHands";
    self.scrollView.accessibilityIdentifier = @"JazzHands";

    if (IS_IPHONE_6)
        [self placeViewsI6];
    else if (IS_IPHONE_6P)
        [self placeViewsI6P];
    else
        [self placeViews];
    [self configureAnimation];
    
    self.delegate = self;
    
    // PageControl
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.f, 0.f, 100.f, 10.f)];
    self.pageControl.center = self.view.center;
    self.pageControl.backgroundColor = [UIColor blackColor];
    [self.pageControl setDeFrameBottom:self.view.deFrameHeight - 30.];
    self.pageControl.backgroundColor = [UIColor clearColor];
    self.pageControl.userInteractionEnabled = NO;
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = 4;
    self.pageControl.pageIndicatorTintColor = UIColorFromRGB(0xebebeb);
    self.pageControl.currentPageIndicatorTintColor = UIColorFromRGB(0xadaeaf);
    [self.view addSubview:self.pageControl];
    [self.view bringSubviewToFront:self.pageControl];
}

#pragma mark - iphone 6P
- (void)placeViewsI6P
{
    self.firstImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"6P01-01"]];
    
    self.firstImageView.frame = CGRectMake(0., 46., self.firstImageView.image.size.width, self.firstImageView.image.size.height);
    [self.scrollView addSubview:self.firstImageView];
    
    self.firstDetailImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"6P01-02"]];
    self.firstDetailImageView.frame = CGRectMake(0., 0., self.firstDetailImageView.image.size.width, self.firstDetailImageView.image.size.height);
    self.firstDetailImageView.deFrameBottom = self.firstImageView.deFrameBottom;
    [self.scrollView addSubview:self.firstDetailImageView];
    
    self.firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(LabelMargin, 0., self.view.deFrameWidth - LabelMargin, 20.)];
    self.firstLabel.text = @"精选，真正的流行";
    self.firstLabel.textColor = UIColorFromRGB(0x414243);
    self.firstLabel.font = [UIFont systemFontOfSize:18.];
    self.firstLabel.textAlignment = NSTextAlignmentLeft;
    self.firstLabel.deFrameTop = 480.;
    [self.scrollView addSubview:self.firstLabel];
    
    self.firstDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0., 0., self.view.deFrameWidth - LabelMargin, 40.)];
    self.firstDetailLabel.font = [UIFont systemFontOfSize:14.];
    self.firstDetailLabel.textColor = UIColorFromRGB(0x9d9e9f);
    self.firstDetailLabel.textAlignment = NSTextAlignmentLeft;
    self.firstDetailLabel.numberOfLines = 2;
    self.firstDetailLabel.text = @"只收录最优商品，省去筛选烦恼。\n随时在更新。";
    self.firstDetailLabel.deFrameLeft = self.firstLabel.deFrameLeft;
    self.firstDetailLabel.deFrameTop = self.firstLabel.deFrameBottom + 10;
    [self.scrollView addSubview:self.firstDetailLabel];
    
    
    self.secondImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"6P02-01"]];
    self.secondImageView.frame = CGRectMake(0., 0., self.secondImageView.image.size.width, self.secondImageView.image.size.height);
    self.secondImageView.frame = CGRectOffset(self.secondImageView.frame, timeForPage(2), 0);
    self.secondImageView.deFrameTop = 46.;
    [self.scrollView addSubview:self.secondImageView];
    
    self.secondDetailImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"6P02-02"]];
    self.secondDetailImageView.frame = CGRectMake(0., 0., self.secondDetailImageView.image.size.width, self.secondDetailImageView.image.size.height);
    self.secondDetailImageView.center = self.secondImageView.center;
    self.secondDetailImageView.deFrameBottom = self.secondImageView.deFrameBottom + 30.;
    [self.scrollView addSubview:self.secondDetailImageView];
    
    self.secondCaseImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"6P02-03"]];
    self.secondCaseImageView.frame = CGRectMake(0., 0., self.secondCaseImageView.image.size.width, self.secondCaseImageView.image.size.height);
    self.secondCaseImageView.center = self.secondImageView.center;
    self.secondCaseImageView.deFrameBottom = self.secondImageView.deFrameBottom + 50.;
    [self.scrollView addSubview:self.secondCaseImageView];
    
    self.secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(LabelMargin, 0., self.view.deFrameWidth - LabelMargin, 20.)];
    self.secondLabel.text = @"发现，购物正能量";
    self.secondLabel.textColor = UIColorFromRGB(0x414243);
    self.secondLabel.font = [UIFont systemFontOfSize:18.];
    self.secondLabel.textAlignment = NSTextAlignmentLeft;
    self.secondLabel.frame = CGRectOffset(self.secondLabel.frame, timeForPage(2), 0);
    self.secondLabel.deFrameTop = 480.;
    [self.scrollView addSubview:self.secondLabel];
    
    self.secondDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0., 0., self.view.deFrameWidth - LabelMargin, 40.)];
    self.secondDetailLabel.font = [UIFont systemFontOfSize:14.];
    self.secondDetailLabel.textColor = UIColorFromRGB(0x9d9e9f);
    self.secondDetailLabel.textAlignment = NSTextAlignmentLeft;
    self.secondDetailLabel.frame = CGRectOffset(self.secondDetailLabel.frame, timeForPage(2), 0);
    self.secondDetailLabel.numberOfLines = 2;
    self.secondDetailLabel.deFrameLeft = self.secondLabel.deFrameLeft;
    self.secondDetailLabel.deFrameTop = self.secondLabel.deFrameBottom + 10;
    self.secondDetailLabel.text = @"热门商品懒人包，寻找好物不再盲目。\n工作再忙，也要跟紧潮流。";
    [self.scrollView addSubview:self.secondDetailLabel];
    
    
    self.thirdImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"6P03-01"]];
    self.thirdImageView.frame = CGRectMake(0., 0., self.thirdImageView.image.size.width, self.thirdImageView.image.size.height);
    self.thirdImageView.frame = CGRectOffset(self.thirdImageView.frame, timeForPage(3), 0);
    self.thirdImageView.deFrameTop = 46.;
    [self.scrollView addSubview:self.thirdImageView];
    
    self.thirdDetailImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"6P03-02"]];
    self.thirdDetailImageView.frame = CGRectMake(0., 0., self.thirdDetailImageView.image.size.width, self.thirdDetailImageView.image.size.height);
    self.thirdDetailImageView.center = self.thirdImageView.center;
    //    self.thirdDetailImageView.deFrameTop = 185.;
    [self.scrollView addSubview:self.thirdDetailImageView];
    
    self.thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake(LabelMargin, 0., self.view.deFrameWidth - LabelMargin, 20.)];
    self.thirdLabel.font = [UIFont systemFontOfSize:18.];
    self.thirdLabel.textColor = UIColorFromRGB(0x414243);
    self.thirdLabel.textAlignment = NSTextAlignmentLeft;
    self.thirdLabel.text = @"喜爱，我的生活态度";
    self.thirdLabel.frame = CGRectOffset(self.thirdLabel.frame, timeForPage(3), 0);
    self.thirdLabel.deFrameTop = 480.;
    [self.scrollView addSubview:self.thirdLabel];
    
    self.thirdDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0., 0., self.view.deFrameWidth, 40.)];
    self.thirdDetailLabel.font = [UIFont systemFontOfSize:14.];
    self.thirdDetailLabel.textColor = UIColorFromRGB(0x9d9e9f);
    self.thirdDetailLabel.textAlignment = NSTextAlignmentLeft;
    self.thirdDetailLabel.frame = CGRectOffset(self.thirdDetailLabel.frame, timeForPage(3), 0);
    self.thirdDetailLabel.numberOfLines = 2;
    self.thirdDetailLabel.deFrameLeft = self.thirdLabel.deFrameLeft;
    self.thirdDetailLabel.deFrameTop = self.thirdLabel.deFrameBottom + 10;
    self.thirdDetailLabel.text = @"剁手大智慧，帮朋友到这儿。\n我的意思是，自己不要花太多钱";
    [self.scrollView addSubview:self.thirdDetailLabel];
    
    
    self.lastLabel = [[UILabel alloc] initWithFrame:CGRectMake(0., 0., self.view.deFrameWidth, 20.)];
    self.lastLabel.font = [UIFont systemFontOfSize:18.];
    self.lastLabel.textColor = UIColorFromRGB(0x414243);
    self.lastLabel.textAlignment = NSTextAlignmentCenter;
    self.lastLabel.text = @"精英消费指南";
    self.lastLabel.frame = CGRectOffset(self.lastLabel.frame, timeForPage(4), 0);
    self.lastLabel.deFrameTop = 95.;
    [self.scrollView addSubview:self.lastLabel];
    
    self.lastDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0., 0., self.view.deFrameWidth, 20.)];
    self.lastDetailLabel.font = [UIFont systemFontOfSize:14.];
    self.lastDetailLabel.textColor = UIColorFromRGB(0x9d9e9f);
    self.lastDetailLabel.textAlignment = NSTextAlignmentCenter;
    self.lastDetailLabel.frame = CGRectOffset(self.lastDetailLabel.frame, timeForPage(4), 0);
    self.lastDetailLabel.deFrameTop = self.lastLabel.deFrameBottom + 10.;
    self.lastDetailLabel.text = @"其实，生活不一样";
    [self.scrollView addSubview:self.lastDetailLabel];
    
    
    self.beginIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"beginIcon"]];
    self.beginIcon.frame = CGRectMake(0., 0., 90., 90.);
    
    self.beginIcon.center = self.lastDetailLabel.center;
    self.beginIcon.deFrameTop = 180.;
    [self.scrollView addSubview:self.beginIcon];
    
    self.beginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.beginBtn.titleLabel.font = [UIFont systemFontOfSize:18.];
    self.beginBtn.frame = CGRectMake(0., 0., 144., 43.);
    [self.beginBtn setTitle:@"马上开始" forState:UIControlStateNormal];
    [self.beginBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [self.beginBtn setBackgroundColor:UIColorFromRGB(0x427ec0)];
    self.beginBtn.layer.masksToBounds = YES;
    self.beginBtn.layer.cornerRadius = 6.;
    self.beginBtn.center = self.beginIcon.center;
    self.beginBtn.deFrameBottom = self.view.deFrameBottom - 100.;
    [self.beginBtn addTarget:self action:@selector(beginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.beginBtn];
}

#pragma mark - iphone 6
- (void)placeViewsI6
{
    self.firstImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"601-01"]];
    
    self.firstImageView.frame = CGRectMake(0., 46., self.firstImageView.image.size.width, self.firstImageView.image.size.height);
    [self.scrollView addSubview:self.firstImageView];
    
    self.firstDetailImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"601-02"]];
    self.firstDetailImageView.frame = CGRectMake(0., 0., self.firstDetailImageView.image.size.width, self.firstDetailImageView.image.size.height);
    self.firstDetailImageView.deFrameBottom = self.firstImageView.deFrameBottom;
    [self.scrollView addSubview:self.firstDetailImageView];
    
    self.firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(LabelMargin, 0., self.view.deFrameWidth - LabelMargin, 20.)];
    self.firstLabel.text = @"精选，真正的流行";
    self.firstLabel.textColor = UIColorFromRGB(0x414243);
    self.firstLabel.font = [UIFont systemFontOfSize:18.];
    self.firstLabel.textAlignment = NSTextAlignmentLeft;
    self.firstLabel.deFrameTop = 435;
    [self.scrollView addSubview:self.firstLabel];
    
    self.firstDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0., 0., self.view.deFrameWidth - LabelMargin, 40.)];
    self.firstDetailLabel.font = [UIFont systemFontOfSize:14.];
    self.firstDetailLabel.textColor = UIColorFromRGB(0x9d9e9f);
    self.firstDetailLabel.textAlignment = NSTextAlignmentLeft;
    self.firstDetailLabel.numberOfLines = 2;
    self.firstDetailLabel.text = @"只收录最优商品，省去筛选烦恼。\n随时在更新。";
    self.firstDetailLabel.deFrameLeft = self.firstLabel.deFrameLeft;
    self.firstDetailLabel.deFrameTop = self.firstLabel.deFrameBottom + 10;
    [self.scrollView addSubview:self.firstDetailLabel];
    
    
    self.secondImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"602-01"]];
    self.secondImageView.frame = CGRectMake(0., 0., self.secondImageView.image.size.width, self.secondImageView.image.size.height);
    self.secondImageView.frame = CGRectOffset(self.secondImageView.frame, timeForPage(2), 0);
    self.secondImageView.deFrameTop = 46.;
    [self.scrollView addSubview:self.secondImageView];
    
    self.secondDetailImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"602-02"]];
    self.secondDetailImageView.frame = CGRectMake(0., 0., self.secondDetailImageView.image.size.width, self.secondDetailImageView.image.size.height);
    self.secondDetailImageView.center = self.secondImageView.center;
    self.secondDetailImageView.deFrameBottom = self.secondImageView.deFrameBottom + 30.;
    [self.scrollView addSubview:self.secondDetailImageView];
    
    self.secondCaseImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"602-03"]];
    self.secondCaseImageView.frame = CGRectMake(0., 0., self.secondCaseImageView.image.size.width, self.secondCaseImageView.image.size.height);
    self.secondCaseImageView.center = self.secondImageView.center;
    self.secondCaseImageView.deFrameBottom = self.secondImageView.deFrameBottom + 50.;
    [self.scrollView addSubview:self.secondCaseImageView];
    
    self.secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(LabelMargin, 0., self.view.deFrameWidth - LabelMargin, 20.)];
    self.secondLabel.text = @"发现，购物正能量";
    self.secondLabel.textColor = UIColorFromRGB(0x414243);
    self.secondLabel.font = [UIFont systemFontOfSize:18.];
    self.secondLabel.textAlignment = NSTextAlignmentLeft;
    self.secondLabel.frame = CGRectOffset(self.secondLabel.frame, timeForPage(2), 0);
    self.secondLabel.deFrameTop = 435;
    [self.scrollView addSubview:self.secondLabel];
    
    self.secondDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0., 0., self.view.deFrameWidth - LabelMargin, 40.)];
    self.secondDetailLabel.font = [UIFont systemFontOfSize:14.];
    self.secondDetailLabel.textColor = UIColorFromRGB(0x9d9e9f);
    self.secondDetailLabel.textAlignment = NSTextAlignmentLeft;
    self.secondDetailLabel.frame = CGRectOffset(self.secondDetailLabel.frame, timeForPage(2), 0);
    self.secondDetailLabel.numberOfLines = 2;
    self.secondDetailLabel.deFrameLeft = self.secondLabel.deFrameLeft;
    self.secondDetailLabel.deFrameTop = self.secondLabel.deFrameBottom + 10;
    self.secondDetailLabel.text = @"热门商品懒人包，寻找好物不再盲目。\n工作再忙，也要跟紧潮流。";
    [self.scrollView addSubview:self.secondDetailLabel];
    
    
    self.thirdImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"603-01"]];
    self.thirdImageView.frame = CGRectMake(0., 0., self.thirdImageView.image.size.width, self.thirdImageView.image.size.height);
    self.thirdImageView.frame = CGRectOffset(self.thirdImageView.frame, timeForPage(3), 0);
    self.thirdImageView.deFrameTop = 46.;
    [self.scrollView addSubview:self.thirdImageView];
    
    self.thirdDetailImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"603-02"]];
    self.thirdDetailImageView.frame = CGRectMake(0., 0., self.thirdDetailImageView.image.size.width, self.thirdDetailImageView.image.size.height);
    self.thirdDetailImageView.center = self.thirdImageView.center;
    //    self.thirdDetailImageView.deFrameTop = 185.;
    [self.scrollView addSubview:self.thirdDetailImageView];
    
    self.thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake(LabelMargin, 0., self.view.deFrameWidth - LabelMargin, 20.)];
    self.thirdLabel.font = [UIFont systemFontOfSize:18.];
    self.thirdLabel.textColor = UIColorFromRGB(0x414243);
    self.thirdLabel.textAlignment = NSTextAlignmentLeft;
    self.thirdLabel.text = @"喜爱，我的生活态度";
    self.thirdLabel.frame = CGRectOffset(self.thirdLabel.frame, timeForPage(3), 0);
    self.thirdLabel.deFrameTop = 435;
    [self.scrollView addSubview:self.thirdLabel];
    
    self.thirdDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0., 0., self.view.deFrameWidth, 40.)];
    self.thirdDetailLabel.font = [UIFont systemFontOfSize:14.];
    self.thirdDetailLabel.textColor = UIColorFromRGB(0x9d9e9f);
    self.thirdDetailLabel.textAlignment = NSTextAlignmentLeft;
    self.thirdDetailLabel.frame = CGRectOffset(self.thirdDetailLabel.frame, timeForPage(3), 0);
    self.thirdDetailLabel.numberOfLines = 2;
    self.thirdDetailLabel.deFrameLeft = self.thirdLabel.deFrameLeft;
    self.thirdDetailLabel.deFrameTop = self.thirdLabel.deFrameBottom + 10;
    self.thirdDetailLabel.text = @"剁手大智慧，帮朋友到这儿。\n我的意思是，自己不要花太多钱";
    [self.scrollView addSubview:self.thirdDetailLabel];
    
    
    self.lastLabel = [[UILabel alloc] initWithFrame:CGRectMake(0., 0., self.view.deFrameWidth, 20.)];
    self.lastLabel.font = [UIFont systemFontOfSize:18.];
    self.lastLabel.textColor = UIColorFromRGB(0x414243);
    self.lastLabel.textAlignment = NSTextAlignmentCenter;
    self.lastLabel.text = @"精英消费指南";
    self.lastLabel.frame = CGRectOffset(self.lastLabel.frame, timeForPage(4), 0);
    self.lastLabel.deFrameTop = 95.;
    [self.scrollView addSubview:self.lastLabel];
    
    self.lastDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0., 0., self.view.deFrameWidth, 20.)];
    self.lastDetailLabel.font = [UIFont systemFontOfSize:14.];
    self.lastDetailLabel.textColor = UIColorFromRGB(0x9d9e9f);
    self.lastDetailLabel.textAlignment = NSTextAlignmentCenter;
    self.lastDetailLabel.frame = CGRectOffset(self.lastDetailLabel.frame, timeForPage(4), 0);
    self.lastDetailLabel.deFrameTop = self.lastLabel.deFrameBottom + 10.;
    self.lastDetailLabel.text = @"其实，生活不一样";
    [self.scrollView addSubview:self.lastDetailLabel];
    
    
    self.beginIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"beginIcon"]];
    self.beginIcon.frame = CGRectMake(0., 0., 90., 90.);
    
    self.beginIcon.center = self.lastDetailLabel.center;
    self.beginIcon.deFrameTop = 180.;
    [self.scrollView addSubview:self.beginIcon];
    
    self.beginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.beginBtn.titleLabel.font = [UIFont systemFontOfSize:18.];
    self.beginBtn.frame = CGRectMake(0., 0., 144., 43.);
    [self.beginBtn setTitle:@"马上开始" forState:UIControlStateNormal];
    [self.beginBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [self.beginBtn setBackgroundColor:UIColorFromRGB(0x427ec0)];
    self.beginBtn.layer.masksToBounds = YES;
    self.beginBtn.layer.cornerRadius = 6.;
    self.beginBtn.center = self.beginIcon.center;
    self.beginBtn.deFrameBottom = self.view.deFrameBottom - 100.;
    [self.beginBtn addTarget:self action:@selector(beginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.beginBtn];
}

#pragma mark - iphone 4s or 5
- (void)placeViews
{

    self.firstImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"501-01"]];
    
    self.firstImageView.frame = CGRectMake(0., 46., self.firstImageView.image.size.width, self.firstImageView.image.size.height);
    [self.scrollView addSubview:self.firstImageView];
    
    self.firstDetailImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"501-02"]];
    self.firstDetailImageView.frame = CGRectMake(0., 0., self.firstDetailImageView.image.size.width, self.firstDetailImageView.image.size.height);
    self.firstDetailImageView.deFrameBottom = self.firstImageView.deFrameBottom;
    [self.scrollView addSubview:self.firstDetailImageView];
    
    self.firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(LabelMargin, 0., self.view.deFrameWidth - LabelMargin, 20.)];
    self.firstLabel.text = @"精选，真正的流行";
    self.firstLabel.textColor = UIColorFromRGB(0x414243);
    self.firstLabel.font = [UIFont systemFontOfSize:18.];
    self.firstLabel.textAlignment = NSTextAlignmentLeft;
    self.firstLabel.deFrameTop = 380.;
    [self.scrollView addSubview:self.firstLabel];
    
    self.firstDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0., 0., self.view.deFrameWidth - LabelMargin, 40.)];
    self.firstDetailLabel.font = [UIFont systemFontOfSize:14.];
    self.firstDetailLabel.textColor = UIColorFromRGB(0x9d9e9f);
    self.firstDetailLabel.textAlignment = NSTextAlignmentLeft;
    self.firstDetailLabel.numberOfLines = 2;
    self.firstDetailLabel.text = @"只收录最优商品，省去筛选烦恼。\n随时在更新。";
    self.firstDetailLabel.deFrameLeft = self.firstLabel.deFrameLeft;
    self.firstDetailLabel.deFrameTop = self.firstLabel.deFrameBottom + 10;
    [self.scrollView addSubview:self.firstDetailLabel];
    
    
    self.secondImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"502-01"]];
    self.secondImageView.frame = CGRectMake(0., 0., self.secondImageView.image.size.width, self.secondImageView.image.size.height);
    self.secondImageView.frame = CGRectOffset(self.secondImageView.frame, timeForPage(2), 0);
    self.secondImageView.deFrameTop = 46.;
    [self.scrollView addSubview:self.secondImageView];
    
    self.secondDetailImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"502-02"]];
    self.secondDetailImageView.frame = CGRectMake(0., 0., self.secondDetailImageView.image.size.width, self.secondDetailImageView.image.size.height);
    self.secondDetailImageView.center = self.secondImageView.center;
    self.secondDetailImageView.deFrameBottom = self.secondImageView.deFrameBottom + 30.;
    [self.scrollView addSubview:self.secondDetailImageView];
    
    self.secondCaseImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"502-03"]];
    self.secondCaseImageView.frame = CGRectMake(0., 0., self.secondCaseImageView.image.size.width, self.secondCaseImageView.image.size.height);
    self.secondCaseImageView.center = self.secondImageView.center;
    self.secondCaseImageView.deFrameBottom = self.secondImageView.deFrameBottom + 50.;
    [self.scrollView addSubview:self.secondCaseImageView];
    
    self.secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(LabelMargin, 0., self.view.deFrameWidth - LabelMargin, 20.)];
    self.secondLabel.text = @"发现，购物正能量";
    self.secondLabel.textColor = UIColorFromRGB(0x414243);
    self.secondLabel.font = [UIFont systemFontOfSize:18.];
    self.secondLabel.textAlignment = NSTextAlignmentLeft;
    self.secondLabel.frame = CGRectOffset(self.secondLabel.frame, timeForPage(2), 0);
    self.secondLabel.deFrameTop = 380.;
    [self.scrollView addSubview:self.secondLabel];
    
    self.secondDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0., 0., self.view.deFrameWidth - LabelMargin, 40.)];
    self.secondDetailLabel.font = [UIFont systemFontOfSize:14.];
    self.secondDetailLabel.textColor = UIColorFromRGB(0x9d9e9f);
    self.secondDetailLabel.textAlignment = NSTextAlignmentLeft;
    self.secondDetailLabel.frame = CGRectOffset(self.secondDetailLabel.frame, timeForPage(2), 0);
    self.secondDetailLabel.numberOfLines = 2;
    self.secondDetailLabel.deFrameLeft = self.secondLabel.deFrameLeft;
    self.secondDetailLabel.deFrameTop = self.secondLabel.deFrameBottom + 10;
    self.secondDetailLabel.text = @"热门商品懒人包，寻找好物不再盲目。\n工作再忙，也要跟紧潮流。";
    [self.scrollView addSubview:self.secondDetailLabel];
    
    
    self.thirdImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"503-01"]];
    self.thirdImageView.frame = CGRectMake(0., 0., self.thirdImageView.image.size.width, self.thirdImageView.image.size.height);
    self.thirdImageView.frame = CGRectOffset(self.thirdImageView.frame, timeForPage(3), 0);
    self.thirdImageView.deFrameTop = 46.;
    [self.scrollView addSubview:self.thirdImageView];
    
    self.thirdDetailImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"503-02"]];
    self.thirdDetailImageView.frame = CGRectMake(0., 0., self.thirdDetailImageView.image.size.width, self.thirdDetailImageView.image.size.height);
    self.thirdDetailImageView.center = self.thirdImageView.center;
//    self.thirdDetailImageView.deFrameTop = 185.;
    [self.scrollView addSubview:self.thirdDetailImageView];
    
    self.thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake(LabelMargin, 0., self.view.deFrameWidth - LabelMargin, 20.)];
    self.thirdLabel.font = [UIFont systemFontOfSize:18.];
    self.thirdLabel.textColor = UIColorFromRGB(0x414243);
    self.thirdLabel.textAlignment = NSTextAlignmentLeft;
    self.thirdLabel.text = @"喜爱，我的生活态度";
    self.thirdLabel.frame = CGRectOffset(self.thirdLabel.frame, timeForPage(3), 0);
    self.thirdLabel.deFrameTop = 380.;
    [self.scrollView addSubview:self.thirdLabel];
    
    self.thirdDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0., 0., self.view.deFrameWidth, 40.)];
    self.thirdDetailLabel.font = [UIFont systemFontOfSize:14.];
    self.thirdDetailLabel.textColor = UIColorFromRGB(0x9d9e9f);
    self.thirdDetailLabel.textAlignment = NSTextAlignmentLeft;
    self.thirdDetailLabel.frame = CGRectOffset(self.thirdDetailLabel.frame, timeForPage(3), 0);
    self.thirdDetailLabel.numberOfLines = 2;
    self.thirdDetailLabel.deFrameLeft = self.thirdLabel.deFrameLeft;
    self.thirdDetailLabel.deFrameTop = self.thirdLabel.deFrameBottom + 10;
    self.thirdDetailLabel.text = @"剁手大智慧，帮朋友到这儿。\n我的意思是，自己不要花太多钱";
    [self.scrollView addSubview:self.thirdDetailLabel];
    
    
    self.lastLabel = [[UILabel alloc] initWithFrame:CGRectMake(0., 0., self.view.deFrameWidth, 20.)];
    self.lastLabel.font = [UIFont systemFontOfSize:18.];
    self.lastLabel.textColor = UIColorFromRGB(0x414243);
    self.lastLabel.textAlignment = NSTextAlignmentCenter;
    self.lastLabel.text = @"精英消费指南";
    self.lastLabel.frame = CGRectOffset(self.lastLabel.frame, timeForPage(4), 0);
    self.lastLabel.deFrameTop = 95.;
    [self.scrollView addSubview:self.lastLabel];
    
    self.lastDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0., 0., self.view.deFrameWidth, 20.)];
    self.lastDetailLabel.font = [UIFont systemFontOfSize:14.];
    self.lastDetailLabel.textColor = UIColorFromRGB(0x9d9e9f);
    self.lastDetailLabel.textAlignment = NSTextAlignmentCenter;
    self.lastDetailLabel.frame = CGRectOffset(self.lastDetailLabel.frame, timeForPage(4), 0);
    self.lastDetailLabel.deFrameTop = self.lastLabel.deFrameBottom + 10.;
    self.lastDetailLabel.text = @"其实，生活不一样";
    [self.scrollView addSubview:self.lastDetailLabel];
    
    
    self.beginIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"beginIcon"]];
    self.beginIcon.frame = CGRectMake(0., 0., 90., 90.);
    
    self.beginIcon.center = self.lastDetailLabel.center;
    self.beginIcon.deFrameTop = 180.;
    [self.scrollView addSubview:self.beginIcon];
    
    self.beginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.beginBtn.titleLabel.font = [UIFont systemFontOfSize:18.];
    self.beginBtn.frame = CGRectMake(0., 0., 144., 43.);
    [self.beginBtn setTitle:@"马上开始" forState:UIControlStateNormal];
    [self.beginBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [self.beginBtn setBackgroundColor:UIColorFromRGB(0x427ec0)];
    self.beginBtn.layer.masksToBounds = YES;
    self.beginBtn.layer.cornerRadius = 6.;
    self.beginBtn.center = self.beginIcon.center;
    self.beginBtn.deFrameBottom = self.view.deFrameBottom - 100.;
    [self.beginBtn addTarget:self action:@selector(beginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.beginBtn];

}

- (void)configureAnimation
{
    
    IFTTTScaleAnimation * firstAnimation = [IFTTTScaleAnimation animationWithView:self.firstDetailImageView];
    [self.animator addAnimation:firstAnimation];
    [firstAnimation addKeyFrames:@[
                                   [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andScale:1.],
                                   [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andScale:0.],
                                   ]];
    
    
    IFTTTScaleAnimation * secendScaleAnimation = [IFTTTScaleAnimation animationWithView:self.secondDetailImageView];
    [secendScaleAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1.2) andScale:0.2f]];
    [secendScaleAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2.2) andScale:1.2]];
    [self.animator addAnimation:secendScaleAnimation];
    
    IFTTTScaleAnimation * thirdScaleAnimation = [IFTTTScaleAnimation animationWithView:self.thirdDetailImageView];
    [thirdScaleAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2.5) andScale:0.5f]];
    [thirdScaleAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3.5) andScale:1.5f]];
    [self.animator addAnimation:thirdScaleAnimation];

    
    // Fade out the label by dragging on the last page
    IFTTTAlphaAnimation *labelAlphaAnimation = [IFTTTAlphaAnimation animationWithView:self.lastLabel];
    [labelAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andAlpha:1.0f]];
    [labelAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4.35f) andAlpha:0.0f]];
    [self.animator addAnimation:labelAlphaAnimation];
    
    IFTTTAlphaAnimation *labelDetailAlphaAnimation = [IFTTTAlphaAnimation animationWithView:self.lastDetailLabel];
    [labelDetailAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andAlpha:1.0f]];
    [labelDetailAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4.35f) andAlpha:0.0f]];
    [self.animator addAnimation:labelDetailAlphaAnimation];
    
    IFTTTAlphaAnimation * verlabelAlphaAnimation = [IFTTTAlphaAnimation animationWithView:self.verLabel];
    [verlabelAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andAlpha:1.0f]];
    [verlabelAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4.35f) andAlpha:0.0f]];
    [self.animator addAnimation:verlabelAlphaAnimation];

    IFTTTAlphaAnimation * beginBtnAlphaAnimation = [IFTTTAlphaAnimation animationWithView:self.beginBtn];
    [beginBtnAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andAlpha:1.0f]];
    [beginBtnAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4.35f) andAlpha:0.0f]];
    [self.animator addAnimation:beginBtnAlphaAnimation];
}


#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = (self.scrollView.contentOffset.x + self.view.deFrameWidth / 2) /self.view.deFrameWidth;
    self.pageControl.currentPage = page;
}

#pragma mark - <IFTTTAnimatedScrollViewControllerDelegate>
- (void)animatedScrollViewControllerDidScrollToEnd:(IFTTTAnimatedScrollViewController *)animatedScrollViewController
{
//    NSLog(@"Scrolled to end of scrollview!");
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [self beginBtnAction:nil];
}

- (void)animatedScrollViewControllerDidEndDraggingAtEnd:(IFTTTAnimatedScrollViewController *)animatedScrollViewController
{
    NSLog(@"Ended dragging at end of scrollview!");
    [self beginBtnAction:nil];
}

#pragma mark - button action:
- (void)beginBtnAction:(id)sender
{

    [self dismissViewControllerAnimated:YES completion:^{
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunchV4"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (self.finished) {
            self.finished();
        }
    }];
}

@end
