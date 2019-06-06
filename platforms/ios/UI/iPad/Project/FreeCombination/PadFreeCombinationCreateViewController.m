//
//  PadFreeCombinationCreateViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/10/27.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadFreeCombinationCreateViewController.h"
#import "PadProjectData.h"
#import "PadProjectCell.h"
#import "PadProjectSideCell.h"
#import "BSPopoverBackgroundView.h"
#import "PadFreeCombinationConfirmViewController.h"

@interface PadFreeCombinationCreateViewController ()

@property (nonatomic, strong) UIButton *titleButton;
@property (nonatomic, strong) UITableView *projectTableView;
@property (nonatomic, strong) UITableView *itemTableView;
@property (nonatomic, strong) UIButton *createButton;
@property (nonatomic, strong) UIPopoverController *typePopover;
@property (nonatomic, strong) PadProjectTypeViewController *typeViewController;

@property (nonatomic, strong) PadProjectData *data;
@property (nonatomic, strong) NSMutableOrderedSet *products;
@property (nonatomic, assign) CGFloat totalAmount;

@end

@implementation PadFreeCombinationCreateViewController

- (id)init
{
    self = [super initWithNibName:@"PadFreeCombinationCreateViewController" bundle:nil];
    if (self)
    {
        self.data = [[PadProjectData alloc] init];
        [self.data reloadProjectItem];
        self.products = [NSMutableOrderedSet orderedSet];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.noKeyboardNotification = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0.0, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
    
    UIView *leftBackground = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width - kPadProjectSideViewWidth, IC_SCREEN_HEIGHT)];
    leftBackground.backgroundColor = COLOR(242.0, 245.0, 245.0, 1.0);
    [self.view addSubview:leftBackground];
    
    self.projectTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, kPadNaviHeight, self.view.frame.size.width - kPadProjectSideViewWidth, self.view.frame.size.height - kPadNaviHeight) style:UITableViewStylePlain];
    self.projectTableView.backgroundColor = [UIColor clearColor];
    self.projectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.projectTableView.dataSource = self;
    self.projectTableView.delegate = self;
    self.projectTableView.showsVerticalScrollIndicator = NO;
    self.projectTableView.showsHorizontalScrollIndicator = NO;
    self.projectTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.projectTableView];
    
    self.itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - kPadProjectSideViewWidth, kPadNaviHeight, kPadProjectSideViewWidth, self.view.frame.size.height - kPadNaviHeight - kPadConfirmButtonHeight) style:UITableViewStylePlain];
    self.itemTableView.backgroundColor = [UIColor whiteColor];
    self.itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.itemTableView.dataSource = self;
    self.itemTableView.delegate = self;
    self.itemTableView.showsVerticalScrollIndicator = NO;
    self.itemTableView.showsHorizontalScrollIndicator = NO;
    self.itemTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view  addSubview:self.itemTableView];
    
    self.createButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - kPadProjectSideViewWidth, self.view.frame.size.height - kPadConfirmButtonHeight, kPadProjectSideViewWidth, kPadConfirmButtonHeight)];
    self.createButton.backgroundColor = [UIColor clearColor];
    [self.createButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_n"] forState:UIControlStateNormal];
    [self.createButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_h"] forState:UIControlStateHighlighted];
    [self.createButton addTarget:self action:@selector(didCreateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.createButton];
    
    UILabel *createLabel = [[UILabel alloc] initWithFrame:CGRectMake(32.0, (kPadConfirmButtonHeight - 20.0)/2.0, 64.0, 20.0)];
    createLabel.backgroundColor = [UIColor clearColor];
    createLabel.textColor = [UIColor whiteColor];
    createLabel.textAlignment = NSTextAlignmentLeft;
    createLabel.font = [UIFont boldSystemFontOfSize:17.0];
    createLabel.text = LS(@"PadCreateTitle");
    createLabel.tag = 101;
    [self.createButton addSubview:createLabel];
    
    UILabel *symbolLabel = [[UILabel alloc] initWithFrame:CGRectMake(24.0 + 64.0, (kPadConfirmButtonHeight - 20.0)/2.0 + 2.0, 12.0, 12.0)];
    symbolLabel.backgroundColor = [UIColor clearColor];
    symbolLabel.textColor = [UIColor whiteColor];
    symbolLabel.textAlignment = NSTextAlignmentLeft;
    symbolLabel.font = [UIFont systemFontOfSize:14.0];
    symbolLabel.text = LS(@"PadMoneySymbol");
    symbolLabel.tag = 102;
    [self.createButton addSubview:symbolLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(24.0 + 64.0, (kPadConfirmButtonHeight - 24.0)/2.0, kPadProjectSideViewWidth - 2 * 24.0 - 64.0, 24.0)];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.textColor = [UIColor whiteColor];
    priceLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.font = [UIFont systemFontOfSize:20.0];
    priceLabel.tag = 103;
    [self.createButton addSubview:priceLabel];
    
    UIImage *naviImage = [UIImage imageNamed:@"pad_navi_background"];
    UIImageView *navi = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, naviImage.size.height)];
    navi.backgroundColor = [UIColor clearColor];
    navi.image = naviImage;
    navi.userInteractionEnabled = YES;
    [self.view addSubview:navi];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.backgroundColor = [UIColor clearColor];
    closeButton.frame = CGRectMake(0.0, 0.0, kPadNaviHeight, kPadNaviHeight);
    [closeButton setBackgroundImage:[UIImage imageNamed:@"pad_navi_close_n"] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"pad_navi_close_h"] forState:UIControlStateHighlighted];
    [closeButton addTarget:self action:@selector(didCloseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navi addSubview:closeButton];
    
    self.titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.titleButton.frame = CGRectMake(0.0, 0.0, 64.0, kPadNaviHeight);
    self.titleButton.backgroundColor = [UIColor clearColor];
    [self.titleButton addTarget:self action:@selector(didNaviTitleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navi addSubview:self.titleButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, (kPadNaviHeight - 24.0)/2.0, 44.0, 24.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = COLOR(96.0, 212.0, 212.0, 1.0);
    titleLabel.textAlignment = NSTextAlignmentRight;
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    titleLabel.tag = 101;
    [self.titleButton addSubview:titleLabel];
    
    UIImage *titleImage = [UIImage imageNamed:@"pad_title_drop_down"];
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(44.0, (kPadNaviHeight - titleImage.size.height)/2.0, titleImage.size.width, titleImage.size.height)];
    titleImageView.backgroundColor = [UIColor clearColor];
    titleImageView.image = titleImage;
    titleImageView.tag = 102;
    [self.titleButton addSubview:titleImageView];
    
    //    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    addButton.backgroundColor = [UIColor clearColor];
    //    addButton.frame = CGRectMake(self.view.frame.size.width - kPadProjectSideViewWidth - kPadNaviHeight - 1.0, 0.0, kPadNaviHeight, kPadNaviHeight);
    //    [addButton setBackgroundImage:[UIImage imageNamed:@"pad_navi_add_n"] forState:UIControlStateNormal];
    //    [addButton setBackgroundImage:[UIImage imageNamed:@"pad_navi_add_h"] forState:UIControlStateHighlighted];
    //    [addButton addTarget:self action:@selector(didAddButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [navi addSubview:addButton];
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - kPadProjectSideViewWidth - 1.0, 0.0, 1.0, kPadNaviHeight)];
    lineImageView.backgroundColor = COLOR(216.0, 230.0, 230.0, 1.0);
    [navi addSubview:lineImageView];
    
    UILabel *itemsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - kPadProjectSideViewWidth, 0.0, kPadProjectSideViewWidth, kPadNaviHeight)];
    itemsLabel.backgroundColor = [UIColor clearColor];
    itemsLabel.textAlignment = NSTextAlignmentCenter;
    itemsLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    itemsLabel.font = [UIFont boldSystemFontOfSize:17.0];
    itemsLabel.text = LS(@"PadCustomItemsTitle");
    [navi addSubview:itemsLabel];
    
    NSArray *types = [[BSCoreDataManager currentManager] fetchAllBornCategory];
    self.typeViewController = [[PadProjectTypeViewController alloc] initWithTypes:types];
    self.typeViewController.delegate = self;
    UINavigationController *typeNavi = [[UINavigationController alloc] initWithRootViewController:self.typeViewController];
    typeNavi.navigationBarHidden = YES;
    self.typePopover = [[UIPopoverController alloc] initWithContentViewController:typeNavi];
    self.typePopover.backgroundColor = [UIColor whiteColor];
    self.typePopover.popoverBackgroundViewClass = [BSPopoverBackgroundView class];
    
