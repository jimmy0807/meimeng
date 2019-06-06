//
//  AttributeLineViewCell.m
//  ds
//
//  Created by lining on 2016/11/7.
//
//

#import "AttributeLineViewCell.h"
#import "AttributeLineHeadView.h"
#import "AttributeBtnCell.h"

@interface AttributeLineViewCell ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation AttributeLineViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"AttributeLineHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"AttributeLineHeadView"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"AttributeBtnCell" bundle:nil] forCellWithReuseIdentifier:@"AttributeBtnCell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

- (void)setAttributeLines:(NSArray *)attributeLines
{
    _attributeLines = attributeLines;
    [self.collectionView reloadData];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.attributeLines.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    BSAttributeLine *attributeLine = [self.attributeLines objectAtIndex:section];
    
    return attributeLine.attributeValues.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    AttributeBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AttributeBtnCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.normalImageName = @"attribute_rect_blue.png";
 
    cell.indexPath = indexPath;
    
    BSAttributeLine *attributeLine = [self.attributeLines objectAtIndex:section];
    if (row < attributeLine.attributeValues.count) {
        cell.longPressedDelete = true;
        BSAttributeValue *attributeValue = [attributeLine.attributeValues objectAtIndex:row];
        cell.title = attributeValue.attributeValueName;
        cell.object = attributeValue;
        cell.normalColor = COLOR(0, 167, 254, 1);
        
    }
    else
    {
        cell.longPressedDelete = false;
        cell.normalImageName = @"attribute_rect_gray.png";
        cell.normalColor = COLOR(150, 150, 150, 1);
        cell.title = @"+";
        cell.object = nil;
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isKindOfClass:[UICollectionElementKindSectionHeader class]])
    {
        AttributeLineHeadView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"AttributeLineHeadView" forIndexPath:indexPath];
        headView.indexPath = indexPath;
        headView.titleLabel.font = [UIFont systemFontOfSize:14];
        headView.titleLabel.textColor = [UIColor grayColor];
        headView.deleteBtn.hidden = true;
        BSAttributeLine *attributeLine = [self.attributeLines objectAtIndex:indexPath.section];
        headView.attributeLine = attributeLine;
        headView.titleLabel.text = attributeLine.attributeName;
        
        return headView;
    }
    else
    {
        UICollectionReusableView *footView = (UICollectionReusableView*)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"footView" forIndexPath:indexPath];
        footView.backgroundColor = [UIColor whiteColor];
        return footView;
    }
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((IC_SCREEN_WIDTH - 20)/4, 40);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10,0,10);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){collectionView.frame.size.width,36};
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    //    return (CGSize){ScreenWidth,22};
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
