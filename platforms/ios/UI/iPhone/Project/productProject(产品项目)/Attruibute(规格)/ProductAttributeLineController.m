//
//  ProductAttributeLineController.m
//  ds
//
//  Created by lining on 2016/11/3.
//
//

#import "ProductAttributeLineController.h"
#import "BSAttributeLine.h"
#import "BSAttributeValue.h"
#import "AttributeLineHeadView.h"
#import "AttributeBtnCell.h"
#import "AttributeSelectedView.h"

@interface ProductAttributeLineController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,AttributeSelectedViewDelegate,AttributeLineHeadViewDelegate,AttributeBtnCellDelegate>
@property (strong, nonatomic) IBOutlet UIView *noView;


@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) AttributeSelectedView *attributeSelectedView;

@end

@implementation ProductAttributeLineController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *backItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    backItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backItem;
    
    
    BNRightButtonItem *rightButtonItem = [[BNRightButtonItem alloc] initWithNormalImage:[UIImage imageNamed:@"navi_add_n.png"] highlightedImage:[UIImage imageNamed:@"navi_add_h.png"]];
    rightButtonItem.delegate = self;
    
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    self.title = @"规格";
    
    if (self.attributeLines == nil) {
        self.attributeLines = [NSMutableArray array];
    }
    
    [self initView];
}

#pragma mark - initView
- (void)initView
{
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"AttributeLineHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"AttributeLineHeadView"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"AttributeBtnCell" bundle:nil] forCellWithReuseIdentifier:@"AttributeBtnCell"];
    
    self.attributeSelectedView = [AttributeSelectedView createView];
    self.attributeSelectedView.delegate = self;
    
    [self reloadView];
}


- (void)reloadView
{
    if (self.attributeLines.count == 0) {
        self.noView.hidden = false;
        self.collectionView.hidden = true;
    }
    else
    {
        self.noView.hidden = true;
        self.collectionView.hidden = false;
        [self.collectionView reloadData];
    }
}



#pragma mark - CBBackButtonItemDelegate
-(void)didItemBackButtonPressed:(UIButton*)sender
{
    if ([self.delegate respondsToSelector:@selector(didSelectedAttributeLines:)]) {
        [self.delegate didSelectedAttributeLines:self.attributeLines];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - BNRightButtonItemDelegate
- (void)didRightBarButtonItemClick:(id)sender
{
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (int i = 0; i < self.attributeLines.count; i++)
    {
        BSAttributeLine *attributeLine = [self.attributeLines objectAtIndex:i];
        [mutableArray addObject:attributeLine.attributeID];
    }
    
    self.attributeSelectedView.notShowAttributeIDs = mutableArray;
    [self.attributeSelectedView show];
}


#pragma mark - ButtonAction
- (IBAction)didAddBtnPressed:(id)sender {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (int i = 0; i < self.attributeLines.count; i++)
    {
        BSAttributeLine *attributeLine = [self.attributeLines objectAtIndex:i];
        [mutableArray addObject:attributeLine.attributeID];
    }
    
    self.attributeSelectedView.notShowAttributeIDs = mutableArray;
    [self.attributeSelectedView show];
}



#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.attributeLines.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    BSAttributeLine *attributeLine = [self.attributeLines objectAtIndex:section];
    
    return attributeLine.attributeValues.count + 1;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
 
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    AttributeBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AttributeBtnCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.normalImageName = @"attribute_rect_blue.png";
    
    
   
    
    cell.delegate = self;
    cell.indexPath = indexPath;

    BSAttributeLine *attributeLine = [self.attributeLines objectAtIndex:section];
    if (row < attributeLine.attributeValues.count) {
        cell.longPressedDelete = true;
        BSAttributeValue *attributeValue = [attributeLine.attributeValues objectAtIndex:row];
        cell.title = attributeValue.attributeValueName;
        cell.object = attributeValue;
        cell.normalColor = COLOR(0, 167, 254, 1);
//        cell.selectedImageName = @"attribute_solid_blue.png";
//        cell.selectedColor = COLOR(0, 167, 254, 1);
    }
    else
    {
        cell.longPressedDelete = false;
        cell.normalImageName = @"attribute_rect_gray.png";
        cell.normalColor = COLOR(150, 150, 150, 1);
//        cell.selectedColor = COLOR(150, 150, 150, 1);
        cell.title = @"+";
        cell.object = nil;
    }
    cell.deleteBtnShow = false;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isKindOfClass:[UICollectionElementKindSectionHeader class]])
    {
        AttributeLineHeadView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"AttributeLineHeadView" forIndexPath:indexPath];
        headView.indexPath = indexPath;
        headView.delegate = self;
        
        BSAttributeLine *attributeLine = [self.attributeLines objectAtIndex:indexPath.section];
        headView.attributeLine = attributeLine;
        headView.titleLabel.text = attributeLine.attributeName;
        headView.backgroundColor = COLOR(245, 245, 245, 1);
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
   return UIEdgeInsetsMake(5, 10,5,10);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){collectionView.frame.size.width,44};
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    //    return (CGSize){ScreenWidth,22};
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - AttributeBtnCellDelegate
- (void)didBtnSelected:(BOOL)selected object:(NSObject *)object atIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    BSAttributeLine *attributeLine = [self.attributeLines objectAtIndex:section];
    if (object) {
        
    }
    else
    {
        self.attributeSelectedView.attributeLine = attributeLine;
        [self.attributeSelectedView show];
    }
}
- (void)didDeleteBtnPressedObject:(NSObject *)object atIndexPath:(NSIndexPath *)indexPath
{
    BSAttributeValue *attributeValue = (BSAttributeValue *)object;
    BSAttributeLine *attributeLine = attributeValue.attributeLine;
    
    NSInteger section = [self.attributeLines indexOfObject:attributeLine];
    NSInteger row = [attributeLine.attributeValues indexOfObject:attributeValue];
    
    [attributeLine.attributeValues removeObjectAtIndex:row];
    
    [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section]]];
}

#pragma mark - AttributeLineHeadViewDelegate
- (void)didLineHeadDeleteAttributeLine:(BSAttributeLine *)attributeLine
{
    NSInteger section = [self.attributeLines indexOfObject:attributeLine];
    [self.attributeLines removeObject:attributeLine];
    [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:section]];
    
//    [self.collectionView reloadData];
//    [self performSelectorOnMainThread:@selector(reloadData) withObject:0 waitUntilDone:YES]
    [self performSelector:@selector(reloadView) withObject:nil afterDelay:0.5];
}


#pragma mark - AttributeSelectedViewDelegate
- (void)didSureBtnPressedWithAttributes:(NSArray *)attributes
{
    for (CDProjectAttribute *attribute in attributes) {
        BSAttributeLine *bsAttributeLine = [[BSAttributeLine alloc] init];
        bsAttributeLine.attributeID = attribute.attributeID;
        bsAttributeLine.attributeName = attribute.attributeName;
        bsAttributeLine.attributeValues = [NSMutableArray array];
        [self.attributeLines addObject:bsAttributeLine];
    }
    [self reloadView];
}

- (void)didSureBtnPressedWithAttributeValues:(NSArray *)attributeValues
{
    [self reloadView];
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
