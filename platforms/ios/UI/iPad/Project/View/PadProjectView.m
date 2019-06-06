//
//  PadProjectView.m
//  Boss
//
//  Created by XiaXianBing on 15/10/10.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadProjectView.h"
#import "PadProjectCart.h"
#import "PadProjectViewController.h"
#import "PadProjectCollectionAddCell.h"
#import "PadProjectGroupView.h"
#import "MJRefresh.h"
#import "BSProjectItemUpdateAvailableRequest.h"

#define PadProjectCollectionCellIdentifier          @"PadProjectCollectionCellIdentifier"
#define PadProjectCollectionAddCellIdentifier       @"PadProjectCollectionAddCellIdentifier"
#define PadProjectCollectionHeaderIdentifier        @"PadProjectCollectionHeaderIdentifier"

@interface PadProjectView ()

@property (nonatomic, strong) UIImageView *noneImageView;
@property (nonatomic, strong) PadProjectCollectionView *projectCollectionView;

@property (nonatomic, strong) PadProjectData *data;
@property (nonatomic, strong) NSMutableDictionary *cachePicParams;

@end


@implementation PadProjectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.cachePicParams = [[NSMutableDictionary alloc] init];
        self.backgroundColor = [UIColor clearColor];
        
        UIImage *image = [UIImage imageNamed:@"pad_card_item_null"];
        self.noneImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - image.size.width)/2.0, (self.frame.size.height - image.size.height)/2.0 - 60.0, image.size.width, image.size.height)];
        self.noneImageView.image = image;
        self.noneImageView.backgroundColor = [UIColor clearColor];
        self.noneImageView.hidden = YES;
        [self addSubview:self.noneImageView];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setItemSize:CGSizeMake(kPadProjectCollectionCellWidth, kPadProjectCollectionCellHeight)];
        [layout setHeaderReferenceSize:CGSizeMake(kPadProjectCollectionCellWidth, 76.0)];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout.sectionInset = UIEdgeInsetsMake(16.0, 14.5, 13.0, 14.5);
        layout.minimumLineSpacing = 13.0;
        layout.minimumInteritemSpacing = 0.0;
        
        self.projectCollectionView = [[PadProjectCollectionView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height) collectionViewLayout:layout];
        self.projectCollectionView.backgroundColor = [UIColor clearColor];
        self.projectCollectionView.dataSource = self;
        self.projectCollectionView.delegate = self;
        self.projectCollectionView.isProjectCanMove = NO;
        self.projectCollectionView.alwaysBounceVertical = YES;
        self.projectCollectionView.showsVerticalScrollIndicator = NO;
        self.projectCollectionView.showsHorizontalScrollIndicator = NO;
        [self.projectCollectionView registerClass:[PadProjectCollectionCell class] forCellWithReuseIdentifier:PadProjectCollectionCellIdentifier];
        [self.projectCollectionView registerClass:[PadProjectCollectionAddCell class] forCellWithReuseIdentifier:PadProjectCollectionAddCellIdentifier];
        [self.projectCollectionView registerClass:[PadProjectHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:PadProjectCollectionHeaderIdentifier];
        [self addSubview:self.projectCollectionView];
        self.projectCollectionView.contentOffset = CGPointMake(0.0, 0.0);
        
        MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(sendReqeust)];
        refreshHeader.lastUpdatedTimeLabel.hidden = true;
        refreshHeader.stateLabel.textColor = COLOR(136.0, 132.0, 124.0, 1.0);
        refreshHeader.arrowView.image = [UIImage imageNamed:@"arrow_refresh.png"];
        [refreshHeader setTitle:@"下拉可以刷新" forState:MJRefreshStateIdle];
        [refreshHeader setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
        [refreshHeader setTitle:@"数据刷新中..." forState:MJRefreshStateRefreshing];
        self.projectCollectionView.mj_header = refreshHeader;
        
        [self registerNofitificationForMainThread:@"ProjectItemUpdateAvailableResponse"];
    }
    
    return self;
}

- (void)sendReqeust
{
    NSMutableArray *fetchProductIDs = [[NSMutableArray alloc] init];
    for (CDProjectItem *item in self.data.projectArray) {
        if ([item.bornCategory integerValue] == kPadBornCategoryProduct)
        {
            [fetchProductIDs addObject:item.itemID];
        }
    }
    BSProjectItemUpdateAvailableRequest *request = [[BSProjectItemUpdateAvailableRequest alloc] init];
    request.fetchProductIDs = fetchProductIDs;
    [request execute];
}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:@"ProjectItemUpdateAvailableResponse"])
    {
        [self.projectCollectionView.mj_header endRefreshingWithCompletionBlock:^{
            [self.projectCollectionView reloadData];
        }];
    }
}

