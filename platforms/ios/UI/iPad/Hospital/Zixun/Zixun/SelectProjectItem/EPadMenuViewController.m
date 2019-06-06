//
//  EPadMenuViewController.m
//  meim
//
//  Created by jimmy on 2018/3/20.
//

#import "EPadMenuViewController.h"
#import "UIImage+Resizable.h"
#import "PadCategoryViewController.h"
#import "BSPopoverBackgroundView.h"
#import "PadProjectData.h"
#import "PadProjectNaviView.h"
#import "PadProjectView.h"
#import "EPadDetailViewController.h"
#import "FetchEMenuRecommendRequest.h"
#import "EMenuCollectionViewHorizontalLayout.h"

@interface EPadMenuViewController ()<UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) PadProjectNaviView *naviBar;
@property (nonatomic, strong) PadProjectView *projectView;
@property(nonatomic, strong)IBOutlet UIButton *confirmButton;
@property(nonatomic, strong)IBOutlet UIView *searchView;
@property(nonatomic, strong)IBOutlet UILabel *categoryLabel;
@property(nonatomic, strong)  UISearchBar *searchBar;
@property (nonatomic, strong) UIPopoverController *typePopover;
@property (nonatomic, strong) PadCategoryViewController *typeViewController;
@property (nonatomic, strong) PadProjectData *data;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *selectedItemIDArray;
@property (nonatomic, strong) NSMutableArray *selectedNameIDArray;
@property (nonatomic, strong) NSMutableArray *finalItemArray;
@property (nonatomic, strong) NSMutableArray *recItemArray;
@property (nonatomic, strong) NSMutableArray *historyArray;
@property (nonatomic, strong) NSMutableArray *historyIDArray;
@property (nonatomic, strong) NSMutableArray *buyItemIDArray;
@property (nonatomic, strong) NSMutableArray *buyItemNameArray;
@property (nonatomic, strong) NSMutableArray *useItemIDArray;
@property (nonatomic, strong) NSMutableArray *useItemNameArray;
@property (nonatomic, assign) int sections;
@end

@implementation EPadMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initSearchBar];
    
    self.data = [[PadProjectData alloc] init];
    self.data.operateType = kPadProjectPosOperateCreate;
    self.data.posOperate = [[BSCoreDataManager currentManager] insertEntity:@"CDPosOperate"];
    [self.data reloadProjectItem];
    
    self.typeViewController = [[PadCategoryViewController alloc] initWithBornCategory:nil];
    self.typeViewController.delegate = self;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:self.typeViewController];
    navi.navigationBarHidden = YES;
    self.typePopover = [[UIPopoverController alloc] initWithContentViewController:navi];
    self.typePopover.backgroundColor = [UIColor whiteColor];
    self.typePopover.popoverBackgroundViewClass = [BSPopoverBackgroundView class];
    
    EMenuCollectionViewHorizontalLayout *layout = [[EMenuCollectionViewHorizontalLayout alloc] init];
    layout.rowCount = 2;
    layout.itemCountPerRow = 3;
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [layout setItemSize:CGSizeMake(308, 297)];
    [layout setHeaderReferenceSize:CGSizeMake(0, 0)];
    [layout setFooterReferenceSize:CGSizeMake(53, 0)];
    [layout setMinimumInteritemSpacing:0];
    [layout setMinimumLineSpacing:0];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(53.0, 147.0, 971.0, 594.0) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    self.selectedItemIDArray = [[NSMutableArray alloc] init];
    self.selectedNameIDArray = [[NSMutableArray alloc] init];
    self.categoryLabel.adjustsFontSizeToFitWidth = YES;
    
    self.finalItemArray = [[NSMutableArray alloc] init];//WithArray:self.data.projectArray];
    self.recItemArray = [[NSMutableArray alloc] init];
    self.historyArray = [[NSMutableArray alloc] init];
    self.historyIDArray = [[NSMutableArray alloc] init];
    self.buyItemIDArray = [[NSMutableArray alloc] init];
    self.buyItemNameArray = [[NSMutableArray alloc] init];
    self.useItemIDArray = [[NSMutableArray alloc] init];
    self.useItemNameArray = [[NSMutableArray alloc] init];
    FetchEMenuRecommendRequest *request = [[FetchEMenuRecommendRequest alloc] init];
    [request execute];
    [self registerNofitificationForMainThread:@"EMenuRecFetchResponse"];
    if ([self.fromView isEqualToString:@"Home"]) {
        [self.confirmButton setTitle:@"退出" forState:UIControlStateNormal];
    }
}

