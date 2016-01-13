//
//  SearchController.m
//  orange
//
//  Created by 谢家欣 on 15/6/26.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import "SearchController.h"
#import "HMSegmentedControl.h"
#import "EntitySearchViewController.h"
#import "ArticleSearchViewController.h"
#import "CategorySearchViewController.h"
#import "UserSearchViewController.h"


@interface SearchController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController * thePageViewController;
@property (strong, nonatomic) HMSegmentedControl *segmentedControl;
@property (assign, nonatomic) NSInteger index;

@property (nonatomic, strong) NSString *keyword;
@property (strong, nonatomic) EntitySearchViewController * entityVC;
@property (strong, nonatomic) ArticleSearchViewController * articleVC;
@property (strong, nonatomic) CategorySearchViewController * categoryVC;
@property (strong, nonatomic) UserSearchViewController * userVC;
@property (nonatomic, weak) UISearchBar * searchBar;

@end

@implementation SearchController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle: @"" image:[UIImage imageNamed:@"tabbar_icon_Search"] selectedImage:[[UIImage imageNamed:@"tabbar_icon_Search"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        item.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
        self.tabBarItem = item;
        self.index = 0;
    }
    return self;
}

#pragma mark - init view
- (HMSegmentedControl *)segmentedControl
{
    if (!_segmentedControl) {
        HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        [segmentedControl setSectionTitles:@[ @"商品",@"图文",@"品类",@"用户"]];
        [segmentedControl setSelectedSegmentIndex:0 animated:NO];
        [segmentedControl setSelectionStyle:HMSegmentedControlSelectionStyleTextWidthStripe];
        [segmentedControl setSelectionIndicatorLocation:HMSegmentedControlSelectionIndicatorLocationDown];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:UIColorFromRGB(0x9d9e9f) forKey:NSForegroundColorAttributeName];
        [segmentedControl setTitleTextAttributes:dict];
        NSDictionary *dict2 = [NSDictionary dictionaryWithObject:UIColorFromRGB(0xFF1F77) forKey:NSForegroundColorAttributeName];
        [segmentedControl setSelectedTitleTextAttributes:dict2];
        [segmentedControl setBackgroundColor:UIColorFromRGB(0xffffff)];
        [segmentedControl setSelectionIndicatorColor:UIColorFromRGB(0xFF1F77)];
        [segmentedControl setSelectionIndicatorHeight:1.5];
        [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        _segmentedControl = segmentedControl;

    }
    return _segmentedControl;
}

- (EntitySearchViewController *)entityVC
{
    if (!_entityVC) {
        _entityVC = [[EntitySearchViewController alloc] init];
    }
    return _entityVC;
}

- (ArticleSearchViewController *)articleVC
{
    if (!_articleVC) {
        _articleVC = [[ArticleSearchViewController alloc] init];
    }
    return _articleVC;
}

- (CategorySearchViewController *)categoryVC
{
    if (!_categoryVC) {
        _categoryVC = [[CategorySearchViewController alloc] init];
    }
    return _categoryVC;
}

- (UserSearchViewController *)userVC
{
    if (!_userVC) {
        _userVC = [[UserSearchViewController alloc] init];
    }
    return _userVC;
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.title = NSLocalizedStringFromTable(@"Search", kLocalizedFile, nil);
    
    [self.view addSubview:self.segmentedControl];
    

    [self addChildViewController:self.thePageViewController];
    
    self.thePageViewController.view.frame = CGRectMake(0,44, kScreenWidth,  kScreenHeight - 44);
    
    [self.thePageViewController setViewControllers:@[self.entityVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

    
    [self.view insertSubview:self.thePageViewController.view belowSubview:self.segmentedControl];
    
    [self setSelectedWithType:EntityType];
    

}

#pragma mark - <UIPageViewControllerDataSource>
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 4;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[EntitySearchViewController class]]) {
        return nil;
    }
    if ([viewController isKindOfClass:[ArticleSearchViewController class]]) {
        return self.entityVC;
    }
    if ([viewController isKindOfClass:[CategorySearchViewController class]]) {
        return self.articleVC;
    }
    if ([viewController isKindOfClass:[UserSearchViewController class]]) {
        return self.categoryVC;
    }

    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    
    if ([viewController isKindOfClass:[EntitySearchViewController class]]) {
        return self.articleVC;
    }
    if ([viewController isKindOfClass:[ArticleSearchViewController class]]) {
        return self.categoryVC;
    }
    if ([viewController isKindOfClass:[CategorySearchViewController class]]) {
        return self.userVC;
    }
    if ([viewController isKindOfClass:[UserSearchViewController class]]) {
        return nil;
    }
     return nil;
}