#pragma mark -
#pragma mark Public Methods

- (void)reloadProjectViewWithData:(PadProjectData *)data
{
    self.data = data;
    [self.data reloadPosOperate];
    if (self.data.isCardItem && self.data.cardItems.count == 0)
    {
        self.noneImageView.hidden = NO;
        self.projectCollectionView.hidden = YES;
    }
    else
    {
        self.noneImageView.hidden = YES;
        self.projectCollectionView.hidden = NO;
        [self.projectCollectionView reloadData];
    }
}


#pragma mark -
#pragma mark PadProjectCollectionViewDataSource Methods

- (NSInteger)collectionView:(PadProjectCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.data.isCardItem)
    {
        return self.data.cardItems.count;
    }
    else if (!self.data.isSearch && self.data.bornCategory.code.integerValue == kPadBornFreeCombination)
    {
        return self.data.projectArray.count + 1;
    }
    else
    {
        return self.data.projectArray.count;
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(PadProjectCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.data.isCardItem && !self.data.isSearch && self.data.bornCategory.code.integerValue == kPadBornFreeCombination)
    {
        if (indexPath.row == 0)
        {
            PadProjectCollectionAddCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PadProjectCollectionAddCellIdentifier forIndexPath:indexPath];
            return cell;
        }
    }
    
    PadProjectCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PadProjectCollectionCellIdentifier forIndexPath:indexPath];
    
    NSManagedObject *managedObject = nil;
    if (self.data.isCardItem)
    {
        managedObject = [self.data.cardItems objectAtIndex:indexPath.row];
    }
    else if (!self.data.isSearch && self.data.bornCategory.code.integerValue == kPadBornFreeCombination)
    {
        managedObject = [self.data.projectArray objectAtIndex:indexPath.row - 1];
    }
    else
    {
        managedObject = [self.data.projectArray objectAtIndex:indexPath.row];
    }
    
    if ([managedObject isKindOfClass:[CDProjectItem class]])
    {
        CDProjectItem *item = (CDProjectItem *)managedObject;
        [cell setTipsText:nil];
        cell.imageLabel.hidden = NO;
        cell.imageLabel.text = @"";
        if ( item.project_group_name.length > 0 )
        {
            if ( item.project_group_name.length >= 2 )
            {
                cell.imageLabel.text = [item.project_group_name substringToIndex:2];
            }
            else
            {
                cell.imageLabel.text = item.project_group_name;
            }
        }
        else
        {
            if (item.itemName.length >= 2)
            {
                cell.imageLabel.text = [item.itemName substringToIndex:2];
            }
            else
            {
                cell.imageLabel.text = item.itemName;
            }
        }
        
        if (item.bornCategory.integerValue == kPadBornCategoryProduct)
        {
            if (item.inHandAmount.integerValue == 0)
            {
                [cell setTipsText:LS(@"PadItemNonStocked")];
            }
            else if (item.inHandAmount.integerValue > 0)
            {
                [cell setTipsText:[NSString stringWithFormat:LS(@"PadItemInStock"), item.inHandAmount.integerValue]];
            }
        }
        
        cell.priceLabel.text = [NSString stringWithFormat:LS(@"PadPriceInfo"), item.totalPrice.floatValue];
        cell.internalNoLabel.text = @"";
        if (self.data.isDefaultCode && item.defaultCode.length != 0 && ![item.defaultCode isEqualToString:@"0"])
        {
            cell.internalNoLabel.text = [NSString stringWithFormat:LS(@"PadInternalInfo"), item.defaultCode];
        }
        
        if ( item.project_group_name.length > 0 )
        {
            cell.titleLabel.text = item.project_group_name;
            cell.imageView.hidden = YES;
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:item.product_group_image_url] placeholderImage:[UIImage imageNamed:@"pad_project_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {
                 if (image)
                 {
                     cell.imageView.hidden = NO;
                     cell.imageLabel.hidden = YES;
                 }
             }];
            cell.priceLabel.text = @"";
        }
        else
        {
            cell.titleLabel.text = item.itemName;
            cell.imageView.hidden = YES;
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:item.imageSmallUrl] placeholderImage:[UIImage imageNamed:@"pad_project_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {
                 if (image)
                 {
                     cell.imageView.hidden = NO;
                     cell.imageLabel.hidden = YES;
                 }
             }];
        }
    }
    else if ([managedObject isKindOfClass:[PadProjectCart class]])
    {
        PadProjectCart *cart = (PadProjectCart *)managedObject;
        [cell setTipsText:LS(@"PadCardItemTipsText")];
        cell.imageLabel.hidden = NO;
        cell.imageLabel.text = @"";
        cell.imageLabel.hidden = NO;
        cell.imageLabel.text = @"";
        if (cart.item.itemName.length >= 2)
        {
            cell.imageLabel.text = [cart.item.itemName substringToIndex:2];
        }
        if (cart.item.defaultCode.length != 0 && ![cart.item.defaultCode isEqualToString:@"0"])
        {
            cell.internalNoLabel.text = [NSString stringWithFormat:LS(@"PadInternalInfo"), cart.item.defaultCode];
        }
        else
        {
            cell.internalNoLabel.text = @"";
        }
        cell.titleLabel.text = cart.item.itemName;
        if (cart.localCount != 0)
        {
            cell.priceLabel.text = [NSString stringWithFormat:LS(@"PadQuantityInfo"), cart.localCount, cart.item.uomName];
        }
        else
        {
            cell.priceLabel.text = [NSString stringWithFormat:LS(@"PadPriceInfo"), cart.item.totalPrice.floatValue];
        }
        cell.imageView.hidden = YES;
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:cart.item.imageSmallUrl] placeholderImage:[UIImage imageNamed:@"pad_project_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             if (image)
             {
                 cell.imageView.hidden = NO;
                 cell.imageLabel.hidden = YES;
             }
         }];
    }
    else if ([managedObject isKindOfClass:[CDMemberCardProject class]])
    {
        CDMemberCardProject *project = (CDMemberCardProject *)managedObject;
        [cell setTipsText:nil];
        cell.imageLabel.hidden = NO;
        cell.imageLabel.text = @"";
        if (project.item.itemName.length >= 2)
        {
            cell.imageLabel.text = [project.item.itemName substringToIndex:2];
        }
        if (project.defaultCode.length != 0 && ![project.defaultCode isEqualToString:@"0"])
        {
            cell.internalNoLabel.text = [NSString stringWithFormat:LS(@"PadInternalInfo"), project.defaultCode];
        }
        else
        {
            cell.internalNoLabel.text = @"";
        }
        cell.titleLabel.text = project.item.itemName;
        if (project.localCount.integerValue != 0)
        {
            cell.priceLabel.text = [NSString stringWithFormat:LS(@"PadQuantityInfo"), project.localCount.integerValue, project.uomName];
        }
        else
        {
            cell.priceLabel.text = [NSString stringWithFormat:LS(@"PadPriceInfo"), project.item.totalPrice.floatValue];
        }
        cell.imageView.hidden = YES;
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:project.item.imageSmallUrl] placeholderImage:[UIImage imageNamed:@"pad_project_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             if (image)
             {
                 cell.imageView.hidden = NO;
                 cell.imageLabel.hidden = YES;
             }
         }];
    }
    else if ([managedObject isKindOfClass:[CDCouponCardProduct class]])
    {
        CDCouponCardProduct *project = (CDCouponCardProduct *)managedObject;
        CDProjectItem *item = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:project.productID forKey:@"itemID"];
        [cell setTipsText:nil];
        cell.imageLabel.hidden = NO;
        cell.imageLabel.text = @"";
        if (project.item.imageName.length >= 2)
        {
            cell.imageLabel.text = [project.item.imageName substringToIndex:2];
        }
        if (item.defaultCode.length != 0 && ![item.defaultCode isEqualToString:@"0"])
        {
            cell.internalNoLabel.text = [NSString stringWithFormat:LS(@"PadInternalInfo"), item.defaultCode];
        }
        else
        {
            cell.internalNoLabel.text = @"";
        }
        cell.titleLabel.text = project.item.itemName;
        if (project.localCount.integerValue != 0)
        {
            cell.priceLabel.text = [NSString stringWithFormat:LS(@"PadQuantityInfo"), project.localCount.integerValue, item.uomName];
        }
        else
        {
            cell.priceLabel.text = [NSString stringWithFormat:LS(@"PadPriceInfo"), project.item.totalPrice.floatValue];
        }
        cell.imageView.hidden = YES;
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:item.imageSmallUrl] placeholderImage:[UIImage imageNamed:@"pad_project_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
        {
            if (image)
            {
                cell.imageView.hidden = NO;
                cell.imageLabel.hidden = YES;
            }
        }];
    }
    
    return cell;
}