//    self.typeViewController = [[PadProjectTypeViewController alloc] initWithTypes:types];
//    self.typeViewController.delegate = self;
//    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:self.typeViewController];
//    navi.navigationBarHidden = YES;
//    self.typePopover = [[UIPopoverController alloc] initWithContentViewController:navi];
//    self.typePopover.backgroundColor = [UIColor whiteColor];
//    self.typePopover.popoverBackgroundViewClass = [BSPopoverBackgroundView class];
    
    [self refreshCreateButton];
    [self reloadTitleWithData:self.data];
}


#pragma mark -
#pragma mark Required Methods

- (void)reloadTitleWithData:(PadProjectData *)data
{
    self.data = data;
    UILabel *titleLabel = (UILabel *)[self.titleButton viewWithTag:101];
    UIImageView *titleImageView = (UIImageView *)[self.titleButton viewWithTag:102];
    titleLabel.text = [NSString stringWithFormat:@"%@(%d)", self.data.bornCategory.bornCategoryName, self.data.bornCategory.totalCount.integerValue];
    
    CGSize minSize = [titleLabel.text sizeWithFont:titleLabel.font constrainedToSize:CGSizeMake(1024.0, titleLabel.frame.size.height) lineBreakMode:NSLineBreakByCharWrapping];
    titleLabel.frame = CGRectMake(12.0, titleLabel.frame.origin.y, minSize.width, titleLabel.frame.size.height);
    titleImageView.frame = CGRectMake(12.0 + titleLabel.frame.size.width + 12.0, titleImageView.frame.origin.y, titleImageView.frame.size.width, titleImageView.frame.size.height);
    self.titleButton.frame = CGRectMake((self.view.frame.size.width - kPadProjectSideViewWidth - minSize.width - titleImageView.frame.size.width - 3 * 12.0)/2.0 + 12.0, 0.0, minSize.width + titleImageView.frame.size.width + 3 * 12.0, kPadNaviHeight);
    self.titleButton.backgroundColor = [UIColor clearColor];
}

