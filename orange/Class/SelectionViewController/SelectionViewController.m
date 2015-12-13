//
//  SelectionViewController.m
//  orange
//
//  Created by huiter on 15/1/5.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "SelectionViewController.h"
#import "HMSegmentedControl.h"
#import "API.h"
#import "SelectionCell.h"
#import "EntitySingleListCell.h"
//#import "CategoryViewController.h"
#import "SDWebImagePrefetcher.h"
#import "GTScrollNavigationBar.h"
//#import "SelectionCategoryView.h"
#import "IconInfoView.h"

@import CoreSpotlight;

static NSString *CellIdentifier = @"SelectionCell";

@interface SelectionViewController ()<UITableViewDataSource, UITableViewDelegate>
//@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray * dataArrayForEntity;
//@property(nonatomic, strong) NSMutableArray * dataArrayForArticle;
@property(nonatomic, assign) NSInteger index;

@property (nonatomic, strong) UILabel * SelectionCountLabel;
@property (nonatomic, strong) UIView * SelectionCountLabelBgView;
@property (nonatomic, strong) IconInfoView * iconInfoView;
//@property (nonatomic, strong) PopoverView * selection_pv;
@property (nonatomic, assign) NSInteger cateId;
@end

@implementation SelectionViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(save) name:@"Save" object:nil];
        // Custom initialization
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:NSLocalizedStringFromTable(@"selected", kLocalizedFile, nil) image:[UIImage imageNamed:@"tabbar_icon_selection"] selectedImage:[[UIImage imageNamed:@"tabbar_icon_selection"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        item.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
        
        self.tabBarItem = item;
        
        //self.title = NSLocalizedStringFromTable(@"selected", kLocalizedFile, nil);
        self.cateId = 0;
        
        self.tableView.frame = CGRectMake(0, 0,kScreenWidth , kScreenHeight-kStatusBarHeight-kNavigationBarHeight - kTabBarHeight);
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xf8f8f8);
    [self.tableView registerClass:[SelectionCell class] forCellReuseIdentifier:CellIdentifier];
    [self.view addSubview:self.tableView];
    
    self.navigationItem.titleView = self.iconInfoView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.scrollsToTop = YES;
    //self.navigationController.scrollNavigationBar.scrollView = self.tableView;
    [AVAnalytics beginLogPageView:@"SelectionView"];
    [MobClick beginLogPageView:@"SelectionView"];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tableView.scrollsToTop = NO;
    [AVAnalytics endLogPageView:@"SelectionView"];
    [MobClick endLogPageView:@"SelectionView"];
}

#pragma  mark - Fixed SVPullToRefresh in ios7 navigation bar translucent
- (void)didMoveToParentViewController:(UIViewController *)parent
{
    __weak __typeof(&*self)weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf refresh];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    //
    if (self.dataArrayForEntity.count == 0)
    {
        [self.tableView triggerPullToRefresh];
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Data
- (void)refresh
{
    if (self.index == 0) {
        [API getSelectionListWithTimestamp:[[NSDate date] timeIntervalSince1970] cateId:self.cateId count:30 success:^(NSArray *dataArray) {
            self.dataArrayForEntity = [NSMutableArray arrayWithArray:dataArray];
            [self save];
            NSMutableArray* imageArray = [NSMutableArray array];
            for (NSDictionary * dic in dataArray) {
               GKEntity * entity = [[dic objectForKey:@"content"] objectForKey:@"entity"];
                
                [imageArray addObject:entity.imageURL_640x640];
            }
            [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:imageArray];
            
            [self.tableView reloadData];
            [self.tableView.pullToRefreshView stopAnimating];
            
            [self saveEntityToIndexWithData:dataArray];
        } failure:^(NSInteger stateCode) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"GKNetworkReachabilityStatusNotReachable" object:nil];
            //[SVProgressHUD showImage:nil status:NSLocalizedStringFromTable(@"load failure", kLocalizedFile, nil)];
//            [SVProgressHUD dismiss];
            [self.tableView.pullToRefreshView stopAnimating];
        }];
    }
    else if (self.index == 1)
    {
        //[SVProgressHUD showImage:nil status:NSLocalizedStringFromTable(@"load failure", kLocalizedFile, nil)];
            [SVProgressHUD dismiss];
        [self.tableView.pullToRefreshView stopAnimating];
    }
    return;
}

