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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.collectionView registerClass:[NoteCell class] forCellWithReuseIdentifier:NoteIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GKNote * note = [self.postNotes objectAtIndex:indexPath.row];
    GKEntity * entity = [GKEntity modelFromDictionary:@{@"entity_id": note.entityId}];
    [[OpenCenter sharedOpenCenter] openEntity:entity];
}

@end
