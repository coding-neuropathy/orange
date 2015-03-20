//
//  UserViewController.m
//  orange
//
//  Created by huiter on 15/1/5.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import "UserViewController.h"
#import "GKAPI.h"
#import "HMSegmentedControl.h"
#import "EntityThreeGridCell.h"
#import "NoteSingleListCell.h"
#import "TagCell.h"
#import "FanViewController.h"
#import "FriendViewController.h"
#import "TagViewController.h"
#import "LoginView.h"

@interface UserViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray * dataArrayForEntity;
@property(nonatomic, strong) NSMutableArray * dataArrayForNote;
@property(nonatomic, strong) NSMutableArray * dataArrayForTag;

@property(nonatomic, assign) NSUInteger index;
@property(nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, assign) NSTimeInterval likeTimestamp;
@property (nonatomic, strong) UIButton *followButton;

@end

@implementation UserViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (!self.followButton)
        {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 105, 30)];
            button.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:12];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button.center = CGPointMake(kScreenWidth - 40, 25);
            //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
            self.followButton = button;
        }
        [self configFollowButton];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, kScreenWidth, kScreenHeight-kNavigationBarHeight - kStatusBarHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = UIColorFromRGB(0XF8F8F8);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:self.tableView];
    
    __weak __typeof(&*self)weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf refresh];
    }];
    

     [self.tableView addInfiniteScrollingWithActionHandler:^{
         [weakSelf loadMore];
     }];
}
- (void)setUser:(GKUser *)user
{
    _user = user;
    self.title = _user.nickname;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self configHeaderView];
    [self.tableView reloadData];
    if (self.dataArrayForEntity.count == 0) {
        [self refresh];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

 
    
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

#pragma mark - Data

- (void)configEmptyState
{
    
    NSUInteger index = self.segmentedControl.selectedSegmentIndex;
    self.index = index;
    switch (index) {
        case 0:
        {
            
            if (self.dataArrayForEntity.count == 0) {
                UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 66)];
                button.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:12];
                button.titleLabel.textAlignment = NSTextAlignmentCenter;
                [button setTitleColor:UIColorFromRGB(0x9d9e9f) forState:UIControlStateNormal];
                [button setTitle:[NSString stringWithFormat:@"%@ 还没有标记过喜欢的商品",[NSString fontAwesomeIconStringForEnum:FAHeartO]] forState:UIControlStateNormal];
                [button setTitleEdgeInsets:UIEdgeInsetsMake(8, 0, 0, 0)];
                button.backgroundColor = [UIColor clearColor];
                button.userInteractionEnabled = NO;
                
                {
                    UIView * H = [[UIView alloc] initWithFrame:CGRectMake(30,65.5, kScreenWidth-60, 0.5)];
                    H.backgroundColor = UIColorFromRGB(0xebebeb);
                    [button addSubview:H];
                }
                self.tableView.tableFooterView = button;
            }
            else
            {
                self.tableView.tableFooterView = nil;
            }
        }
            break;
        case 1:
        {
            if (self.dataArrayForNote.count == 0) {
                UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 66)];
                button.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:12];
                button.titleLabel.textAlignment = NSTextAlignmentCenter;
                [button setTitleColor:UIColorFromRGB(0x9d9e9f) forState:UIControlStateNormal];
                [button setTitle:[NSString stringWithFormat:@"%@ 还没有点评过商品",[NSString fontAwesomeIconStringForEnum:FAPencilSquareO]] forState:UIControlStateNormal];
                [button setTitleEdgeInsets:UIEdgeInsetsMake(8, 0, 0, 0)];
                button.backgroundColor = [UIColor clearColor];
                button.userInteractionEnabled = NO;
                {
                    UIView * H = [[UIView alloc] initWithFrame:CGRectMake(30,65.5, kScreenWidth-60, 0.5)];
                    H.backgroundColor = UIColorFromRGB(0xebebeb);
                    [button addSubview:H];
                }
                self.tableView.tableFooterView = button;
            }
            else
            {
                self.tableView.tableFooterView = nil;
            }
        }
            break;
        case 2:
        {
            if (self.dataArrayForTag.count == 0) {
                UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 66)];
                button.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:12];
                button.titleLabel.textAlignment = NSTextAlignmentCenter;
                [button setTitleColor:UIColorFromRGB(0x9d9e9f) forState:UIControlStateNormal];
                [button setTitle:[NSString stringWithFormat:@"%@ 还没有为商品添加过标签",[NSString fontAwesomeIconStringForEnum:FATag]] forState:UIControlStateNormal];
                [button setTitleEdgeInsets:UIEdgeInsetsMake(8, 0, 0, 0)];
                button.backgroundColor = [UIColor clearColor];
                button.userInteractionEnabled = NO;
                {
                    UIView * H = [[UIView alloc] initWithFrame:CGRectMake(30,65.5, kScreenWidth-60, 0.5)];
                    H.backgroundColor = UIColorFromRGB(0xebebeb);
                    [button addSubview:H];
                }
                self.tableView.tableFooterView = button;
            }
            else
            {
                self.tableView.tableFooterView = nil;
            }
        }
    }
}
- (void)refresh
{
    if (self.index == 0) {
        [GKAPI getUserLikeEntityListWithUserId:self.user.userId timestamp:[[NSDate date] timeIntervalSince1970] count:30 success:^(NSTimeInterval timestamp, NSArray *dataArray) {
            self.dataArrayForEntity = [NSMutableArray arrayWithArray:dataArray];
            self.likeTimestamp = timestamp;
            [self configEmptyState];
            [self.tableView reloadData];
            [self.tableView.pullToRefreshView stopAnimating];
            
        } failure:^(NSInteger stateCode) {
            [SVProgressHUD showImage:nil status:@"失败"];
            [self.tableView reloadData];
            [self.tableView.pullToRefreshView stopAnimating];
        }];
    }
    else if (self.index == 1)
    {
        [GKAPI getUserNoteListWithUserId:self.user.userId timestamp:[[NSDate date] timeIntervalSince1970] count:30 success:^(NSArray *dataArray) {
            self.dataArrayForNote = [NSMutableArray arrayWithArray:dataArray];
            [self configEmptyState];
            [self.tableView reloadData];
            [self.tableView.pullToRefreshView stopAnimating];
        } failure:^(NSInteger stateCode) {
            [SVProgressHUD showImage:nil status:@"失败"];
            [self.tableView reloadData];
            [self.tableView.pullToRefreshView stopAnimating];
        }];
    }
    else if (self.index == 2)
    {
        [GKAPI getTagListWithUserId:self.user.userId offset:0 count:30 success:^(GKUser *user, NSArray *tagArray) {
            self.dataArrayForTag = [NSMutableArray arrayWithArray:tagArray];
            [self configEmptyState];
            [self.tableView reloadData];
            [self.tableView.pullToRefreshView stopAnimating];
        } failure:^(NSInteger stateCode) {
            [SVProgressHUD showImage:nil status:@"失败"];
            [self.tableView reloadData];
            [self.tableView.pullToRefreshView stopAnimating];
        }];
    }
    return;
}
- (void)loadMore
{
    if (self.index == 0) {
        GKEntity *entity = self.dataArrayForEntity.lastObject;
        NSTimeInterval likeTimestamp = entity ? self.likeTimestamp : [[NSDate date] timeIntervalSince1970];
        [GKAPI getUserLikeEntityListWithUserId:self.user.userId timestamp:likeTimestamp count:30 success:^(NSTimeInterval timestamp, NSArray *dataArray) {
            [self.dataArrayForEntity addObjectsFromArray:dataArray];
            self.likeTimestamp = timestamp;
            [self.tableView reloadData];
            [self.tableView.infiniteScrollingView stopAnimating];
        } failure:^(NSInteger stateCode) {
            [SVProgressHUD showImage:nil status:@"失败"];
            [self.tableView reloadData];
            [self.tableView.infiniteScrollingView stopAnimating];
        }];
    }
    else if (self.index == 1)
    {
        GKNote *note = [self.dataArrayForNote.lastObject objectForKey:@"note"];
        NSTimeInterval timestamp = note ? note.createdTime : [[NSDate date] timeIntervalSince1970];
        [GKAPI getUserNoteListWithUserId:self.user.userId timestamp:timestamp count:30 success:^(NSArray *dataArray) {
            [self.dataArrayForNote addObjectsFromArray:dataArray];
            [self.tableView reloadData];
            [self.tableView.infiniteScrollingView stopAnimating];
        } failure:^(NSInteger stateCode) {
            [SVProgressHUD showImage:nil status:@"失败"];
            [self.tableView reloadData];
            [self.tableView.infiniteScrollingView stopAnimating];
        }];
    }
    else if (self.index == 2)
    {
        [self.tableView reloadData];
        [self.tableView.infiniteScrollingView stopAnimating];
    }
    return;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.index == 0) {
        return 1;
    }
    else if (self.index == 1)
    {
        return 1;
    }
    else if (self.index == 2)
    {
        return 1;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.tableView)
    {
        if (self.index == 0) {
            return ceil(self.dataArrayForEntity.count / (CGFloat)3);
        }
        else if (self.index == 1)
        {
            return ceil(self.dataArrayForNote.count / (CGFloat)1);
        }
        else if (self.index == 2)
        {
            return ceil(self.dataArrayForTag.count / (CGFloat)1);
        }
        return 0;
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tableView)
    {
        if (self.index == 0) {
            static NSString *CellIdentifier = @"EntityCell";
            EntityThreeGridCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[EntityThreeGridCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.backgroundColor = UIColorFromRGB(0xf8f8f8);
            NSArray *entityArray = self.dataArrayForEntity;
            NSMutableArray *array = [[NSMutableArray alloc] init];
            NSUInteger offset = indexPath.row * 3;
            for (NSUInteger i = 0; i < 3 && offset < entityArray.count; i++) {
                [array addObject:entityArray[offset++]];
            }
            
            cell.entityArray = array;
            
            return cell;
        }
        else if (self.index == 1)
        {
            static NSString *NoteCellIdentifier = @"NoteCell";
            NoteSingleListCell *cell = [tableView dequeueReusableCellWithIdentifier:NoteCellIdentifier];
            if (!cell) {
                cell = [[NoteSingleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NoteCellIdentifier];
            }
            cell.note = [[self.dataArrayForNote objectAtIndex:indexPath.row] objectForKey:@"note"];
            
            return cell;
        }
        else if (self.index == 2)
        {
            static NSString *TagCellIdentifier = @"TagCell";
            TagCell *cell = [tableView dequeueReusableCellWithIdentifier:TagCellIdentifier];
            if (!cell) {
                cell = [[TagCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TagCellIdentifier];
            }

            cell.tagName = [[self.dataArrayForTag objectAtIndex:indexPath.row] objectForKey:@"tag"];
            cell.entityCount = [[[self.dataArrayForTag objectAtIndex:indexPath.row] objectForKey:@"entity_count"] integerValue];
            
            return cell;
        }
        return [[UITableViewCell alloc] init];
    }
    else
    {
        return [[UITableViewCell alloc] init];
    }
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tableView)
    {
        if (self.index == 0) {
            return [EntityThreeGridCell height];
        }
        else if (self.index == 1)
        {
            GKNote * note =  [[self.dataArrayForNote objectAtIndex:indexPath.row] objectForKey:@"note"];
            GKEntity * entity =  [[self.dataArrayForNote objectAtIndex:indexPath.row] objectForKey:@"entity"];
            note.entityChiefImage = entity.imageURL_640x640;
            return [NoteSingleListCell height:note];
        }
        else if(self.index ==2)
        {
            return [TagCell height];
        }
        
        return 0;
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == self.tableView)
    {
        return 44;
    }
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView == self.tableView)
    {
        if (!self.segmentedControl) {
            HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
            [segmentedControl setSectionTitles:@[[NSString stringWithFormat:@"喜爱 %ld",self.user.likeCount], [NSString stringWithFormat:@"点评 %ld",self.user.noteCount],[NSString stringWithFormat:@"标签 %ld",self.user.tagCount]]];
            [segmentedControl setSelectedSegmentIndex:0 animated:NO];
            [segmentedControl setSelectionStyle:HMSegmentedControlSelectionStyleTextWidthStripe];
            [segmentedControl setSelectionIndicatorLocation:HMSegmentedControlSelectionIndicatorLocationDown];
            [segmentedControl setSelectionIndicatorHeight:2.5];
            [segmentedControl setTextColor:UIColorFromRGB(0x9d9e9f)];
            [segmentedControl setSelectedTextColor:UIColorFromRGB(0x414243)];
            [segmentedControl setBackgroundColor:UIColorFromRGB(0xffffff)];
            [segmentedControl setSelectionIndicatorColor:UIColorFromRGB(0xDB1F77)];
            [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];

            self.segmentedControl = segmentedControl;
            
            {
                UIView * H = [[UIView alloc] initWithFrame:CGRectMake(0,self.segmentedControl.deFrameHeight-0.5, kScreenWidth, 0.5)];
                H.backgroundColor = UIColorFromRGB(0xebebeb);
                [self.segmentedControl addSubview:H];
            }
            {
                UIView * H = [[UIView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, 0.5)];
                H.backgroundColor = UIColorFromRGB(0xebebeb);
                [self.segmentedControl addSubview:H];
            }
            
            {
                UIView * V = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/3,44/2-7, 1,14 )];
                V.backgroundColor = UIColorFromRGB(0xebebeb);
                [segmentedControl addSubview:V];
            }
            {
                UIView * V = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth*2/3,44/2-7, 1,14 )];
                V.backgroundColor = UIColorFromRGB(0xebebeb);
                [segmentedControl addSubview:V];
            }
        }
        
        
        [self.segmentedControl setSectionTitles:@[[NSString stringWithFormat:@"喜爱 %ld",self.user.likeCount], [NSString stringWithFormat:@"点评 %ld",self.user.noteCount],[NSString stringWithFormat:@"标签 %ld",self.user.tagCount]]];

        
        return self.segmentedControl;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.index == 2) {
        TagViewController * VC = [[TagViewController alloc]init];
        VC.tagName = [[self.dataArrayForTag objectAtIndex:indexPath.row] objectForKey:@"tag"];
        VC.user = self.user;
        [self.navigationController pushViewController:VC animated:YES];
    }
}

