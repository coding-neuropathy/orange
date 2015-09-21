//
//  NewVersionController.m
//  orange
//
//  Created by 谢家欣 on 15/9/21.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "NewVersionController.h"

#define NUMBER_OF_PAGES 1

@interface NewVersionController ()

@property (strong, nonatomic) UILabel * titleLabel;
@property (strong, nonatomic) UILabel * detailLabel;
@property (strong, nonatomic) UIImageView * imageView;
@property (strong, nonatomic) UIButton * startBtn;

@end

@implementation NewVersionController

- (void)loadView
{
    [super loadView];
//    self.view.frame = CGRectMake(0., 0., 290., 425.);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.32];

    self.scrollView.frame = CGRectMake(0, 0, 290., 425.);
    self.scrollView.center = self.view.center;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    self.scrollView.contentSize = CGSizeMake(NUMBER_OF_PAGES * CGRectGetWidth(self.scrollView.frame),
                                             CGRectGetHeight(self.scrollView.frame));
    
//    self.scrollView.pagingEnabled = YES;
    self.scrollView.layer.masksToBounds = YES;
    self.scrollView.layer.cornerRadius = 4.;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.accessibilityLabel = @"JazzHands";
    self.scrollView.accessibilityIdentifier = @"JazzHands";
    
    [self placeViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)placeViews
{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0., 0., 290., 24.)];
    self.titleLabel.font = [UIFont systemFontOfSize:20.];
    self.titleLabel.textColor = UIColorFromRGB(0x414243);
    self.titleLabel.text = @"果库图文上线";
//    self.titleLabel.center = self.scrollView.center;
    self.titleLabel.deFrameTop = 50.;
//    self.titleLabel.backgroundColor = [UIColor redColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:self.titleLabel];
    
    self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0., 0., 290., 50.)];
    self.detailLabel.font = [UIFont systemFontOfSize:14.];
    self.detailLabel.numberOfLines = 2;
    self.detailLabel.textColor = UIColorFromRGB(0x9d9e9f);
    self.detailLabel.textAlignment = NSTextAlignmentCenter;
    self.detailLabel.text = @"对消费选择的苛求，衣食住行的洞见。\n生活可以将就，也可以讲究。";
    self.detailLabel.deFrameTop = self.titleLabel.deFrameBottom + 10.;
    [self.scrollView addSubview:self.detailLabel];
    
    /**
     *  GUID IMAGE
     */
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0., 0., 225., 260.)];
    self.imageView.image = [UIImage imageNamed:@"newVer"];
    self.imageView.center = self.titleLabel.center;
    self.imageView.deFrameTop = self.detailLabel.deFrameBottom + 5;
    [self.scrollView addSubview:self.imageView];
    
    /**
     *  开始按钮
     */
    self.startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.startBtn.frame = CGRectMake(0., 0., 290., 50.);
    [self.startBtn setBackgroundColor:UIColorFromRGB(0x6eaaf0)];
    [self.startBtn setTitle:[NSString stringWithFormat:@"即可体验 %@", [NSString fontAwesomeIconStringForEnum:FAArrowCircleORight]] forState:UIControlStateNormal];
    self.startBtn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14.];
    self.startBtn.deFrameBottom = CGRectGetHeight(self.scrollView.frame);
    [self.startBtn addTarget:self action:@selector(startBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.startBtn];
}

- (void)fadeOut
{
    [UIView animateWithDuration:0.35 animations:^{
        self.scrollView.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.scrollView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished)
        {
//            [self removeFromSuperview];
//            [self.view removeFromSuperview];
            if (self.finished) {
                [self.view removeFromSuperview];
                self.finished();
            }
        }
    }];
}

#pragma mark - Button Action
- (void)startBtnAction:(id)sender
{
    [self fadeOut];
}

@end