- (void)refreshCreateButton
{
    UILabel *symbolLabel = (UILabel *)[self.createButton viewWithTag:102];
    UILabel *priceLabel = (UILabel *)[self.createButton viewWithTag:103];
    
    priceLabel.text = [NSString stringWithFormat:@"%.2f", self.totalAmount];
    CGSize minSize = [priceLabel.text sizeWithFont:priceLabel.font constrainedToSize:CGSizeMake(1024.0, priceLabel.frame.size.height) lineBreakMode:NSLineBreakByCharWrapping];
    symbolLabel.frame = CGRectMake(kPadProjectSideViewWidth - 24.0 - minSize.width - 12.0, symbolLabel.frame.origin.y, symbolLabel.frame.size.width, symbolLabel.frame.size.height);
}

- (void)didCloseButtonClick:(id)sender
{
    [self.maskView hidden];
}

- (void)didNaviTitleButtonClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [self.typePopover presentPopoverFromRect:CGRectMake((self.view.frame.size.width - kPadProjectSideViewWidth)/2.0, button.frame.origin.y + button.frame.size.height, 0.0, 0.0) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:NO];
}

- (void)didCreateButtonClick:(id)sender
{
    PadFreeCombinationConfirmViewController *viewController = [[PadFreeCombinationConfirmViewController alloc] initWithProducts:self.products totalPrice:self.totalAmount];
    viewController.maskView = self.maskView;
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.projectTableView)
    {
        return self.data.projectArray.count;
    }
    else if (tableView == self.itemTableView)
    {
        return self.products.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.projectTableView)
    {
        return kPadCustomItemCellHeight;
    }
    else if (tableView == self.itemTableView)
    {
        return kPadProjectSideCellHeight;
    }
    
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.projectTableView)
    {
        static NSString *CellIdentifier = @"PadProjectCellIdentifier";
        PadProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[PadProjectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        CDProjectItem *item = [self.data.projectArray objectAtIndex:indexPath.row];
        cell.titleLabel.text = item.itemName;
        cell.priceLabel.text = [NSString stringWithFormat:LS(@"PadPriceInfo"), item.totalPrice.floatValue];
        
        return cell;
    }
    else if (tableView == self.itemTableView)
    {
        static NSString *CellIdentifier = @"PadProjectSideCellIdentifier";
        PadProjectSideCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[PadProjectSideCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        CDPosProduct *product = [self.products objectAtIndex:indexPath.row];
        cell.titleLabel.text = product.product_name;
        cell.numberLabel.text = [NSString stringWithFormat:LS(@"PadPosProductNum"), product.product_qty.integerValue];
        cell.priceLabel.text = [NSString stringWithFormat:@"%.2f", product.product_price.floatValue * product.product_qty.integerValue];
        
        return cell;
    }
    
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.itemTableView)
    {
        return YES;
    }
    
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.itemTableView)
    {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.products removeObjectAtIndex:indexPath.row];
        [self.itemTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        self.totalAmount = 0.0;
        for (CDPosProduct *product in self.products)
        {
            self.totalAmount += product.product_price.floatValue * product.product_qty.integerValue;
        }
        [self refreshCreateButton];
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.projectTableView)
    {
        CDProjectItem *item = [self.data.projectArray objectAtIndex:indexPath.row];
        if (item.bornCategory.integerValue == kPadBornCategoryProduct || item.bornCategory.integerValue == kPadBornCategoryProject)
        {
            [self didPosOperateAddProjectItem:item];
        }
        else if (item.bornCategory.integerValue == kPadBornCategoryCourses || item.bornCategory.integerValue == kPadBornCategoryPackage || item.bornCategory.integerValue == kPadBornCategoryPackageKit)
        {
            for (CDProjectItem *subItem in item.subItems)
            {
                [self didPosOperateAddProjectItem:subItem];
            }
        }
        [self.itemTableView reloadData];
        [self refreshCreateButton];
    }
    else if (tableView == self.itemTableView)
    {
        CDPosProduct *product = [self.products objectAtIndex:indexPath.row];
        PadProjectDetailViewController *viewController = [[PadProjectDetailViewController alloc] initWithPosProduct:product detailType:kPadProjectDetailFreeCombination];
        viewController.delegate = self;
        viewController.maskView = self.maskView;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)didPosOperateAddProjectItem:(CDProjectItem *)item
{
    BOOL isExist = NO;
    for (CDPosProduct *product in self.products)
    {
        if (product.product_id.integerValue == item.itemID.integerValue)
        {
            isExist = YES;
            product.product_qty = [NSNumber numberWithInteger:product.product_qty.integerValue + 1];
            product.money_total = [NSNumber numberWithFloat:product.product_qty.integerValue * product.product_price.floatValue];
            self.totalAmount += product.product_price.floatValue;
            [[BSCoreDataManager currentManager] save:nil];
            
            break;
        }
    }
    
    if (!isExist)
    {
        CDPosProduct *product = [[BSCoreDataManager currentManager] insertEntity:@"CDPosProduct"];
        product.product_id = item.itemID;
        product.product_name = item.itemName;
        product.lastUpdate = item.lastUpdate;
        product.defaultCode = item.defaultCode;
        product.category_id = item.categoryID;
        product.category_name = item.categoryName;
        product.product_price = item.totalPrice;
        product.product_qty = [NSNumber numberWithInteger:1];
        product.product_discount = [NSNumber numberWithFloat:10.0];
        product.imageUrl = item.imageUrl;
        product.imageSmallUrl = item.imageSmallUrl;
        product.money_total = [NSNumber numberWithFloat:product.product_price.floatValue * product.product_qty.floatValue];
        [self.products addObject:product];
        self.totalAmount += product.product_price.floatValue;
    }
}


