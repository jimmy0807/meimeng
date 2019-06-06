//
//  HPartnerListViewController.m
//  meim
//
//  Created by jimmy on 2017/4/26.
//
//

#import "HPartnerListViewController.h"

#import "HPartnerListCollectionViewCell.h"
#import "BSFetchPartnerRequest.h"
#import "HCustomerListHeadReusableView.h"
#import "HPartnerCreateContainerViewController.h"

//#import "PadHospitalCustomerDetailViewController.h"
//#import "PadHospitalCreateCustomerContainerViewController.h"

@interface HPartnerListViewController ()<UISearchBarDelegate>
@property(nonatomic, weak)IBOutlet UICollectionView* collectionView;
@property (nonatomic, strong) NSNumber *storeID;
@property (nonatomic, strong) NSArray *members;
@property (nonatomic, strong) NSString *keyword;
@property(nonatomic, strong)NSMutableDictionary* imageCacheDictionary;
@end

@implementation HPartnerListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self forbidSwipGesture];
    
    self.imageCacheDictionary = [NSMutableDictionary dictionary];
    
    //[[[BSFetchPartnerRequest alloc] init] execute];
    
    //self.storeID = [[PersonalProfile currentProfile].shopIds firstObject];
    
    [self reloadPartner:nil];
    [self registerNofitificationForMainThread:kBSFetchPartnerResponse];
    [self registerNofitificationForMainThread:kHPartnerCreateResponse];
    
    [self.collectionView registerNib:[UINib nibWithNibName: @"HPartnerListCollectionViewCell" bundle: nil] forCellWithReuseIdentifier:@"HPartnerListCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName: @"HCustomerListHeadReusableView" bundle: nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HCustomerListHeadReusableView"];
    [self setHeader];
}

- (void)setHeader
{
    HCustomerListHeadReusableView* v = (HCustomerListHeadReusableView*)[UIView loadNibNamed:@"HCustomerListHeadReusableView"];
    v.searchBar.delegate = self;
    v.frame = CGRectMake(0, 75, 1024, 64);
    [self.view addSubview:v];
}

- (void)reloadPartner:(NSString*)keyword
{
    self.members = [[BSCoreDataManager currentManager] fetchPartnerWithKeyWord:keyword];
    [self.collectionView reloadData];
}

#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSFetchPartnerResponse])
    {
        if (self.keyword.length == 0)
        {
            [self reloadPartner:nil];
        }
    }
    else if ([notification.name isEqualToString:kHPartnerCreateResponse])
    {
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
        {
            [self reloadPartner:nil];
        }
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
    HPartnerListCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HPartnerListCollectionViewCell" forIndexPath:indexPath];
    
    CDPartner* partner = self.members[indexPath.row];
    cell.partner = partner;
    
    [cell.logoImageView setImageWithName:[NSString stringWithFormat:@"%@_%@",partner.partner_id, partner.name] tableName:@"born.partner" filter:partner.partner_id fieldName:@"image" writeDate:partner.lastUpdate placeholderString:@"pad_avatar_default" cacheDictionary:self.imageCacheDictionary];
    
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
    CDPartner* partner = self.members[indexPath.row];
    UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"HPartnerBoard" bundle:nil];
    HPartnerCreateContainerViewController* vc = [tableViewStoryboard instantiateInitialViewController];
    vc.partner = partner;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self reloadPartner:searchText];
}

- (IBAction)didCreatePartnerButtonPressed:(id)sender
{
    UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"HPartnerBoard" bundle:nil];
    HPartnerCreateContainerViewController* vc = [tableViewStoryboard instantiateInitialViewController];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)didBackButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