- (BOOL)prefersStatusBarHidden{
        return YES;
}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:@"EMenuRecFetchResponse"])
    {
        NSLog(@"%d",self.finalItemArray.count);
        NSArray *resultArray = [notification.userInfo objectForKey:@"data"];
        for (NSDictionary *dict in resultArray)
        {
            NSLog(@"%@",dict);
            [self.recItemArray addObject:dict];
            NSArray *imageOrVideoArray = [dict objectForKey:@"main_image_ids"];
            bool isExisted = NO;
            for (NSDictionary *imgDict in imageOrVideoArray) {
                if (!isExisted)
                {
                    [self.finalItemArray addObject:[imgDict objectForKey:@"image_url"]];
                    isExisted = YES;
                }
            }
        }
        [self reloadCollectionView];
    }
}

- (void)refreshLayout
{
    [self.collectionView removeFromSuperview];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setItemSize:CGSizeMake(308, 2997)];
    [layout setHeaderReferenceSize:CGSizeMake(0, 0)];
    [layout setFooterReferenceSize:CGSizeMake(53, 0)];
    [layout setMinimumInteritemSpacing:0];
    [layout setMinimumLineSpacing:0];
    if (self.finalItemArray.count < 6)
    {
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    }
    else
    {
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    }
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(53.0, 147.0, 971.0, 612.0) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
}

- (void)initSearchBar
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(96.0, 0.0, 388.0, 36.0)];
    [self.searchBar setSearchFieldBackgroundImage:[[UIImage imageNamed:@"pad_member_search_field"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12)] forState:UIControlStateNormal];
    UIImage* searchBarBg = [self GetImageWithColor:[UIColor clearColor] andHeight:36.0f];
    [self.searchBar setBackgroundImage:searchBarBg];

    self.searchBar.contentMode = UIViewContentModeLeft;
    self.searchBar.returnKeyType = UIReturnKeySearch;
    self.searchBar.delegate = self;
    self.searchBar.clipsToBounds = YES;
    [self.searchView addSubview:self.searchBar];
}