#pragma mark - HMSegmentedControl
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSUInteger index = segmentedControl.selectedSegmentIndex;
    self.index = index;
    [self.tableView reloadData];
    switch (index) {
        case 0:
        {
            if (self.dataArrayForEntity.count == 0) {
                [self.tableView.pullToRefreshView startAnimating];
                [self refresh];
            }
            else
            {
                [self configEmptyState];
            }
        }
            break;
        case 1:
        {
            if (self.dataArrayForNote.count == 0) {
                [self.tableView.pullToRefreshView startAnimating];
                [self refresh];
            }
            else
            {
                [self configEmptyState];
            }
        }
            break;
        case 2:
        {
            if (self.dataArrayForTag.count == 0) {
                [self.tableView.pullToRefreshView startAnimating];
                [self refresh];
            }
            else
            {
                [self configEmptyState];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)configHeaderView
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 260)];
    view.backgroundColor = UIColorFromRGB(0xfafafa);
    
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(7.f, 7.f, 64, 64)];
    image.contentMode = UIViewContentModeScaleAspectFit;
    image.center = CGPointMake(kScreenWidth/2, 25+32);
    image.layer.cornerRadius = 32;
    image.layer.masksToBounds = YES;
    image.backgroundColor = UIColorFromRGB(0xffffff);
    [image sd_setImageWithURL:self.user.avatarURL];
    [view addSubview:image];
    

    UILabel * nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 20.f, 320.f, 25.f)];
    nicknameLabel.backgroundColor = [UIColor clearColor];
    nicknameLabel.font = [UIFont boldSystemFontOfSize:18];
    nicknameLabel.textAlignment = NSTextAlignmentCenter;
    nicknameLabel.textColor = UIColorFromRGB(0x555555);
    nicknameLabel.text = self.user.nickname;
    nicknameLabel.adjustsFontSizeToFitWidth = YES;
    [nicknameLabel sizeToFit];
    nicknameLabel.center = image.center;
    nicknameLabel.deFrameTop = image.deFrameBottom+12;
    nicknameLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:nicknameLabel];
    

    UIImageView * gender = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 14, 14)];
    gender.center = CGPointMake(nicknameLabel.deFrameRight+10 ,nicknameLabel.center.y);
    if ([self.user.gender isEqualToString:@"M"]) {
        gender.image = [UIImage imageNamed:@"user_icon_male.png"];
    }
    else if([self.user.gender isEqualToString:@"F"]) {
        gender.image = [UIImage imageNamed:@"user_icon_famale.png"];
    }
    else
    {
        gender.image = nil;
    }
    [view addSubview:gender];
    

    UILabel * bioLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 20.f, 260.f, 30.f)];
    bioLabel.numberOfLines = 0;
    bioLabel.backgroundColor = [UIColor clearColor];
    bioLabel.font = [UIFont systemFontOfSize:12];
    bioLabel.textAlignment = NSTextAlignmentCenter;
    bioLabel.textColor = UIColorFromRGB(0x999999);
    bioLabel.text = self.user.bio;
    bioLabel.center = image.center;
    bioLabel.backgroundColor = [UIColor clearColor];
    if ([self.user.bio isEqualToString:@""]||!self.user.bio) {
        bioLabel.deFrameHeight = 0;
        bioLabel.deFrameTop = nicknameLabel.deFrameBottom+0;
    }
    else
    {
        bioLabel.deFrameTop = nicknameLabel.deFrameBottom+10;
        bioLabel.deFrameHeight = 30;
    }
    [view addSubview:bioLabel];
    
   
    
    UIButton * friendButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/2-10, 20)];
    [friendButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [friendButton setTitleColor:UIColorFromRGB(0x777777) forState:UIControlStateNormal];
    [friendButton addTarget:self action:@selector(friendButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [friendButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [friendButton.titleLabel setTextAlignment:NSTextAlignmentRight];
    [friendButton setTitle:[NSString stringWithFormat:@"%ld 关注",_user.followingCount] forState:UIControlStateNormal];
    if (self.user.userId == [Passport sharedInstance].user.userId) {
        friendButton.deFrameTop = bioLabel.deFrameBottom+10;
    }
    else
    {
        friendButton.deFrameTop = bioLabel.deFrameBottom+10;
    }
    [view addSubview:friendButton];
    

    UIButton * fanButton = [[UIButton alloc]initWithFrame:CGRectMake( kScreenWidth/2+10, 0, kScreenWidth -10, 20)];
    [fanButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [fanButton setTitleColor:UIColorFromRGB(0x777777) forState:UIControlStateNormal];
    [fanButton addTarget:self action:@selector(fanButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [fanButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [fanButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    fanButton.deFrameTop = friendButton.deFrameTop;
    [fanButton setTitle:[NSString stringWithFormat:@"%ld 粉丝",_user.fanCount] forState:UIControlStateNormal];
    [view addSubview:fanButton];
    
    
    self.followButton.center = CGPointMake(kScreenWidth/2, fanButton.center.y+40);
    [view addSubview:self.followButton];
    
    
    UIView * V = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 20)];
    V.backgroundColor = UIColorFromRGB(0xc8c8c8);
    V.center = CGPointMake(kScreenWidth/2, fanButton.center.y);
    [view addSubview:V];
    
    self.tableView.tableHeaderView = view;
    
    [self configFollowButton];
}

- (void)friendButtonAction
{
    FriendViewController * VC = [[FriendViewController alloc]init];
    VC.user = self.user;
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)fanButtonAction
{
    FanViewController * VC = [[FanViewController alloc]init];
    VC.user = self.user;
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)configFollowButton
{
    for (id target in [self.followButton allTargets]) {
        [self.followButton removeTarget:target action:NULL forControlEvents:UIControlEventAllEvents];
    }
    self.followButton.hidden = NO;
    if (self.user.relation == GKUserRelationTypeNone) {
        [self.followButton setTitle:[NSString stringWithFormat:@"%@ 关注",[NSString fontAwesomeIconStringForEnum:FAPlus]] forState:UIControlStateNormal];
        [self.followButton setBackgroundColor:UIColorFromRGB(0x427ec0)];
        [self.followButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [self.followButton addTarget:self action:@selector(followButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    if (self.user.relation == GKUserRelationTypeFan) {
        [self.followButton setTitle:[NSString stringWithFormat:@"%@ 关注",[NSString fontAwesomeIconStringForEnum:FAPlus]]  forState:UIControlStateNormal];
        [self.followButton setBackgroundColor:UIColorFromRGB(0x427ec0)];
        [self.followButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [self.followButton addTarget:self action:@selector(followButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    if (self.user.relation == GKUserRelationTypeFollowing) {
        [self.followButton setTitle:[NSString stringWithFormat:@"%@ 已关注",[NSString fontAwesomeIconStringForEnum:FACheck]]  forState:UIControlStateNormal];
        [self.followButton setBackgroundColor:UIColorFromRGB(0xf6f6f6)];
        [self.followButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [self.followButton addTarget:self action:@selector(unfollowButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    if (self.user.relation == GKUserRelationTypeBoth) {
        [self.followButton setTitle:[NSString stringWithFormat:@"%@ 互相关注",[NSString fontAwesomeIconStringForEnum:FAExchange]]  forState:UIControlStateNormal];
        [self.followButton setBackgroundColor:UIColorFromRGB(0xf6f6f6)];
        [self.followButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [self.followButton addTarget:self action:@selector(unfollowButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    if (self.user.relation == GKUserRelationTypeSelf) {
        self.followButton.hidden = YES;
    }
}
- (void)followButtonAction
{
    if(!k_isLogin)
    {
        LoginView * view = [[LoginView alloc]init];
        [view show];
        return;
    }
    [GKAPI followUserId:self.user.userId state:YES success:^(GKUserRelationType relation) {
        self.user.relation = relation;
        [self configFollowButton];
        [SVProgressHUD showImage:nil status:@"关注成功"];
    } failure:^(NSInteger stateCode) {
        [SVProgressHUD showImage:nil status:@"关注失败"];
    }];
}
- (void)unfollowButtonAction
{
    if(!k_isLogin)
    {
        LoginView * view = [[LoginView alloc]init];
        [view show];
        return;
    }
    [GKAPI followUserId:self.user.userId state:NO success:^(GKUserRelationType relation) {
        self.user.relation = relation;
        [self configFollowButton];
        [SVProgressHUD showImage:nil status:@"取关成功"];
    } failure:^(NSInteger stateCode) {
        [SVProgressHUD showImage:nil status:@"取关失败"];
    }];
}

@end
