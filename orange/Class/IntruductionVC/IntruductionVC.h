//
//  IntruductionVC.h
//  Blueberry
//
//  Created by huiter on 13-12-14.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntruductionVC : UIViewController<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@end