- (void)loadMore
{
    if (self.index == 0) {
        NSTimeInterval timestamp = (NSTimeInterval)[self.dataArrayForEntity.lastObject[@"time"] doubleValue];
        [API getSelectionListWithTimestamp:timestamp cateId:self.cateId count:30 success:^(NSArray *dataArray) {
            [self.dataArrayForEntity addObjectsFromArray:[NSMutableArray arrayWithArray:dataArray]];
            NSMutableArray* imageArray = [NSMutableArray array];
            for (NSDictionary * dic in dataArray) {
                GKEntity * entity = [[dic objectForKey:@"content"]objectForKey:@"entity"];
                [imageArray addObject:entity.imageURL_640x640];
            }
            [[SDWebImagePrefetcher sharedImagePrefetcher]prefetchURLs:imageArray];
            [self save];
            [self.tableView reloadData];
            [self.tableView.infiniteScrollingView stopAnimating];
            
            [self saveEntityToIndexWithData:dataArray];
        } failure:^(NSInteger stateCode) {
            //[SVProgressHUD showImage:nil status:NSLocalizedStringFromTable(@"load failure", kLocalizedFile, nil)];
            [SVProgressHUD dismiss];
            [self.tableView.infiniteScrollingView stopAnimating];
        }];
    }
    else if (self.index == 1)
    {
        //[SVProgressHUD showImage:nil status:NSLocalizedStringFromTable(@"load failure", kLocalizedFile, nil)];
            [SVProgressHUD dismiss];
        [self.tableView.infiniteScrollingView stopAnimating];
    }
    return;
}

#pragma mark - save to index

- (void)saveEntityToIndexWithData:(NSArray *)data
{
    if (![CSSearchableIndex isIndexingAvailable]) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray<CSSearchableItem *> *searchableItems = [NSMutableArray array];
        
        for (NSDictionary * row in data) {
            CSSearchableItemAttributeSet *attributedSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:@"entity"];
            GKEntity * entity = [[row objectForKey:@"content"] objectForKey:@"entity"];
            GKNote * note = [[row objectForKey:@"content"] objectForKey:@"note"];
            
            attributedSet.title = entity.entityName;
            attributedSet.contentDescription = note.text;
            attributedSet.identifier = @"entity";
        
            /**
             *  set image data
             */
            NSData * imagedata = [ImageCache readImageWithURL:entity.imageURL_240x240];
            if (imagedata) {
                attributedSet.thumbnailData = imagedata;
            } else {
                attributedSet.thumbnailData = [NSData dataWithContentsOfURL:entity.imageURL_240x240];
                [ImageCache saveImageWhthData:attributedSet.thumbnailData URL:entity.imageURL_240x240];
            }
            
            
            CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:[NSString stringWithFormat:@"entity:%@", entity.entityId] domainIdentifier:@"com.guoku.iphone.search.entity" attributeSet:attributedSet];
            
            [searchableItems addObject:item];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.entityImageView setImage:placeholder];
            [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:searchableItems completionHandler:^(NSError * _Nullable error) {
                if (error != nil) {
                    NSLog(@"index Error %@",error.localizedDescription);
                }
            }];
        });
    });
}