#pragma mark -
#pragma mark PadProjectDetailViewControllerDelegate Methods

- (void)didPadPosProductDelete:(CDPosProduct *)product
{
    [self.products removeObject:product];
    self.totalAmount = 0.0;
    for (CDPosProduct *product in self.products)
    {
        self.totalAmount += product.product_price.floatValue * product.product_qty.integerValue;
    }
    [self.itemTableView reloadData];
    [self refreshCreateButton];
}

- (void)didPadPosProductConfirm:(CDPosProduct *)product
{
    self.totalAmount = 0.0;
    for (CDPosProduct *product in self.products)
    {
        self.totalAmount += product.product_price.floatValue * product.product_qty.integerValue;
    }
    [self.itemTableView reloadData];
    [self refreshCreateButton];
}


#pragma mark -
#pragma mark PadProjectTypeViewControllerDelegate Methods

- (void)didProjectViewSelectWithBornCategory:(CDBornCategory *)bornCategory hidden:(BOOL)hidden
{
    [self.data setCurrentCategory:nil];
    [self.data reloadProjectItemWithBornCategory:bornCategory];
    [self.projectTableView reloadData];
    [self reloadTitleWithData:self.data];
    if (hidden)
    {
        [self.typePopover dismissPopoverAnimated:YES];
    }
}


