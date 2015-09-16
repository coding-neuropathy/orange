//
//  CategoryGroupViewController.m
//  orange
//
//  Created by 谢家欣 on 15/9/15.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "CategoryGroupViewController.h"
#import "HMSegmentedControl.h"
#import "CategoryEntityController.h"
#import "SubCategoryEntityViewController.h"


@interface CategoryGroupViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController * thePageViewController;
@property (strong, nonatomic) HMSegmentedControl *segmentedControl;
@property (strong, nonatomic) CategoryEntityController * categoryEntityVC;

@property (nonatomic, strong) NSArray *categoryGroupArray;
@property (nonatomic, strong) NSMutableArray *categoryArray;
@property (nonatomic, strong) NSMutableArray *firstCategoryArray;
@property (nonatomic, strong) NSMutableArray *subCategoryArray;

@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) NSInteger gid;

@end

@implementation CategoryGroupViewController


- (id)initWithGid:(NSUInteger)gid
{
    self = [super init];
    if (self) {
        _gid = gid;
        
        self.categoryGroupArray = [NSObject objectFromUserDefaultsByKey:CategoryGroupArrayKey];
        for (NSDictionary * dic in self.categoryGroupArray) {
            NSUInteger gid = [dic[@"GroupId"] integerValue];
            if (gid == self.gid) {
                self.categoryArray = [NSMutableArray arrayWithArray:dic[@"CategoryArray"]];
                [self.categoryArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"status" ascending:NO]]];
                [self splitArray];
                break;
            }
        }
    }
    return self;
}

- (void)splitArray
{
    self.firstCategoryArray = [NSMutableArray array];
    self.subCategoryArray = [NSMutableArray array];
    [self.firstCategoryArray addObject:@"所有"];
    for (GKEntityCategory *category in self.categoryArray) {
        if (category.status > 0) {
            [self.firstCategoryArray addObject:category.categoryName];
            [self.subCategoryArray addObject:category];
        }
    }
    [self.firstCategoryArray addObject:@"更多"];
}

- (HMSegmentedControl *)segmentedControl
{
    if (!_segmentedControl) {
        _segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(20., 0, kScreenWidth-40, 32)];
        
//        [_segmentedControl setSectionTitles:@[NSLocalizedStringFromTable(@"activity", kLocalizedFile, nil), NSLocalizedStringFromTable(@"message", kLocalizedFile, nil)]];
        [_segmentedControl setSelectedSegmentIndex:0 animated:NO];
        [_segmentedControl setSelectionStyle:HMSegmentedControlSelectionStyleTextWidthStripe];
        //        [_segmentedControl setSelectionStyle:HMSegmentedControlSelectionStyleFullWidthStripe];
        [_segmentedControl setSelectionIndicatorLocation:HMSegmentedControlSelectionIndicatorLocationDown];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:UIColorFromRGB(0x9d9e9f) forKey:NSForegroundColorAttributeName];
        [_segmentedControl setTitleTextAttributes:dict];
        NSDictionary *dict2 = [NSDictionary dictionaryWithObject:UIColorFromRGB(0xFF1F77) forKey:NSForegroundColorAttributeName];
        [_segmentedControl setSelectedTitleTextAttributes:dict2];
//        [_segmentedControl setBackgroundColor:[UIColor clearColor]];
        [_segmentedControl setSelectionIndicatorColor:UIColorFromRGB(0xFF1F77)];
        [_segmentedControl setSelectionIndicatorHeight:2];
        [_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        [_segmentedControl setTag:2];
        
    }
    return _segmentedControl;
}

- (CategoryEntityController *)categoryEntityVC
{
    if (!_categoryEntityVC) {
        _categoryEntityVC = [[CategoryEntityController alloc] initWithGID:self.gid];
    }
    return _categoryEntityVC;
}


- (UIPageViewController *)thePageViewController
{
    if (!_thePageViewController) {
        _thePageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _thePageViewController.dataSource = self;
        _thePageViewController.delegate = self;
    }
    return _thePageViewController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    
    [self addChildViewController:self.thePageViewController];
    
    [self.thePageViewController setViewControllers:@[self.categoryEntityVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.thePageViewController.view.frame = CGRectMake(0, 32., kScreenWidth, kScreenHeight -32.);

    [self.view addSubview:self.segmentedControl];
    
    [self.segmentedControl setSectionTitles:self.firstCategoryArray];
//    [self.view addSubview:self.parentViewController.view];
    [self.view insertSubview:self.thePageViewController.view belowSubview:self.segmentedControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - <UIPageViewControllerDataSource>
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.firstCategoryArray.count - 1;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    
//    NSLog(@"%@", pageViewController);
    if ([viewController isKindOfClass:[SubCategoryEntityViewController class]]) {
        return self.categoryEntityVC;
    }

    
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    
    if ([viewController isKindOfClass:[CategoryEntityController class]]) {
        GKEntityCategory * subCategory = [self.subCategoryArray objectAtIndex:0];
        SubCategoryEntityViewController * subCategoryVC = [[SubCategoryEntityViewController alloc] initWithSID:subCategory.categoryId];
        return subCategoryVC;
    }
    return nil;
}

#pragma mark - <UIPageViewControllerDelegate>
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    //    DDLogError(@"index %ld", self.index);
    self.index = 0;
    if (completed) {

        if ([[pageViewController.viewControllers objectAtIndex:0] isKindOfClass:[CategoryEntityController class]]) {
            self.index = 0;
        }
        if ([[pageViewController.viewControllers objectAtIndex:0] isKindOfClass:[SubCategoryEntityViewController class]]) {
            self.index = 1;
        }
        
        [self.segmentedControl setSelectedSegmentIndex:self.index animated:YES];
    }
}

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController
                   spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    
    UIViewController *currentViewController = [self.thePageViewController.viewControllers objectAtIndex:0];
    
    NSArray * view_controllers = [NSArray arrayWithObjects:currentViewController, nil];
    [self.thePageViewController setViewControllers:view_controllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    
    self.thePageViewController.doubleSided = NO;
    //    [self.segmentedControl setSelectedSegmentIndex:self.index animated:YES];
    return UIPageViewControllerSpineLocationMin;
}

#pragma mark - 
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl
{

    switch (segmentedControl.selectedSegmentIndex) {
        case 1:
        {
            GKEntityCategory * subCategory = [self.subCategoryArray objectAtIndex:segmentedControl.selectedSegmentIndex - 1];
            SubCategoryEntityViewController * subCategoryVC = [[SubCategoryEntityViewController alloc] initWithSID:subCategory.categoryId];
            [self.thePageViewController setViewControllers:@[subCategoryVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        }
            
            break;
        default:
        {
            [self.thePageViewController setViewControllers:@[self.categoryEntityVC] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
        }
            break;
    }
    
    self.index = segmentedControl.selectedSegmentIndex;
}

@end
