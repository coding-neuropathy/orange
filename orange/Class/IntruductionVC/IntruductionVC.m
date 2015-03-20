//
//  IntruductionVC.m
//  Blueberry
//
//  Created by huiter on 13-12-14.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import "IntruductionVC.h"

@interface IntruductionVC ()
{
    @private
    UIImageView *xyy;
    UIImageView *item;
    UIImageView *P23;
    UIImageView *loading;
    UIImageView *P21;
    UIImageView *imageview2;
}
@end

@implementation IntruductionVC


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initGuide];//初始化引导
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initGuide
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight)];
    [self.scrollView setContentSize:CGSizeMake(kScreenWidth * 4, kScreenHeight)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setBounces:YES];
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.minimumZoomScale = 0.5f;
    

    
    UIImageView *imageview1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1.png"]];
    [imageview1 setCenter:CGPointMake(kScreenWidth/2,kScreenHeight/2-30)];
    imageview1.contentMode = UIViewContentModeScaleAspectFit;
    imageview1.userInteractionEnabled = YES;
    [self.scrollView addSubview:imageview1];

    imageview2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.png"]];
    [imageview2 setCenter:CGPointMake(kScreenWidth*3/2,kScreenHeight/2-30)];
    imageview2.contentMode = UIViewContentModeScaleAspectFit;
    imageview2.userInteractionEnabled = YES;
    [self.scrollView addSubview:imageview2];

    [imageview2 addSubview:P21];
    
    

    UIImageView *imageview3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3.png"]];
    [imageview3 setCenter:CGPointMake(kScreenWidth*5/2,kScreenHeight/2-30)];
    imageview3.contentMode = UIViewContentModeScaleAspectFit;
    imageview3.userInteractionEnabled = YES;
    [self.scrollView addSubview:imageview3];

    UIImageView *imageview4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"4.png"]];
    [imageview4 setCenter:CGPointMake(kScreenWidth*7/2,kScreenHeight/2-30)];
    imageview4.contentMode = UIViewContentModeScaleAspectFit;
    imageview4.userInteractionEnabled = YES;
    
    [self.scrollView addSubview:imageview4];
    
    UIButton * button = [[UIButton alloc]init];
    [button setTitle:@"马上开始" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:18]];
    button.layer.cornerRadius = 8;
    button.layer.masksToBounds = YES;
    button.backgroundColor = UIColorFromRGB(0x457ebd);
    button.frame = CGRectMake(0, 0, 120, 40);
    button.center = CGPointMake(kScreenWidth*3+kScreenWidth/2, kScreenHeight - 120);
    [button addTarget:self action:@selector(beginInGuoku) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:button];
    
    [self.view addSubview:self.scrollView];

    
    // PageControl
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.f, 0.f, 100.f, 10.f)];
    self.pageControl.center = self.view.center;
    _pageControl.backgroundColor = [UIColor blackColor];
    [self.pageControl setDeFrameBottom:self.view.deFrameHeight - 50.f];
    self.pageControl.backgroundColor = [UIColor clearColor];
    self.pageControl.userInteractionEnabled = NO;
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = 4;
    self.pageControl.pageIndicatorTintColor = UIColorFromRGB(0x9d9e9f);
    self.pageControl.currentPageIndicatorTintColor = UIColorFromRGB(0x656768);
    [self.view addSubview:self.pageControl];
    [self.view bringSubviewToFront:self.pageControl];


}

- (void)beginInGuoku
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunchV4"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    int page = (_scrollView.contentOffset.x +kScreenWidth/2) /kScreenWidth;
    _pageControl.currentPage = page;
    
    if (_scrollView.contentOffset.x+_scrollView.frame.size.width >= _scrollView.contentSize.width+50)
    {
        [self beginInGuoku];
    }
    
}



- (void) changePage:(id)sender {
    NSInteger page = _pageControl.currentPage;
    [_scrollView setContentOffset:CGPointMake(kScreenWidth * page, 0)];
}
@end
