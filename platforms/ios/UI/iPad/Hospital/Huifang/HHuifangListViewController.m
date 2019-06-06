//
//  HHuifangListViewController.m
//  meim
//
//  Created by jimmy on 2017/4/26.
//
//

#import "HHuifangListViewController.h"
#import "FetchHMemberVisitRequest.h"
#import "HHuifangListCollectionViewCell.h"
#import "HCustomerListHeadReusableView.h"
#import "MJRefresh.h"
#import "HHuifangTypeViewController.h"
#import "HHuifangCreateContainerViewController.h"

@interface HHuifangListViewController ()<UISearchBarDelegate>
@property(nonatomic, weak)IBOutlet UICollectionView* collectionView;
@property (nonatomic, strong) NSArray *members;
@property (nonatomic, strong) NSString *keyword;
@property(nonatomic, strong)NSMutableDictionary* imageCacheDictionary;
@property(nonatomic)kFetchHMemberVisitRequestType type;
@end

@implementation HHuifangListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self forbidSwipGesture];
    
    self.imageCacheDictionary = [NSMutableDictionary dictionary];
    
    [self registerNofitificationForMainThread:kFetchHMemberResponse];
    [self registerNofitificationForMainThread:kHMemberVisitCreateResponse];
    
    [self.collectionView registerNib:[UINib nibWithNibName: @"HHuifangListCollectionViewCell" bundle: nil] forCellWithReuseIdentifier:@"HHuifangListCollectionViewCell"];
    [self setHeader];
    [self setFooter];
    
    [self fetchDataFromServer:0 keyword:nil];
    [self reloadData:nil];
}

- (void)setHeader
{
    HCustomerListHeadReusableView* v = (HCustomerListHeadReusableView*)[UIView loadNibNamed:@"HCustomerListHeadReusableView"];
    v.searchBar.delegate = self;
    v.frame = CGRectMake(0, 75, 1024, 64);
    [self.view addSubview:v];
}

- (void)setFooter
{
    WeakSelf;
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf fetchDataFromServer:weakSelf.members.count keyword:nil];
    }];
}

- (void)reloadData:(NSString*)keyword
{
    self.members = [[BSCoreDataManager currentManager] fetchMemberVisit:[self typeToString] keyword:keyword];
    [self.collectionView reloadData];
}

- (NSString*)typeToString
{
    if (self.type == HMemberVisitQianzai)
    {
        return @"potential";
    }
    else if (self.type == HMemberVisitShuhou)
    {
        return @"operate";
    }
    else if (self.type == HMemberVisitLaoke)
    {
        return @"old";
    }
    else if (self.type == HMemberVisitRichang)
    {
        return @"day";
    }
    else if (self.type == HMemberVisitTousu)
    {
        return @"festival";
    }
    
    return nil;
}

- (void)fetchDataFromServer:(NSInteger)startIndex keyword:(NSString*)keyword
{
    FetchHMemberVisitRequest* request = [[FetchHMemberVisitRequest alloc] init];
    request.startIndex = startIndex;
    request.keyword = keyword;
    request.type = self.type;
    [request execute];
}

#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kFetchHMemberResponse])
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.keyword.length == 0)
            {
                [self reloadData:nil];
            }
            else
            {
                self.members = notification.object;
                [self.collectionView reloadData];
            }
        });
        
        [self.collectionView.mj_footer endRefreshing];
    }
    else if ([notification.name isEqualToString:kHMemberVisitCreateResponse])
    {
        [self reloadData:nil];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.members.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HHuifangListCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HHuifangListCollectionViewCell" forIndexPath:indexPath];
    
    CDMemberVisit* visit = self.members[indexPath.row];
    cell.visit = visit;
    
    CDMember* c = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:visit.customer_id forKey:@"memberID"];
    
    [cell.logoImageView setImageWithName:[NSString stringWithFormat:@"%@_%@",visit.customer_id, visit.customer_name] tableName:@"born.member" filter:visit.customer_id fieldName:@"image" writeDate:c.lastUpdate placeholderString:@"pad_avatar_default" cacheDictionary:self.imageCacheDictionary];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(323,109);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 16, 25, 16);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}
#if 0
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(1024,64);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    HCustomerListHeadReusableView *cell = (HCustomerListHeadReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HCustomerListHeadReusableView" forIndexPath:indexPath];
    cell.searchBar.delegate = self;
    
    return cell;
}
#endif
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CDMemberVisit* visit = self.members[indexPath.row];
    UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"HHuifangBoard" bundle:nil];
    HHuifangCreateContainerViewController* vc = [tableViewStoryboard instantiateInitialViewController];
    vc.visit = visit;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self reloadData:searchText];
}

- (IBAction)didSelectTypeButtonPressed:(UIButton*)sender
{
    HHuifangTypeViewController *padBookPopoverVC = [[HHuifangTypeViewController alloc] initWithNibName:@"HHuifangTypeViewController" bundle:nil];
    padBookPopoverVC.currentIndex = self.type;
    WeakSelf;
    
    UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:padBookPopoverVC];
    popoverController.popoverContentSize = CGSizeMake(250, 348);
    popoverController.backgroundColor = [UIColor whiteColor];
    
    [popoverController presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:TRUE];
    
    padBookPopoverVC.itemSelected = ^(NSInteger index) {
        weakSelf.type = index;
        [self reloadData:nil];
        [popoverController dismissPopoverAnimated:YES];
    };
}

- (IBAction)didBackButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didCreateHuifangButtonPressed:(id)sender
{
    UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"HHuifangBoard" bundle:nil];
    HHuifangCreateContainerViewController* vc = [tableViewStoryboard instantiateInitialViewController];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dealloc
{
    
}

@end