- (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (IBAction)confirm:(id)sender
{
//    [self.selectedNameIDArray removeAllObjects];
//    for (NSNumber *itemId in self.selectedItemIDArray)
//    {
//        for (NSDictionary *item in self.recItemArray) {
//            if ([[item objectForKey:@"id"] intValue] == [itemId intValue])
//            {
//                if (![self.selectedNameIDArray containsObject:[item objectForKey:@"name"]])
//                {
//                    [self.selectedNameIDArray addObject:[item objectForKey:@"name"]];
//                }
//            }
//        }
//    }
    
    NSNumber* zixunID = self.zixunID;
    if ( zixunID == nil )
    {
        zixunID = @(0);
    }
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:self.selectedItemIDArray,@"ID",self.selectedNameIDArray,@"Name",self.historyArray,@"History",self.historyIDArray,@"HistoryID",self.buyItemIDArray,@"BuyID",self.useItemIDArray,@"UseID",self.buyItemNameArray,@"BuyName",self.useItemNameArray,@"UseName",zixunID,@"zixunID",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EPadSelectFinished" object:nil userInfo:dict];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didCategoryButtonClick:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    UIButton *button = (UIButton *)sender;
    UIView *parentView = button.superview;
    [self.typePopover presentPopoverFromRect:CGRectMake(parentView.frame.origin.x + button.frame.origin.x + button.frame.size.width/2.0, button.frame.origin.y + button.frame.size.height + 60, 0.0, 0.0) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:NO];
    
    if ( [PersonalProfile currentProfile].isYiMei.boolValue )
    {
        //[self performSelector:@selector(delayToShowNextNavi) withObject:nil afterDelay:0.5];
        //[self delayToShowNextNavi];
    }
}

#pragma mark -
#pragma mark PadCategoryViewControllerDelegate Methods

- (void)didPadCategoryBack
{
    [self.data setCurrentCategory:nil];
    [self.data reloadProjectItem];
    [self.naviBar reloadTitleWithData:self.data];
    [self.projectView reloadProjectViewWithData:self.data];
//    self.finalItemArray = [NSMutableArray arrayWithArray:self.data.projectArray];
    [self reloadCollectionView];
    NSLog(@"%d",self.data.projectArray.count);
}

- (void)didPadCategorySubTotalSelect
{
    self.data.isCardItem = NO;
    [self.data setCurrentCategory:nil];
    [self.data reloadProjectItem];
    [self.naviBar reloadTitleWithData:self.data];
    [self.projectView reloadProjectViewWithData:self.data];
    [self.typePopover dismissPopoverAnimated:YES];
    self.categoryLabel.text = @"全部分类";
//    self.finalItemArray = [NSMutableArray arrayWithArray:self.data.projectArray];
    for (CDProjectItem *item in self.recItemArray) {
        [self.finalItemArray insertObject:item atIndex:0];
    }
    [self reloadCollectionView];
    NSLog(@"%d",self.data.projectArray.count);
}

- (void)didPadCategoryCellSelect:(CDProjectCategory *)category
{
    self.data.isCardItem = NO;
    [self.data setCurrentCategory:category];
    [self.data reloadProjectItem];
    [self.naviBar reloadTitleWithData:self.data];
    [self.projectView reloadProjectViewWithData:self.data];
    if (self.data.currentCategory.subCategory.count == 0)
    {
        [self.typePopover dismissPopoverAnimated:YES];
    }
    self.categoryLabel.text = category.categoryName;
    self.finalItemArray = [NSMutableArray arrayWithArray:self.data.projectArray];
    [self reloadCollectionView];
    NSLog(@"%d",self.data.projectArray.count);
}

- (void)didPadCategorySubOtherSelect
{
    self.data.isCardItem = NO;
    [self.data setCurrentCategory:nil];
    [self.data reloadOnlyParantProjectItem];
    [self.naviBar reloadTitleWithData:self.data];
    [self.projectView reloadProjectViewWithData:self.data];
    [self.typePopover dismissPopoverAnimated:YES];
    //self.categoryLabel.text = category.categoryName;
    self.finalItemArray = [NSMutableArray arrayWithArray:self.data.projectArray];
    [self reloadCollectionView];
    NSLog(@"%d",self.data.projectArray.count);
}

#pragma mark -
#pragma mark PadSubCategoryViewControllerDelegate Methods

- (void)didPadSubCategoryBack:(CDProjectCategory *)category
{
    [self.data setCurrentCategory:category];
    [self.data reloadProjectItem];
    [self.naviBar reloadTitleWithData:self.data];
    [self.projectView reloadProjectViewWithData:self.data];
    self.finalItemArray = [NSMutableArray arrayWithArray:self.data.projectArray];
    [self reloadCollectionView];
    NSLog(@"%d",self.data.projectArray.count);
}

- (void)didPadSubCategorySubTotalSelect:(CDProjectCategory *)category
{
    [self.data setCurrentCategory:category];
    [self.data reloadProjectItem];
    [self.naviBar reloadTitleWithData:self.data];
    [self.projectView reloadProjectViewWithData:self.data];
    [self.typePopover dismissPopoverAnimated:YES];
    self.finalItemArray = [NSMutableArray arrayWithArray:self.data.projectArray];
    [self reloadCollectionView];
    NSLog(@"%d",self.data.projectArray.count);
}

- (void)didPadSubCategoryCellSelect:(CDProjectCategory *)category
{
    self.data.isCardItem = NO;
    [self.data setCurrentCategory:category];
    [self.data reloadProjectItem];
    [self.naviBar reloadTitleWithData:self.data];
    [self.projectView reloadProjectViewWithData:self.data];
    if (self.data.currentCategory.subCategory.count == 0)
    {
        [self.typePopover dismissPopoverAnimated:YES];
    }
    self.categoryLabel.text = category.categoryName;
    self.finalItemArray = [NSMutableArray arrayWithArray:self.data.projectArray];
    [self reloadCollectionView];
    NSLog(@"%d",self.data.projectArray.count);
}

- (void)didPadSubCategorySubOtherSelect:(CDProjectCategory *)category
{
    self.data.isCardItem = NO;
    [self.data setCurrentCategory:category];
    [self.data reloadOnlyParantProjectItem];
    [self.naviBar reloadTitleWithData:self.data];
    [self.projectView reloadProjectViewWithData:self.data];
    [self.typePopover dismissPopoverAnimated:YES];
    self.categoryLabel.text = category.categoryName;
    self.finalItemArray = [NSMutableArray arrayWithArray:self.data.projectArray];
    [self reloadCollectionView];
    NSLog(@"%d",self.data.projectArray.count);
}

- (void)reloadCollectionView
{
    //[self refreshLayout];
    [self reloadCollectionViewWithoutRefresh];
    //[self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

- (void)reloadCollectionViewWithoutRefresh
{
    if ([self.fromView isEqualToString:@"Home"]) {
        [self.confirmButton setTitle:@"退出" forState:UIControlStateNormal];
        [self.collectionView reloadData];
        return;
    }
    
    if (self.selectedItemIDArray.count == 0)
    {
        [self.confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    }
    else
    {
        [self.confirmButton setTitle:[NSString stringWithFormat:@"确认（%d）", self.selectedItemIDArray.count] forState:UIControlStateNormal];
    }
    [self.collectionView reloadData];
}

#pragma mark -
#pragma mark CollectionView Delegate and DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    self.sections = (int)ceil(self.finalItemArray.count/6.0);
    return self.sections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    if (section == self.sections - 1)
//    {
//        return self.finalItemArray.count%self.sections;
//    }
//    else
//    {
        return 6;
//    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){308,297};
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section*6+indexPath.row >= self.finalItemArray.count)
    {
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"EPadDetailCellEmpty"];
        UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"EPadDetailCellEmpty" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    else
    {
//        CDProjectItem *item = [self.finalItemArray objectAtIndex:indexPath.section*6+indexPath.row];
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:[NSString stringWithFormat:@"EPadDetailCell%d",indexPath.section*6+indexPath.row]];
        UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithFormat:@"EPadDetailCell%d",indexPath.section*6+indexPath.row] forIndexPath:indexPath];
        //CGFloat num = 255/self.finalItemArray.count;
        cell.backgroundColor = [UIColor whiteColor];//COLOR(242, 245, 245, 1);
