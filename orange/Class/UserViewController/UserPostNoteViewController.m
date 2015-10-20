//
//  UserPostNoteViewController.m
//  orange
//
//  Created by 谢家欣 on 15/10/20.
//  Copyright © 2015年 guoku.com. All rights reserved.
//

#import "UserPostNoteViewController.h"
#import "NoteCell.h"

@interface UserPostNoteViewController ()

@property (strong, nonatomic) GKUser * user;
@property (strong, nonatomic) UICollectionView * collectionView;

@property (strong, nonatomic) NSMutableArray * postNotes;
@property (nonatomic, assign) NSTimeInterval refreshTimestamp;

@end

@implementation UserPostNoteViewController

static NSString * NoteIdentifier = @"NoteCell";

- (instancetype)initWithUser:(GKUser *)user
{
    self = [super init];
    if (self) {
        self.user = user;
    }
    return self;
}

#pragma mark - init view
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0., 0., kScreenWidth, kScreenHeight) collectionViewLayout:layout];
        
        //        _collectionView.contentInset = UIEdgeInsetsMake(617, 0, 0, 0);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _collectionView;
}

#pragma mark - get data
- (void)refresh
{
    [API getUserNoteListWithUserId:self.user.userId timestamp:[[NSDate date] timeIntervalSince1970] count:30 success:^(NSArray *dataArray, NSTimeInterval timestamp) {
        self.postNotes = [NSMutableArray arrayWithArray:dataArray];
        self.refreshTimestamp = timestamp;
        [self.collectionView.pullToRefreshView stopAnimating];
        [self.collectionView reloadData];
    } failure:^(NSInteger stateCode) {
        
        [self.collectionView.pullToRefreshView stopAnimating];
    }];
}

- (void)loadMore
{
    [API getUserNoteListWithUserId:self.user.userId timestamp:self.refreshTimestamp count:30 success:^(NSArray *dataArray, NSTimeInterval timestamp) {
        [self.postNotes addObjectsFromArray:dataArray];
        self.refreshTimestamp = timestamp;
        [self.collectionView.infiniteScrollingView stopAnimating];
        [self.collectionView reloadData];
    } failure:^(NSInteger stateCode) {
        
        [self.collectionView.infiniteScrollingView stopAnimating];
    }];
}

- (void)loadView
{
    self.view = self.collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.collectionView registerClass:[NoteCell class] forCellWithReuseIdentifier:NoteIdentifier];
    
    if (self.user.userId == [Passport sharedInstance].user.userId) {
        self.navigationItem.title = @"我的点评";
    } else {
        self.navigationItem.title = [NSString stringWithFormat:@"%@ 的点评", self.user.nickname];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark - Fixed SVPullToRefresh in ios7 navigation bar translucent
- (void)didMoveToParentViewController:(UIViewController *)parent
{
    __weak __typeof(&*self)weakSelf = self;
    [self.collectionView addPullToRefreshWithActionHandler:^{
        [weakSelf refresh];
    }];
    
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    
    if (self.postNotes == 0) {
        [self.collectionView triggerPullToRefresh];
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

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.postNotes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NoteCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NoteIdentifier forIndexPath:indexPath];
    cell.note = [self.postNotes objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize = CGSizeMake(0, 0);
    itemSize = CGSizeMake(kScreenWidth, 100.);
    return itemSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edge = UIEdgeInsetsMake(0., 0., 0., 0.);
    edge = UIEdgeInsetsMake(16., 0., 0., 0.);
    return edge;
}


#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GKNote * note = [self.postNotes objectAtIndex:indexPath.row];
    GKEntity * entity = [GKEntity modelFromDictionary:@{@"entity_id": note.entityId}];
    [[OpenCenter sharedOpenCenter] openEntity:entity];
}

@end
