//
//  PadProjectGroupView.m
//  meim
//
//  Created by jimmy on 2017/5/16.
//
//

#import "PadProjectGroupView.h"
#import "PadProjectGroupCollectionViewCell.h"

@interface PadProjectGroupView ()
@property(nonatomic, weak)IBOutlet UICollectionView* collectionView;
@end

@implementation PadProjectGroupView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.collectionView registerNib:[UINib nibWithNibName: @"PadProjectGroupCollectionViewCell" bundle: nil] forCellWithReuseIdentifier:@"PadProjectGroupCollectionViewCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PadProjectGroupCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PadProjectGroupCollectionViewCell" forIndexPath:indexPath];
    
    CDProjectItem* item = self.itemArray[indexPath.row];
    cell.item = item;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(158,167);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(18, 16, 18, 16);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    CDProjectItem* item = self.itemArray[indexPath.row];
    [self removeFromSuperview];
    self.selectItem(item);
}

- (void)show
{
    self.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)didCloseButtonPressed:(id)sender
{
    [self hide];
}

@end
