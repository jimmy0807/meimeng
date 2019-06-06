//
//  HPatientTypeFilterViewController.m
//  meim
//
//  Created by jimmy on 2017/7/18.
//
//

#import "HPatientTypeFilterViewController.h"
#import "HPatientTypeFilterCollectionViewCell.h"

@interface HPatientTypeFilterViewController ()
@property(nonatomic, weak)IBOutlet UICollectionView* collectionView;
@property(nonatomic, strong)NSArray* types;
@end

@implementation HPatientTypeFilterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ( self.set == nil )
    {
        self.set = [NSMutableSet set];
    }
    
    [self reloadData];
    
    [self.collectionView registerNib:[UINib nibWithNibName: @"HPatientTypeFilterCollectionViewCell" bundle: nil] forCellWithReuseIdentifier:@"HPatientTypeFilterCollectionViewCell"];
}

- (void)reloadData
{
    self.types = [[BSCoreDataManager currentManager] fetchAllTopHuizhenCategory];
}

- (IBAction)didBackButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (IBAction)didConfirmButtonPressed:(id)sender
{
    if ( self.selectFinished )
    {
        NSMutableArray* array = [NSMutableArray array];
        for ( NSNumber* n in self.set )
        {
            CDHHuizhenCategory* c = self.types[n.integerValue];
            [array addObject:c.cateogry_id];
        }
        self.selectFinished(self.set, array);
    }
    
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.types.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HPatientTypeFilterCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HPatientTypeFilterCollectionViewCell" forIndexPath:indexPath];
    
    cell.category = self.types[indexPath.row];
    cell.isChecked = [self.set containsObject:@(indexPath.row)];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(185,160);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 12;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [self.set containsObject:@(indexPath.row)] )
    {
        [self.set removeObject:@(indexPath.row)];
    }
    else
    {
        [self.set addObject:@(indexPath.row)];
    }
    
    [collectionView reloadData];
}

@end