//- (BOOL)saveImageWhthData:(NSData *)data URL:(NSURL *)url
//{
//    //    NSError * err = nil;
//    NSString * imagefile = [url.absoluteString md5];
//    
//    NSURL * containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.guoku.iphone"];
//    //    NSLog(@"url %@", containerURL);
//    containerURL = [containerURL URLByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/%@", imagefile]];
//    BOOL result = [data writeToURL:containerURL atomically:YES];
//    return result;
//}
//
//- (NSData *)readImageWithURL:(NSURL *)url
//{
//    NSString * imagefile = [url.absoluteString md5];
//    NSURL * containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.guoku.iphone"];
//    containerURL = [containerURL URLByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/%@", imagefile]];
//    
//    return [NSData dataWithContentsOfURL:containerURL];
//    //    return data;
//}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.index == 0) {
        return ceil(self.dataArrayForEntity.count / (CGFloat)1);
    }
//    else if (self.index == 1)
//    {
//         return ceil(self.dataArrayForArticle.count / (CGFloat)1);
//    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.index == 0) {
        
        if (1) {
//            static NSString *CellIdentifier = @"SelectionCell";
//            SelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//            if (!cell) {
//                cell = [[SelectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//            }
            SelectionCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//            cell.note = [[self.dataArrayForEntity[indexPath.row] objectForKey:@"content"]objectForKey:@"note"];
//            cell.entity = [[self.dataArrayForEntity[indexPath.row] objectForKey:@"content"]objectForKey:@"entity"];
//            NSTimeInterval timestamp = [self.dataArrayForEntity[indexPath.row][@"time"] doubleValue];
//            cell.date = [NSDate dateWithTimeIntervalSince1970:timestamp];
            cell.dict = [self.dataArrayForEntity objectAtIndex:indexPath.row];
            return cell;
        }
        else
        {
            return [[UITableViewCell alloc] init];
        }

    }
//    else if (self.index == 1)
//    {
//        return [[UITableViewCell alloc] init];
//    }
    return [[UITableViewCell alloc] init];

}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.index == 0) {
        if (1) {
            GKNote * note = [[self.dataArrayForEntity[indexPath.row] objectForKey:@"content"]objectForKey:@"note"];
            return [SelectionCell height:note];
        }
        else
        {
            return [EntitySingleListCell height];
        }

    }
    else if (self.index == 1)
    {
        return 100;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.index == 0) {
        return 0.f;
    }
    else
    {
        return 0.f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.index == 0) {
        
        _SelectionCountLabel= [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(self.tableView.frame), 36.f)];
        self.SelectionCountLabel.text = [NSString stringWithFormat:@"%d 条未读精选",10];
        self.SelectionCountLabel.textAlignment = NSTextAlignmentCenter;
        self.SelectionCountLabel.textColor = UIColorFromRGB(0xFF1F77);
        self.SelectionCountLabel.backgroundColor = [UIColor clearColor];
        self.SelectionCountLabel.font = [UIFont systemFontOfSize:14];
        
        _SelectionCountLabelBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 36)];
        self.SelectionCountLabelBgView.backgroundColor = UIColorFromRGB(0xebebeb);
        [self.SelectionCountLabelBgView addSubview:self.SelectionCountLabel];
        self.SelectionCountLabelBgView.alpha = 0.97;
        
        //return self.SelectionCountLabelBgView;
    }
    return [UIView new];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [[NSUserDefaults standardUserDefaults] setObject:@(scrollView.contentOffset.y) forKey:@"selection-offset-y"];

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
        if (scrollView.contentOffset.y>20000) {
            [self tipForTapStatusBar];
        }
}

//- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
//{
//    [self.navigationController.scrollNavigationBar resetToDefaultPositionWithAnimation:YES];
//    [self dismissTip];
//}


#pragma mark - HMSegmentedControl
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSUInteger index = segmentedControl.selectedSegmentIndex;
    self.index = index;
    [self.tableView reloadData];
    switch (index) {
        case 0:
        {

        }
            break;
        case 1:
        {

        }
            break;
            
        default:
            break;
    }
}