//        NSLog(@"%@",item);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 308.0, 231.0)];
//        imageView.backgroundColor = [UIColor redColor];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.finalItemArray[indexPath.section*6+indexPath.row]] placeholderImage:[UIImage imageNamed:@"pad_project_background_h"] completed:nil];
        imageView.contentMode = UIViewContentModeScaleToFill;
        [cell addSubview:imageView];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 231.0, 280.0, 60.0)];
        nameLabel.backgroundColor = [UIColor whiteColor];
        nameLabel.text = [self.recItemArray[indexPath.section*6+indexPath.row] objectForKey:@"name"];
        nameLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        [cell addSubview:nameLabel];
        UIButton *selectButton = [[UIButton alloc] initWithFrame:CGRectMake(261.0, 0.0, 45.0, 45.0)];
//        selectButton.tag = [item.itemID intValue];
//        if ([self.selectedItemIDArray containsObject:item.itemID])
//        {
//            [selectButton setImage:[UIImage imageNamed:@"pad_emenu_select"] forState:UIControlStateNormal];
//            cell.layer.borderWidth = 2;
//        }
//        else
//        {
//            [selectButton setImage:[UIImage imageNamed:@"pad_emenu_unselect"] forState:UIControlStateNormal];
//            cell.layer.borderWidth = 0;
//        }
//        cell.layer.borderColor = COLOR(153, 194, 64, 1).CGColor;
//        [selectButton addTarget:self action:@selector(didSelectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        //[cell addSubview:selectButton];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section*6+indexPath.row >= self.finalItemArray.count)
    {
        return;
    }
    EPadDetailViewController *detail = [[EPadDetailViewController alloc] init];
    detail.item = [self.recItemArray objectAtIndex:indexPath.section*6+indexPath.row];
    detail.memberCard = self.memberCard;
    detail.fromView = self.fromView;
    if (![self.historyArray containsObject:[[self.recItemArray objectAtIndex:indexPath.section*6+indexPath.row] objectForKey:@"name"]])
    {
        [self.historyArray addObject:[[self.recItemArray objectAtIndex:indexPath.section*6+indexPath.row] objectForKey:@"name"]];
        [self.historyIDArray addObject:[[self.recItemArray objectAtIndex:indexPath.section*6+indexPath.row] objectForKey:@"id"]];

    }
    [self.navigationController pushViewController:detail animated:NO];
}