- (PadProjectHeaderView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        self.headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:PadProjectCollectionHeaderIdentifier forIndexPath:indexPath];
        self.headerView.searchBar.text = self.data.keyword;
        self.headerView.searchBar.placeholder = LS(@"SearchPlaceholderProject");
        self.headerView.delegate = (id<PadProjectHeaderViewDelegate>)self.delegate;
        
        return self.headerView;
    }
    
    return nil;
}


#pragma mark -
#pragma mark PadProjectCollectionViewDelegate Methods

- (void)collectionView:(PadProjectCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    NSManagedObject *managedObject = nil;
    if (self.data.isCardItem)
    {
        managedObject = [self.data.cardItems objectAtIndex:indexPath.row];
    }
    else if (!self.data.isSearch && self.data.bornCategory.code.integerValue == kPadBornFreeCombination)
    {
        if (indexPath.row == 0)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didPadFreeCombinationCreate)])
            {
                [self.delegate didPadFreeCombinationCreate];
            }
            return;
        }
        managedObject = [self.data.projectArray objectAtIndex:indexPath.row - 1];
    }
    else
    {
        managedObject = [self.data.projectArray objectAtIndex:indexPath.row];
        if ( collectionView && [managedObject isKindOfClass:[CDProjectItem class]] )
        {
            CDProjectItem* item = (CDProjectItem*)managedObject;
            if ( item.project_group_name.length > 0 )
            {
                NSArray* itemArray = [[BSCoreDataManager currentManager] fetchProjectItemsWithGroup:item.project_group_name];
                if ( itemArray.count > 0 )
                {
                    PadProjectGroupView* v = [PadProjectGroupView loadFromNib];
                    [[UIApplication sharedApplication].keyWindow addSubview:v];
                    v.itemArray = itemArray;
                    WeakSelf;
 
                    v.selectItem = ^(CDProjectItem *item) {
                        PadProjectCollectionCell *cell = (PadProjectCollectionCell *)[self.projectCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
                        CGRect rect = [weakSelf.projectCollectionView convertRect:cell.frame toView:weakSelf.superview];
                        UIView *snapshot = [weakSelf.projectCollectionView snapshotAtIndexPath:indexPath];
                        snapshot.frame = rect;
                        [weakSelf.superview addSubview:snapshot];
                        [UIView animateWithDuration:0.4 animations:^{
                            snapshot.frame = CGRectMake(1024.0 - 300.0 + 24.0 + 25.0, 75/2.0, 0.0, 0.0);
                        } completion:^(BOOL finished) {
                            [snapshot removeFromSuperview];
                        }];
                        
                        [weakSelf.delegate didPadProjectViewItemClick:item];
                    };
                    [v show];
                    return;
                }
            }
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPadProjectViewItemClick:)])
    {
        PadProjectCollectionCell *cell = (PadProjectCollectionCell *)[self.projectCollectionView cellForItemAtIndexPath:indexPath];
        CGRect rect = [self.projectCollectionView convertRect:cell.frame toView:self.superview];
        UIView *snapshot = [self.projectCollectionView snapshotAtIndexPath:indexPath];
        snapshot.frame = rect;
        [self.superview addSubview:snapshot];
        [UIView animateWithDuration:0.4 animations:^{
            snapshot.frame = CGRectMake(1024.0 - 300.0 + 24.0 + 25.0, 75/2.0, 0.0, 0.0);
        } completion:^(BOOL finished) {
            [snapshot removeFromSuperview];
        }];
        
        [self.delegate didPadProjectViewItemClick:managedObject];
    }
}

- (NSIndexPath *)collectionView:(PadProjectCollectionView *)collectionView targetIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    return toIndexPath;
}

- (void)collectionView:(PadProjectCollectionView *)collectionView willMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    ;
}

- (void)collectionView:(PadProjectCollectionView *)collectionView didMoveItemFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    ;
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < -160.0)
    {
        if (self.headerView.searchBar && !self.headerView.searchBar.isFirstResponder)
        {
            [self.headerView.searchBar becomeFirstResponder];
        }
    }
}

@end