#pragma mark - <UIPageViewControllerDelegate>
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    self.index = 0;
    if (completed) {
        if ([[pageViewController.viewControllers objectAtIndex:0] isKindOfClass:[EntitySearchViewController class]]) {
            self.index = 0;
        }
        if ([[pageViewController.viewControllers objectAtIndex:0] isKindOfClass:[ArticleSearchViewController class]]) {
            self.index = 1;
        }
        if ([[pageViewController.viewControllers objectAtIndex:0] isKindOfClass:[CategorySearchViewController class]]) {
            self.index = 2;
        }
        if ([[pageViewController.viewControllers objectAtIndex:0] isKindOfClass:[UserSearchViewController class]]) {
            self.index = 3;
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
    return UIPageViewControllerSpineLocationMin;
}

#pragma mark -
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl
{
    static NSInteger i =0;
    self.index = segmentedControl.selectedSegmentIndex;
    if (segmentedControl.selectedSegmentIndex == 0){
        [self.thePageViewController setViewControllers:@[self.entityVC] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    }
    
   else if (segmentedControl.selectedSegmentIndex == 1 && segmentedControl.selectedSegmentIndex>i){
        [self.thePageViewController setViewControllers:@[self.articleVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
      
    }
    else if (segmentedControl.selectedSegmentIndex == 1 && segmentedControl.selectedSegmentIndex<i)
    {
        [self.thePageViewController setViewControllers:@[self.articleVC] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
       
    }
    
   else if (segmentedControl.selectedSegmentIndex == 2 &&segmentedControl.selectedSegmentIndex>i){
        [self.thePageViewController setViewControllers:@[self.categoryVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
      
    }
   else if (segmentedControl.selectedSegmentIndex == 2 && segmentedControl.selectedSegmentIndex<i)
    {
        [self.thePageViewController setViewControllers:@[self.categoryVC] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
        
    }
    
   else if (segmentedControl.selectedSegmentIndex == 3){
        [self.thePageViewController setViewControllers:@[self.userVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
    [self handleSearchText:self.keyword];
    
    i = segmentedControl.selectedSegmentIndex;
    
}


#pragma mark - set Search type
- (void)setSelectedWithType:(SearchType)type
{
    switch (type) {
        case EntityType:
            [self.segmentedControl setSelectedSegmentIndex:0 animated:YES];
            break;
        case ArticleType:
            [self.segmentedControl setSelectedSegmentIndex:1 animated:YES];
            break;
        case CategoryType:
            [self.segmentedControl setSelectedSegmentIndex:2 animated:YES];
            break;
        case UserType:
            [self.segmentedControl setSelectedSegmentIndex:3 animated:YES];
            break;
            break;
    }
}

-(void)searchText:(NSString *)string
{
    [self handleSearchText:string];
}


- (void)handleSearchText:(NSString *)searchText
{
    if (searchText.length == 0) {
        return;
    }
    
    switch (self.segmentedControl.selectedSegmentIndex) {
        case EntityType:
        {
            [self.entityVC handleSearchText:searchText];
        }
            break;
            
        case ArticleType:
        {
            [self.articleVC handleSearchText:searchText];
        }
            break;
        case CategoryType:
        {
            [self.categoryVC handleSearchText:searchText];
        }
            break;
            
        case UserType:
        {
            [self.userVC handleSearchText:searchText];
        }
            break;
    }
}


#pragma mark - <UISearchResultsUpdating>
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{

    if ([self.keyword isEqualToString:[searchController.searchBar.text trimedWithLowercase]]) {
        return;
    }
    self.searchBar = searchController.searchBar;
    self.entityVC.searchBar = self.searchBar;
    self.articleVC.searchBar = self.searchBar;
    self.categoryVC.searchBar = self.searchBar;
    self.userVC.searchBar = self.searchBar;

    self.keyword = [searchController.searchBar.text trimedWithLowercase];
    if (self.keyword.length == 0) {
        [UIView animateWithDuration:0 animations:^{
            [self.discoverVC.searchVC.view viewWithTag:999].alpha = 1;
        }];
        return;
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        [self.discoverVC.searchVC.view viewWithTag:999].alpha = 0;
    }completion:^(BOOL finished) {
        [self handleSearchText:self.keyword];
    }];
}


@end