- (void)didBuyItemSelected:(NSNumber *)number andName:(NSString *)name
{
    if ([self.alreadySelectIDArray containsObject:number])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您已选购该产品" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        [self.alreadySelectIDArray addObject:number];
        [self.buyItemIDArray addObject:number];
        [self.buyItemNameArray addObject:name];
        [self didItemSelected:number andName:name];
    }
}

- (void)didUseItemSelected:(NSNumber *)number andName:(NSString *)name
{
    if ([self.alreadySelectIDArray containsObject:number])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您已选购该产品" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        [self.alreadySelectIDArray addObject:number];
        [self.useItemIDArray addObject:number];
        [self.useItemNameArray addObject:name];
        [self didItemSelected:number andName:name];
    }
}

- (void)didItemSelected:(NSNumber *)number andName:(NSString *)name
{
    [self.selectedItemIDArray addObject:number];
    [self.selectedNameIDArray addObject:name];
    [self reloadCollectionViewWithoutRefresh];
}

- (void)didSelectButtonClicked:(UIButton *)button
{
    NSNumber *num = [NSNumber numberWithInt:button.tag];
    if ([self.selectedItemIDArray containsObject:num])
    {
        [self.selectedItemIDArray removeObject:num];
    }
    else
    {
        [self.selectedItemIDArray addObject:num];
    }
    [self reloadCollectionViewWithoutRefresh];
}

- (void)didProjectItemSearchBarSearch:(NSString *)keyword
{
//    if (keyword.length == 0)
//    {
//        [self.projectView reloadProjectViewWithData:self.data];
//        [self reloadCollectionView];
//        return;
//    }
    [self.data reloadProjectItemWithKeyword:keyword];
    [self.naviBar reloadTitleWithData:self.data];
    [self.projectView reloadProjectViewWithData:self.data];
    self.finalItemArray = [NSMutableArray arrayWithArray:self.data.projectArray];
    if (keyword.length == 0) {
        for (CDProjectItem *item in self.recItemArray) {
            [self.finalItemArray insertObject:item atIndex:0];
        }
    }
    [self reloadCollectionView];
}

#pragma mark -
#pragma mark UISearchBarDelegate Methods

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(didProjectItemSearchBarBeginEditing)])
//    {
//        [self.delegate didProjectItemSearchBarBeginEditing];
//    }
//
//    [UIView animateWithDuration:0.24 animations:^{
//        self.searchBar.frame = CGRectMake(self.searchBar.frame.origin.x, self.searchBar.frame.origin.y, self.frame.size.width - 32.0 - 72.0, self.searchBar.frame.size.height);
//        self.cancelButton.frame = CGRectMake(self.frame.size.width - 72.0, self.cancelButton.frame.origin.y, self.cancelButton.frame.size.width, self.cancelButton.frame.size.height);
//    } completion:^(BOOL finished) {
//        ;
//    }];
    
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(didProjectItemSearchBarSearch:)])
//    {
        [self didProjectItemSearchBarSearch:searchBar.text];
//    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(didProjectItemSearchBarSearch:)])
//    {
        [self didProjectItemSearchBarSearch:searchBar.text];
//    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self didProjectItemSearchBarSearch:searchBar.text];

    //    if (self.delegate && [self.delegate respondsToSelector:@selector(didProjectItemSearchBarTextChanged:)])
    //    {
    //        [self.delegate didProjectItemSearchBarTextChanged:searchBar.text];
    //    }
}
@end