- (void)load
{
    NSMutableArray * selectionArray;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"selection"];
    if (data) {
        selectionArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    if (!self.dataArrayForEntity) {
        self.dataArrayForEntity = [NSMutableArray array];
    }
    for (NSDictionary * dic in selectionArray) {
        GKNote * note = [GKNote modelFromDictionary:[[dic objectForKey:@"content"]objectForKey:@"note"]];
        GKEntity * entity = [GKEntity modelFromDictionary:[[dic objectForKey:@"content"]objectForKey:@"entity"]];
        NSDictionary * content = [NSMutableDictionary dictionaryWithObjectsAndKeys:entity,@"entity",note,@"note", nil];
        NSString * time = [dic objectForKey:@"time"];
        [self.dataArrayForEntity addObject:[NSDictionary dictionaryWithObjectsAndKeys:time,@"time",content,@"content",nil]];
    }
    [self.tableView reloadData];
    //[self.tableView setContentOffset:CGPointMake(0,[[[NSUserDefaults standardUserDefaults] objectForKey:@"selection-offset-y"] floatValue]  )];
    
    if (self.tableView.indexPathsForVisibleRows.firstObject) {
        [self.tableView selectRowAtIndexPath:self.tableView.indexPathsForVisibleRows.firstObject animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
}

-(void)save
{
    NSMutableArray *data = [NSMutableArray array];
    for (NSDictionary * dic in self.dataArrayForEntity) {
        GKNote * note = [[dic objectForKey:@"content"]objectForKey:@"note"];
        GKEntity * entity = [[dic objectForKey:@"content"]objectForKey:@"entity"];
        NSString * time = [dic objectForKey:@"time"];
        NSDictionary * content = [NSMutableDictionary dictionaryWithObjectsAndKeys:[GKEntity dictionaryFromModel:entity],@"entity",[GKNote dictionaryFromModel:note],@"note", nil];
        [data addObject:[NSDictionary dictionaryWithObjectsAndKeys:time,@"time",content,@"content",nil]];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:@"selection"];
    [[NSUserDefaults standardUserDefaults] setObject:@(self.tableView.contentOffset.y) forKey:@"selection-offset-y"];
}

- (void)tapStatusBar:(id)sender
{
    [self.navigationController.scrollNavigationBar resetToDefaultPositionWithAnimation:YES];
}

- (void)tipForTapStatusBar
{
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"everShowTipStatusBar"])
    {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everShowTipStatusBar"];
    
    if ([kAppDelegate.window viewWithTag:30001] ) {
        return;
    }
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenWidth, kScreenHeight)];
    button.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    button.tag = 30001;
    [button addTarget:self action:@selector(dismissTip) forControlEvents:UIControlEventTouchUpInside];
    [kAppDelegate.window addSubview:button];
    
    
    UILabel * tip = [[UILabel alloc]initWithFrame:CGRectMake(0, 19, kScreenWidth, 34)];
    tip.backgroundColor = UIColorFromRGB(0x343434);
    tip.textColor = UIColorFromRGB(0xffffff);
    tip.textAlignment = NSTextAlignmentCenter;
    tip.text = @"点击状态栏，瞬间回到顶部";
    tip.font = [UIFont systemFontOfSize:14];
    tip.layer.masksToBounds = YES;
    tip.layer.cornerRadius = 17;
    [tip sizeToFit];
    tip.frame = CGRectMake(0, 0, tip.deFrameWidth + 48, 34);
    tip.center = CGPointMake(kScreenWidth/2, 0);
    tip.deFrameTop = 19;
    [button addSubview:tip];
    
    UIImageView * icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tip_ triangle"]];
    icon.center =CGPointMake(kScreenWidth/2, 0);
    icon.deFrameTop = 11.5;
    [button addSubview:icon];
}

- (void)dismissTip
{
    UIView * view =[kAppDelegate.window viewWithTag:30001];
    if (view) {
        [UIView animateWithDuration:0.3 animations:^{
            view.alpha = 0;
        } completion:^(BOOL finished) {
            [[kAppDelegate.window viewWithTag:30001] removeFromSuperview];
        }];
    }

}

@end