#pragma mark -
#pragma mark PadCategoryViewControllerDelegate Methods

- (void)didPadCategoryBack
{
    [self.data setCurrentCategory:nil];
    [self.data reloadProjectItem];
    [self.projectTableView reloadData];
    [self reloadTitleWithData:self.data];
}

- (void)didPadCategorySubTotalSelect
{
    [self.data setCurrentCategory:nil];
    [self.data reloadProjectItem];
    [self.projectTableView reloadData];
    [self reloadTitleWithData:self.data];
    [self.typePopover dismissPopoverAnimated:YES];
}

- (void)didPadCategoryCellSelect:(CDProjectCategory *)category
{
    [self.data setCurrentCategory:category];
    [self.data reloadProjectItem];
    [self.projectTableView reloadData];
    [self reloadTitleWithData:self.data];
    if (self.data.currentCategory.subCategory.count == 0)
    {
        [self.typePopover dismissPopoverAnimated:YES];
    }
}

- (void)didPadCategorySubOtherSelect
{
    [self.data setCurrentCategory:nil];
    [self.data reloadOnlyParantProjectItem];
    [self.projectTableView reloadData];
    [self reloadTitleWithData:self.data];
    if (self.data.currentCategory.subCategory.count == 0)
    {
        [self.typePopover dismissPopoverAnimated:YES];
    }
}

#pragma mark -
#pragma mark PadSubCategoryViewControllerDelegate Methods

- (void)didPadSubCategoryBack:(CDProjectCategory *)category
{
    [self.data setCurrentCategory:category];
    [self.data reloadProjectItem];
    [self.projectTableView reloadData];
    [self reloadTitleWithData:self.data];
}

- (void)didPadSubCategorySubTotalSelect:(CDProjectCategory *)category
{
    [self.data setCurrentCategory:category];
    [self.data reloadProjectItem];
    [self.projectTableView reloadData];
    [self reloadTitleWithData:self.data];
    [self.typePopover dismissPopoverAnimated:YES];
}

- (void)didPadSubCategoryCellSelect:(CDProjectCategory *)category
{
    [self.data setCurrentCategory:category];
    [self.data reloadProjectItem];
    [self.projectTableView reloadData];
    [self reloadTitleWithData:self.data];
    if (self.data.currentCategory.subCategory.count == 0)
    {
        [self.typePopover dismissPopoverAnimated:YES];
    }
}

- (void)didPadSubCategorySubOtherSelect:(CDProjectCategory *)category
{
    [self.data setCurrentCategory:category];
    [self.data reloadOnlyParantProjectItem];
    [self.projectTableView reloadData];
    [self reloadTitleWithData:self.data];
    [self.typePopover dismissPopoverAnimated:YES];
}

@end
