//
//  ProjectCreateViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/8/6.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ProjectCreateViewController.h"

#import "UIImage+Orientation.h"
#import "SAImage.h"
#import "UIImage+Resizable.h"
#import "NSObject+MainThreadNotification.h"
#import "CBLoadingView.h"
#import "BSSectionFooter.h"
#import "BSAttributeLine.h"
#import "BSAttributeValue.h"
#import "BSConsumable.h"
#import "BSSubItem.h"
#import "BSProjectItem.h"
#import "PosCategoryViewController.h"
#import "SubPosCategoryViewController.h"
#import "PosCategoryCreateViewController.h"
#import "AttributeLineViewController.h"
#import "AttributeViewController.h"
#import "ConsumableViewController.h"
#import "SubItemViewController.h"
#import "BSOptionViewController.h"
#import "BSProjectItemCreateRequest.h"
#import "BSProjectTemplateCreateRequest.h"
#import "BSAttributePriceCreateRequest.h"
#import "TemplateListViewController.h"
#import "SDWebImageManager.h"

typedef enum kProjectSection
{
    kProjectSectionImage,
    kProjectSectionInfo,
    kProjectSectionSwitch,
    kProjectSectionDetail,
    kProjectSectionActive,
    kProjectSectionCount
}kProjectSection;

typedef enum kProjectImageRow
{
    kProjectImageEdit,
    kProjectImageRowCount
}kProjectImageRow;

typedef enum kProjectInfoRow
{
    kProjectInfoName,
    kProjectInfoPrice,
    kProjectInfoType,
    kProjectInfoPosCategory,
    kProjectInfoRowCount
}kProjectInfoRow;

typedef enum kProjectSwitchRow
{
    kProjectSwitchCanSale,
    kProjectSwitchCanBook,
    kProjectSwitchCanPurchase,
    kProjectSwitchRowCount
}kProjectSwitchRow;

typedef enum kProjectDetailRow
{
    kTemplateEditDetailTemplate         = 0,
    kTemplateEditDetailTemplateList     = 1,
    kTemplateEditProductDetailCount     = 2,
    
    kTemplateEditDetailConsumable       = 2,
    kTemplateEditProjectDetailCount     = 3,
    
    kProjectDetailBarCode       = 0,
    kProjectDetailInternalNum   = 1,
    kProjectItemDetailCount     = 2,
    
    kTemplateCreateDetailTemplate       = 2,
    kTemplateCreateDetailTemplateList   = 3,
    kTemplateCreateProductDetailCount   = 4,
    
    kTemplateCreateDetailConsumable     = 4,
    kTemplateCreateProjectDetailCount   = 5,
    
    kProjectDetailSubItems         = 2,
    kProjectCoursesDetailCount     = 3
    
}kProjectDetailRow;

typedef enum kProjectActiveRow
{
    kProjectActiveIsActive,
    kProjectActiveRowCount
}kProjectActiveRow;

typedef enum kBNActionSheetType
{
    kBNActionSheetEditImage,
    kBNActionSheetSaveModify
}kBNActionSheetType;


#define kProjectImageCellHeight     304.0
#define kProjectCommonCellHeight    50.0

#define kProjectImageOriginY        78.0
#define kProjectImageWidth          171.0
#define kProjectImageHeight         128.0

@interface ProjectCreateViewController ()
{
    BOOL bPriceIsEdit;
}
@property (nonatomic, assign) kPadBornCategoryType type;
@property (nonatomic, assign) kProjectEditType editType;
@property (nonatomic, strong) CDProjectItem *projectItem;
@property (nonatomic, strong) CDProjectTemplate *projectTemplate;

@property (nonatomic, strong) BSProjectItem *bsProjectItem;

@property (nonatomic, assign) NSInteger requestCount;
@property (nonatomic, assign) BOOL isRequestSuccess;

@property (nonatomic, strong) UITableView *projectTableView;
@property (nonatomic, strong) BSCameraPickerController *cameraPicker;

@end


@implementation ProjectCreateViewController

#pragma mark -
#pragma mark Init Methdos

- (id)initWithProjectType:(kPadBornCategoryType)type
{
    self = [super initWithNibName:NIBCT(@"ProjectCreateViewController") bundle:nil];
    if (self != nil)
    {
        
        self.type = type;
        self.editType = kProjectTemplateCreate;
        [self registerNofitificationForMainThread:kBSProjectTemplateCreateResponse];
        
        self.bsProjectItem = [[BSProjectItem alloc] init];
        if (self.type == kPadBornCategoryProduct)
        {
            self.bsProjectItem.projectType = @"product";
        }
        else
        {
            self.bsProjectItem.projectType = @"service";
        }
        
        NSString *categorystr = [NSString stringWithFormat:@"BornCategory%d", self.type];
        self.title = [NSString stringWithFormat:LS(@"ProjectCreateNaviTitle"), LS(categorystr)];
    }
    
    return self;
}

- (id)initWithProjectItem:(CDProjectItem *)projectItem
{
    self = [super initWithNibName:NIBCT(@"ProjectCreateViewController") bundle:nil];
    if (self != nil)
    {
        self.editType = kProjectItemEdit;
        self.projectItem = projectItem;
        self.type = self.projectItem.bornCategory.integerValue;
        [self registerNofitificationForMainThread:kBSProjectItemCreateResponse];
        
        self.bsProjectItem = [[BSProjectItem alloc] init];
        self.bsProjectItem.projectName = self.projectItem.itemName;
        self.bsProjectItem.projectPrice = self.projectItem.totalPrice.floatValue;
        self.bsProjectItem.projectType = self.projectItem.type;
        self.bsProjectItem.posCategory = self.projectItem.category;
        self.bsProjectItem.barcode = self.projectItem.barcode;
        self.bsProjectItem.defaultCode = self.projectItem.defaultCode;
        self.bsProjectItem.isActive = self.projectItem.projectTemplate.isActive.boolValue;
        self.bsProjectItem.canSale = self.projectItem.projectTemplate.canSale.boolValue;
        self.bsProjectItem.canBook = self.projectItem.projectTemplate.canBook.boolValue;
        self.bsProjectItem.canPurchase = self.projectItem.projectTemplate.canPurchase.boolValue;
        
        self.title = self.projectItem.itemName;
    }
    
    return self;
}

- (id)initWithEditType:(kProjectEditType)editType projectTemplate:(CDProjectTemplate *)projectTemplate
{
    self = [super initWithNibName:NIBCT(@"ProjectCreateViewController") bundle:nil];
    if (self != nil)
    {
        self.editType = editType;
        self.projectTemplate = projectTemplate;
        self.type = self.projectTemplate.bornCategory.integerValue;
        if (self.editType == kProjectItemEdit || self.editType == kProjectItemCreate)
        {
            [self registerNofitificationForMainThread:kBSProjectItemCreateResponse];
        }
        else if (self.editType == kProjectTemplateEdit || self.editType == kProjectTemplateCreate)
        {
            [self registerNofitificationForMainThread:kBSProjectTemplateCreateResponse];
        }
        
        self.bsProjectItem = [[BSProjectItem alloc] init];
        self.bsProjectItem.projectName = self.projectTemplate.templateName;
        self.bsProjectItem.projectPrice = self.projectTemplate.listPrice.floatValue;
        self.bsProjectItem.projectType = self.projectTemplate.type;
        self.bsProjectItem.posCategory = self.projectTemplate.category;
        self.bsProjectItem.barcode = self.projectTemplate.barcode;
        self.bsProjectItem.defaultCode = self.projectTemplate.defaultCode;
        self.bsProjectItem.isActive = self.projectTemplate.isActive.boolValue;
        self.bsProjectItem.canSale = self.projectTemplate.canSale.boolValue;
        self.bsProjectItem.canBook = self.projectTemplate.canBook.boolValue;
        self.bsProjectItem.canPurchase = self.projectTemplate.canPurchase.boolValue;
        
        if (self.editType == kProjectTemplateEdit)
        {
            [self initAttributeLines];
            [self initConsumables];
            [self initSubItems];
        }
        
        self.title = self.projectTemplate.templateName;
    }
    
    return self;
}


#pragma mark -
#pragma mark Init Methods

- (void)initAttributeLines
{
    self.bsProjectItem.attributeLines = [NSMutableArray array];
    for (int i = 0; i < self.projectTemplate.attributeLines.count; i++)
    {
        CDProjectAttributeLine *attributeLine = [self.projectTemplate.attributeLines objectAtIndex:i];
        BSAttributeLine *bsAttributeLine = [[BSAttributeLine alloc] init];
        bsAttributeLine.attributeLineID = attributeLine.attributeLineID;
        bsAttributeLine.attributeLineName = attributeLine.attributeLineName;
        bsAttributeLine.templateID = attributeLine.templateID;
        bsAttributeLine.templateName = attributeLine.templateName;
        bsAttributeLine.attributeID = attributeLine.attributeID;
        bsAttributeLine.attributeName = attributeLine.attributeName;
        bsAttributeLine.attributeValues = [[NSMutableArray alloc] init];
        for (int j = 0; j < attributeLine.attributeValues.count; j++)
        {
            CDProjectAttributeValue *attributeValue = [attributeLine.attributeValues objectAtIndex:j];
            BSAttributeValue *bsAttributeValue = [[BSAttributeValue alloc] init];
            bsAttributeValue.editType = kBSDataNone;
            bsAttributeValue.attributeValueID = attributeValue.attributeValueID;
            bsAttributeValue.attributeValueName = attributeValue.attributeValueName;
            CDProjectAttributePrice *attributePrice = [[BSCoreDataManager currentManager] findEntity:@"CDProjectAttributePrice" withValue:attributeValue.attributeValueID forKey:[NSString stringWithFormat:@"templateID == %@ && attributeValueID", attributeLine.templateID]];
            bsAttributeValue.attributePrice = attributePrice;
            bsAttributeValue.attributeValueExtraPrice = 0.0;
            if (attributePrice != nil)
            {
                bsAttributeValue.attributeValueExtraPrice = attributePrice.extraPrice.floatValue;
            }
            
            [bsAttributeLine.attributeValues insertObject:bsAttributeValue atIndex:bsAttributeLine.attributeValues.count];
        }
        [self.bsProjectItem.attributeLines insertObject:bsAttributeLine atIndex:self.bsProjectItem.attributeLines.count];
    }
}

- (void)initConsumables
{
    self.bsProjectItem.consumables = [NSMutableArray array];
    for (int i = 0; i < self.projectTemplate.consumables.count; i++)
    {
        CDProjectConsumable *consumable = [self.projectTemplate.consumables objectAtIndex:i];
        BSConsumable *bsConsumable = [[BSConsumable alloc] init];
        bsConsumable.consumableID = consumable.consumableID;
        bsConsumable.productID = consumable.productID;
        bsConsumable.productName = consumable.productName;
        bsConsumable.baseProductID = consumable.baseProductID;
        bsConsumable.baseProductName = consumable.baseProductName;
        bsConsumable.isStock = consumable.isStock.boolValue;
        bsConsumable.uomID = consumable.uomID;
        bsConsumable.uomName = consumable.uomName;
        bsConsumable.amount = consumable.amount.integerValue;
        [self.bsProjectItem.consumables insertObject:bsConsumable atIndex:self.bsProjectItem.consumables.count];
    }
}

- (void)initSubItems
{
    if (self.projectTemplate.bornCategory.integerValue == kPadBornCategoryProduct || self.projectTemplate.bornCategory.integerValue == kPadBornCategoryProject || self.projectTemplate.projectItems.count == 0)
    {
        return;
    }
    
    self.bsProjectItem.subItems = [NSMutableArray array];
    CDProjectItem *projectItem = [self.projectTemplate.projectItems objectAtIndex:0];
    for (int i = 0; i < projectItem.subRelateds.count; i++)
    {
        CDProjectRelated *related = [projectItem.subRelateds.allObjects objectAtIndex:i];
        BSSubItem *bsSubItem = [[BSSubItem alloc] init];
        bsSubItem.relatedID = related.relatedID;
        bsSubItem.itemID = related.productID;
        bsSubItem.itemName = related.productName;
        bsSubItem.parentItemID = related.parentProductID;
        bsSubItem.parentItemName = related.parentProductName;
        bsSubItem.amount = related.quantity.integerValue;
        bsSubItem.itemPrice = related.openPrice.floatValue;
        bsSubItem.itemSetPrice = related.price.floatValue;
        bsSubItem.isUnlimited = related.isUnlimited.boolValue;
        bsSubItem.unlimitedDays = related.unlimitedDays.integerValue;
        CDProjectItem *item = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:related.productID forKey:@"itemID"];
        bsSubItem.projectType = item.bornCategory.integerValue;
        if (related.sameItems.count != 0)
        {
            bsSubItem.projectType = kPadBornCategoryProject;
        }
        
        bsSubItem.sameItems = [NSMutableArray array];
        for (int j = 0; j < related.sameItems.count; j++)
        {
            CDProjectItem *item = [related.sameItems objectAtIndex:j];
            [bsSubItem.sameItems addObject:item];
        }
        
        [self.bsProjectItem.subItems insertObject:bsSubItem atIndex:self.bsProjectItem.subItems.count];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self forbidSwipGesture];
    self.view.backgroundColor = COLOR(245.0, 245.0, 245.0, 1.0);
    self.view.frame = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
    
    BNBackButtonItem *backButtonItem = [[BNBackButtonItem alloc] initWithNormalImage:[UIImage imageNamed:@"navi_back_n"] highlightedImage:[UIImage imageNamed:@"navi_back_h"]];
    backButtonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    BNRightButtonItem *rightButtonItem = [[BNRightButtonItem alloc] initWithTitle:LS(@"Finish")];
    rightButtonItem.delegate = self;
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    [self registerNofitificationForMainThread:kBSPorjectInfoTypeSelected];
    [self registerNofitificationForMainThread:kBSProjectPosCategoryEditFinish];
    [self registerNofitificationForMainThread:kBSAttributeLinesEditFinish];
    [self registerNofitificationForMainThread:kBSProjectConsumableEditFinish];
    [self registerNofitificationForMainThread:kBSProjectSubItemEditFinish];
    [self registerNofitificationForMainThread:kBSAttributePriceCreateResponse];
    
    self.projectTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT - 64.0) style:UITableViewStylePlain];
    self.projectTableView.backgroundColor = [UIColor clearColor];
    self.projectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.projectTableView.delegate = self;
    self.projectTableView.dataSource = self;
    self.projectTableView.showsVerticalScrollIndicator = NO;
    self.projectTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.projectTableView];
    UIView *footerView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    footerView.backgroundColor = [UIColor clearColor];
    self.projectTableView.tableFooterView = footerView;
    
    self.bsProjectItem.projectImage = nil;
    if (self.projectItem)
    {
        if (self.projectItem.imageUrl != nil)
        {
            [SDWebImageManager.sharedManager downloadImageWithURL:[NSURL URLWithString:self.projectItem.imageUrl] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
             {
                 self.bsProjectItem.projectImage = image;
                 NSIndexPath *indexPath = [NSIndexPath indexPathForRow:kProjectImageEdit inSection:kProjectSectionImage];
                 UITableViewCell *cell = [self.projectTableView cellForRowAtIndexPath:indexPath];
                 [self imageCell:cell cellForRowAtIndexPath:indexPath];
             }];
        }
        else
        {
            self.bsProjectItem.projectImage = nil;
        }
    }
    else if (self.projectTemplate)
    {
        if (self.projectTemplate.imageUrl != nil)
        {
            [SDWebImageManager.sharedManager downloadImageWithURL:[NSURL URLWithString:self.projectTemplate.imageUrl] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
             {
                 self.bsProjectItem.projectImage = image;
                 NSIndexPath *indexPath = [NSIndexPath indexPathForRow:kProjectImageEdit inSection:kProjectSectionImage];
                 UITableViewCell *cell = [self.projectTableView cellForRowAtIndexPath:indexPath];
                 [self imageCell:cell cellForRowAtIndexPath:indexPath];
             }];
        }
        else
        {
            self.bsProjectItem.projectImage = nil;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark -
#pragma mark Required Methods

- (BOOL)isProjectItemModified
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (self.editType == kProjectTemplateEdit && (self.projectTemplate.bornCategory.integerValue == kPadBornCategoryCourses || self.projectTemplate.bornCategory.integerValue == kPadBornCategoryPackage || self.projectTemplate.bornCategory.integerValue == kPadBornCategoryPackageKit) && self.projectTemplate.projectItems.count == 0)
    {
        return NO;
    }
    
    if (self.bsProjectItem.isImageEdit)
    {
        return YES;
    }
    
    if (self.editType == kProjectItemEdit)
    {
        if ((![self.bsProjectItem.projectName isEqualToString:self.projectItem.itemName]) ||
            (self.bsProjectItem.posCategory.categoryID != nil && self.bsProjectItem.posCategory.categoryID.integerValue != self.projectItem.category.categoryID.integerValue) ||
            (self.bsProjectItem.projectType.length != 0 && ![self.bsProjectItem.projectType isEqualToString:self.projectItem.type]) ||
            (![self.bsProjectItem.barcode isEqualToString:@"0"] && ![self.bsProjectItem.barcode isEqualToString:self.projectItem.barcode]) ||
            (![self.bsProjectItem.defaultCode isEqualToString:@"0"] && ![self.bsProjectItem.defaultCode isEqualToString:self.projectItem.defaultCode]) ||
            (self.bsProjectItem.isActive != self.projectItem.projectTemplate.isActive.boolValue) ||
            (self.bsProjectItem.canSale != self.projectItem.projectTemplate.canSale.boolValue) ||
            (self.bsProjectItem.canBook != self.projectItem.projectTemplate.canBook.boolValue) ||
            (self.bsProjectItem.canPurchase != self.projectItem.canPurchase.boolValue))
        {
            return YES;
        }
    }
    else if (self.editType == kProjectTemplateEdit || self.editType == kProjectItemCreate)
    {
        if ((![self.bsProjectItem.projectName isEqualToString:self.projectTemplate.templateName]) ||
            (self.bsProjectItem.posCategory.categoryID != nil && self.bsProjectItem.posCategory.categoryID.integerValue != self.projectTemplate.category.categoryID.integerValue) ||
            (self.bsProjectItem.projectType.length != 0 && ![self.bsProjectItem.projectType isEqualToString:self.projectTemplate.type]) ||
            (![self.bsProjectItem.barcode isEqualToString:@"0"] && ![self.bsProjectItem.barcode isEqualToString:self.projectTemplate.barcode]) ||
            (![self.bsProjectItem.defaultCode isEqualToString:@"0"] && ![self.bsProjectItem.defaultCode isEqualToString:self.projectTemplate.defaultCode]) ||
            (self.bsProjectItem.isActive != self.projectTemplate.isActive.boolValue) ||
            (self.bsProjectItem.canSale != self.projectTemplate.canSale.boolValue) ||
            (self.bsProjectItem.canBook != self.projectTemplate.canBook.boolValue) ||
            (self.bsProjectItem.canPurchase != self.projectTemplate.canPurchase.boolValue))
        {
            return YES;
        }
        
        if (self.editType == kProjectTemplateEdit)
        {
            if (self.bsProjectItem.projectPrice != self.projectTemplate.listPrice.floatValue ||
                (self.bsProjectItem.attributeLines.count != self.projectTemplate.attributeLines.count) ||
                (self.bsProjectItem.consumables.count != self.projectTemplate.consumables.count))
            {
                return YES;
            }
        }
        
        if ((self.projectTemplate.bornCategory.integerValue == kPadBornCategoryCourses || self.projectTemplate.bornCategory.integerValue == kPadBornCategoryPackage || self.projectTemplate.bornCategory.integerValue == kPadBornCategoryPackageKit) && self.projectTemplate.projectItems.count != 0)
        {
            CDProjectItem *item = [self.projectTemplate.projectItems objectAtIndex:0];
            if (self.bsProjectItem.subItems.count != item.subItems.count)
            {
                return YES;
            }
        }
    }
    else if (self.editType == kProjectTemplateCreate)
    {
        if ((self.bsProjectItem.projectName.length != 0) ||
            (self.bsProjectItem.posCategory.categoryID.integerValue != 0) ||
            (self.bsProjectItem.projectType.length != 0 && ![self.bsProjectItem.projectType isEqualToString:(self.type == kPadBornCategoryProduct ? @"product" : @"service")]) ||
            (self.bsProjectItem.barcode.length != 0) ||
            (self.bsProjectItem.defaultCode.length != 0) ||
            (!self.bsProjectItem.isActive) ||
            (!self.bsProjectItem.canSale) ||
            (!self.bsProjectItem.canBook) ||
            (!self.bsProjectItem.canPurchase) ||
            (self.bsProjectItem.attributeLines.count != 0) ||
            (self.bsProjectItem.consumables.count != 0) ||
            (self.bsProjectItem.subItems.count != 0))
        {
            return YES;
        }
    }
    
    if (self.editType == kProjectTemplateEdit || self.editType == kProjectTemplateCreate)
    {
        if (self.type == kPadBornCategoryProduct || self.type == kPadBornCategoryProject)
        {
            if ([self isTemplateModified])
            {
                return YES;
            }
            
            if (self.type == kPadBornCategoryProject)
            {
                if ([self isConsumableModified])
                {
                    return YES;
                }
            }
        }
        else if (self.type == kPadBornCategoryCourses || self.type == kPadBornCategoryPackage || self.type == kPadBornCategoryPackageKit )
        {
            if ([self isSubItemModified])
            {
                return YES;
            }
        }
    }
    
    return NO;
}

- (BOOL)isTemplateModified
{
    NSMutableArray *bsAttributeLines = [NSMutableArray arrayWithArray:self.bsProjectItem.attributeLines];
    if (self.editType == kProjectTemplateEdit)
    {
        for (int i = 0; i < self.projectTemplate.attributeLines.count; i++)
        {
            CDProjectAttributeLine *attributeLine = [self.projectTemplate.attributeLines objectAtIndex:i];
            BOOL isDelete = YES;
            for (int j = 0; j < bsAttributeLines.count; j++)
            {
                BSAttributeLine *bsAttributeLine = [bsAttributeLines objectAtIndex:j];
                if (bsAttributeLine.attributeLineID.integerValue != 0 && bsAttributeLine.attributeLineID.integerValue == attributeLine.attributeLineID.integerValue)
                {
                    isDelete = NO;
                    if (bsAttributeLine.attributeID.integerValue != attributeLine.attributeID.integerValue || bsAttributeLine.attributeValues.count != attributeLine.attributeValues.count)
                    {
                        return YES;
                    }
                    else
                    {
                        for (int k = 0; k < bsAttributeLine.attributeValues.count; k++)
                        {
                            BSAttributeValue *bsAttributeValue = [bsAttributeLine.attributeValues objectAtIndex:k];
                            CDProjectAttributeValue *attributeValue = [attributeLine.attributeValues objectAtIndex:k];
                            if (bsAttributeValue.attributeValueID.integerValue != attributeValue.attributeValueID.integerValue)
                            {
                                return YES;
                            }
                            else
                            {
                                if (bsAttributeValue.attributePrice.extraPrice.floatValue != bsAttributeValue.attributeValueExtraPrice)
                                {
                                    return YES;
                                }
                            }
                        }
                    }
                    
                    [bsAttributeLines removeObject:bsAttributeLine];
                    j--;
                    
                    break;
                }
            }
            
            if (isDelete)
            {
                return YES;
            }
        }
    }
    
    if (bsAttributeLines.count != 0)
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)isConsumableModified
{
    NSMutableArray *bsConsumables = [NSMutableArray arrayWithArray:self.bsProjectItem.consumables];
    if (self.editType == kProjectTemplateEdit)
    {
        for (int i = 0; i < self.projectTemplate.consumables.count; i++)
        {
            CDProjectConsumable *consumable = [self.projectTemplate.consumables objectAtIndex:i];
            BOOL isDelete = YES;
            for (int j = 0; j < bsConsumables.count; j++)
            {
                BSConsumable *bsConsumable = [bsConsumables objectAtIndex:j];
                if (bsConsumable.consumableID.integerValue != 0 && bsConsumable.consumableID.integerValue == consumable.consumableID.integerValue)
                {
                    isDelete = NO;
                    if (bsConsumable.productID.integerValue != consumable.productID.integerValue || bsConsumable.uomID.integerValue != consumable.uomID.integerValue || bsConsumable.amount != consumable.amount.integerValue || bsConsumable.isStock != consumable.isStock.boolValue)
                    {
                        return YES;
                    }
                    
                    [bsConsumables removeObject:bsConsumable];
                    j--;
                    
                    break;
                }
            }
            
            if (isDelete)
            {
                return YES;
            }
        }
    }
    
    if (bsConsumables.count != 0)
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)isSubItemModified
{
    NSMutableArray *bsSubItems = [NSMutableArray arrayWithArray:self.bsProjectItem.subItems];
    if (self.editType == kProjectTemplateEdit)
    {
        if ((self.projectTemplate.bornCategory.integerValue == kPadBornCategoryProduct || self.projectTemplate.bornCategory.integerValue == kPadBornCategoryProject) && self.projectTemplate.projectItems.count == 0)
        {
            return NO;
        }
        
        CDProjectItem *projectItem = [self.projectTemplate.projectItems objectAtIndex:0];
        for (int i = 0; i < projectItem.subRelateds.count; i++)
        {
            BOOL isDelete = YES;
            CDProjectRelated *related = [projectItem.subRelateds.allObjects objectAtIndex:i];
            
            for (int j = 0; j < bsSubItems.count; j++)
            {
                BSSubItem *bsSubItem = [bsSubItems objectAtIndex:j];
                if (bsSubItem.relatedID.integerValue != 0 && bsSubItem.relatedID.integerValue == related.relatedID.integerValue)
                {
                    isDelete = NO;
                    if (bsSubItem.itemID.integerValue != related.productID.integerValue || bsSubItem.amount != related.quantity.integerValue || bsSubItem.itemSetPrice != related.price.floatValue || bsSubItem.sameItems.count != related.sameItems.count)
                    {
                        return YES;
                    }
                    else if (bsSubItem.isUnlimited != related.isUnlimited.boolValue)
                    {
                        return YES;
                    }
                    else if (bsSubItem.isUnlimited == related.isUnlimited.boolValue && bsSubItem.isUnlimited && bsSubItem.unlimitedDays != related.unlimitedDays.integerValue)
                    {
                        return YES;
                    }
                    else
                    {
                        if (bsSubItem.sameItems.count != related.sameItems.count)
                        {
                            return YES;
                        }
                        else
                        {
                            for (int k = 0; k < bsSubItem.sameItems.count; k++)
                            {
                                BOOL isExist = NO;
                                CDProjectItem *bsItem = [bsSubItem.sameItems objectAtIndex:k];
                                for (int l = 0; l < related.sameItems.count; l++)
                                {
                                    CDProjectItem *item = [related.sameItems objectAtIndex:l];
                                    if (bsItem.itemID.integerValue == item.itemID.integerValue)
                                    {
                                        isExist = YES;
                                        break;
                                    }
                                }
                                
                                if (!isExist)
                                {
                                    return YES;
                                }
                            }
                        }
                    }
                    
                    [bsSubItems removeObject:bsSubItem];
                    j--;
                    
                    break;
                }
            }
            
            if (isDelete)
            {
                return YES;
            }
        }
    }
    
    if (bsSubItems.count != 0)
    {
        return YES;
    }
    
    return NO;
}

- (NSMutableDictionary *)projectItemParams
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.bsProjectItem.isImageEdit)
    {
        if (self.bsProjectItem.projectImage != nil)
        {
            NSData *data = UIImageJPEGRepresentation(self.bsProjectItem.projectImage, 0.7);
            NSString *imagestr = [data base64Encoding];
            [params setObject:imagestr forKey:@"image"];
        }
        else
        {
            [params setObject:[NSNumber numberWithBool:false] forKey:@"image"];
        }
    }
    
    if (self.editType == kProjectItemEdit)
    {
        if (![self.bsProjectItem.projectName isEqualToString:self.projectItem.itemName])
        {
            [params setObject:self.bsProjectItem.projectName forKey:@"name"];
        }
        if (self.bsProjectItem.posCategory.categoryID != nil && self.bsProjectItem.posCategory.categoryID.integerValue != self.projectItem.category.categoryID.integerValue)
        {
            [params setObject:self.bsProjectItem.posCategory.categoryID forKey:@"pos_categ_id"];
        }
        if (self.bsProjectItem.projectType.length != 0 && ![self.bsProjectItem.projectType isEqualToString:self.projectItem.type])
        {
            [params setObject:self.bsProjectItem.projectType forKey:@"type"];
        }
        if (![self.bsProjectItem.barcode isEqualToString:@"0"] && ![self.bsProjectItem.barcode isEqualToString:self.projectItem.barcode])
        {
            [params setObject:self.bsProjectItem.barcode forKey:@"barcode"];
        }
        if (![self.bsProjectItem.defaultCode isEqualToString:@"0"] && ![self.bsProjectItem.defaultCode isEqualToString:self.projectItem.defaultCode])
        {
            [params setObject:self.bsProjectItem.defaultCode forKey:@"default_code"];
        }
        if (self.bsProjectItem.isActive != self.projectItem.projectTemplate.isActive.boolValue)
        {
            [params setObject:[NSNumber numberWithBool:self.bsProjectItem.isActive] forKey:@"active"];
        }
        if (self.bsProjectItem.canSale != self.projectItem.projectTemplate.canSale.boolValue)
        {
            [params setObject:[NSNumber numberWithBool:self.bsProjectItem.canSale] forKey:@"sale_ok"];
        }
        if (self.bsProjectItem.canBook != self.projectItem.projectTemplate.canBook.boolValue)
        {
            [params setObject:[NSNumber numberWithBool:self.bsProjectItem.canBook] forKey:@"book_ok"];
        }
        if (self.bsProjectItem.canPurchase != self.projectItem.canPurchase.boolValue)
        {
            [params setObject:[NSNumber numberWithBool:self.bsProjectItem.canPurchase] forKey:@"purchase_ok"];
        }
    }
    else if (self.editType == kProjectTemplateEdit || self.editType == kProjectItemCreate)
    {
        if (![self.bsProjectItem.projectName isEqualToString:self.projectTemplate.templateName])
        {
            [params setObject:self.bsProjectItem.projectName forKey:@"name"];
        }
        if (self.bsProjectItem.posCategory.categoryID != nil && self.bsProjectItem.posCategory.categoryID.integerValue != self.projectTemplate.category.categoryID.integerValue)
        {
            [params setObject:self.bsProjectItem.posCategory.categoryID forKey:@"pos_categ_id"];
        }
        if (self.bsProjectItem.projectType.length != 0 && ![self.bsProjectItem.projectType isEqualToString:self.projectTemplate.type])
        {
            [params setObject:self.bsProjectItem.projectType forKey:@"type"];
        }
        if (![self.bsProjectItem.barcode isEqualToString:@"0"] && ![self.bsProjectItem.barcode isEqualToString:self.projectTemplate.barcode])
        {
            [params setObject:self.bsProjectItem.barcode forKey:@"barcode"];
        }
        if (![self.bsProjectItem.defaultCode isEqualToString:@"0"] && ![self.bsProjectItem.defaultCode isEqualToString:self.projectTemplate.defaultCode])
        {
            [params setObject:self.bsProjectItem.defaultCode forKey:@"default_code"];
        }
        if (self.bsProjectItem.isActive != self.projectTemplate.isActive.boolValue)
        {
            [params setObject:[NSNumber numberWithBool:self.bsProjectItem.isActive] forKey:@"active"];
        }
        if (self.bsProjectItem.canSale != self.projectTemplate.canSale.boolValue)
        {
            [params setObject:[NSNumber numberWithBool:self.bsProjectItem.canSale] forKey:@"sale_ok"];
        }
        if (self.bsProjectItem.canBook != self.projectTemplate.canBook.boolValue)
        {
            [params setObject:[NSNumber numberWithBool:self.bsProjectItem.canBook] forKey:@"book_ok"];
        }
        if (self.bsProjectItem.canPurchase != self.projectTemplate.canPurchase.boolValue)
        {
            [params setObject:[NSNumber numberWithBool:self.bsProjectItem.canPurchase] forKey:@"purchase_ok"];
        }
        
        if (self.editType == kProjectTemplateEdit)
        {
            if (self.bsProjectItem.projectPrice != self.projectTemplate.listPrice.floatValue)
            {
                [params setObject:[NSNumber numberWithFloat:self.bsProjectItem.projectPrice] forKey:@"list_price"];
            }
        }
    }
    else if (self.editType == kProjectTemplateCreate)
    {
        [params setObject:self.bsProjectItem.projectName forKey:@"name"];
        if (self.bsProjectItem.posCategory.categoryID != nil)
        {
            [params setObject:self.bsProjectItem.posCategory.categoryID forKey:@"pos_categ_id"];
        }
        [params setObject:self.bsProjectItem.projectType forKey:@"type"];
        if (self.type == kPadBornCategoryProduct || self.type == kPadBornCategoryProject)
        {
            [params setObject:[NSNumber numberWithFloat:self.bsProjectItem.projectPrice] forKey:@"list_price"];
        }
        else if (self.type == kPadBornCategoryCourses || self.type == kPadBornCategoryPackage || self.type == kPadBornCategoryPackageKit)
        {
//            CGFloat totalPrice = 0.0;
//            for (int i = 0; i < self.bsProjectItem.subItems.count; i++)
//            {
//                BSSubItem *subItem = [self.bsProjectItem.subItems objectAtIndex:i];
//                totalPrice += subItem.amount * subItem.itemSetPrice;
//            }
//            [params setObject:[NSNumber numberWithFloat:totalPrice] forKey:@"list_price"];
            [params setObject:@(self.bsProjectItem.projectPrice) forKey:@"list_price"];
        }
        if (self.bsProjectItem.barcode.length != 0 && ![self.bsProjectItem.barcode isEqualToString:@"0"])
        {
            [params setObject:self.bsProjectItem.barcode forKey:@"barcode"];
        }
        if (self.bsProjectItem.defaultCode.length != 0 && ![self.bsProjectItem.defaultCode isEqualToString:@"0"])
        {
            [params setObject:self.bsProjectItem.defaultCode forKey:@"default_code"];
        }
        [params setObject:[NSNumber numberWithBool:self.bsProjectItem.canSale] forKey:@"sale_ok"];
        [params setObject:[NSNumber numberWithBool:self.bsProjectItem.canBook] forKey:@"book_ok"];
        [params setObject:[NSNumber numberWithBool:self.bsProjectItem.canPurchase] forKey:@"purchase_ok"];
    }
    
    if (self.editType == kProjectTemplateEdit || self.editType == kProjectTemplateCreate)
    {
        if (self.type == kPadBornCategoryProduct || self.type == kPadBornCategoryProject)
        {
            NSArray *templates = [self templateParams];
            if (templates != nil && templates.count != 0)
            {
                [params setObject:templates forKey:@"attribute_line_ids"];
            }
            
            if (self.type == kPadBornCategoryProject)
            {
                NSArray *consumables = [self consumableParams];
                if (consumables != nil && consumables.count != 0)
                {
                    [params setObject:consumables forKey:@"consumables_ids"];
                }
            }
        }
        else if (self.type == kPadBornCategoryCourses || self.type == kPadBornCategoryPackage || self.type == kPadBornCategoryPackageKit)
        {
            NSArray *subItems = [self subItemsParams];
            if (subItems != nil && subItems.count != 0)
            {
                [params setObject:subItems forKey:@"pack_line_ids"];
            }
        }
    }
    
    return params;
}

- (NSMutableArray *)templateParams
{
    NSMutableArray *params = [NSMutableArray array];
    NSMutableArray *bsAttributeLines = [NSMutableArray arrayWithArray:self.bsProjectItem.attributeLines];
    BOOL isTotalEdited = NO;
    if (self.editType == kProjectTemplateEdit)
    {
        for (int i = 0; i < self.projectTemplate.attributeLines.count; i++)
        {
            CDProjectAttributeLine *attributeLine = [self.projectTemplate.attributeLines objectAtIndex:i];
            BOOL isDelete = YES;
            for (int j = 0; j < bsAttributeLines.count; j++)
            {
                BSAttributeLine *bsAttributeLine = [bsAttributeLines objectAtIndex:j];
                if (bsAttributeLine.attributeLineID.integerValue != 0 && bsAttributeLine.attributeLineID.integerValue == attributeLine.attributeLineID.integerValue)
                {
                    isDelete = NO;
                    BOOL isEdited = NO;
                    if (bsAttributeLine.attributeID.integerValue != attributeLine.attributeID.integerValue || bsAttributeLine.attributeValues.count != attributeLine.attributeValues.count)
                    {
                        isEdited = YES;
                        isTotalEdited = YES;
                    }
                    else
                    {
                        for (int k = 0; k < bsAttributeLine.attributeValues.count; k++)
                        {
                            BSAttributeValue *bsAttributeValue = [bsAttributeLine.attributeValues objectAtIndex:k];
                            CDProjectAttributeValue *attributeValue = [attributeLine.attributeValues objectAtIndex:k];
                            if (bsAttributeValue.attributeValueID.integerValue != attributeValue.attributeValueID.integerValue)
                            {
                                isEdited = YES;
                                isTotalEdited = YES;
                            }
                        }
                    }
                    
                    if (!isEdited)
                    {
                        [params addObject:@[[NSNumber numberWithInteger:kBSDataLinked], attributeLine.attributeLineID, [NSNumber numberWithBool:NO]]];
                    }
                    else
                    {
                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        if (bsAttributeLine.attributeID.integerValue != attributeLine.attributeID.integerValue)
                        {
                            [dict setObject:bsAttributeLine.attributeID forKey:@"attribute_id"];
                        }
                        
                        NSMutableArray *values = [NSMutableArray array];
                        for (int k = 0; k < bsAttributeLine.attributeValues.count; k++)
                        {
                            BSAttributeValue *attributeValue = [bsAttributeLine.attributeValues objectAtIndex:k];
                            [values addObject:attributeValue.attributeValueID];
                        }
                        NSArray *valueIds = @[@[[NSNumber numberWithInteger:kBSDataExist], [NSNumber numberWithBool:NO], values]];
                        [dict setObject:valueIds forKey:@"value_ids"];
                        [params addObject:@[[NSNumber numberWithInteger:kBSDataUpdate], bsAttributeLine.attributeLineID, dict]];
                    }
                    
                    [bsAttributeLines removeObject:bsAttributeLine];
                    j--;
                    
                    break;
                }
            }
            
            if (isDelete)
            {
                isTotalEdited = YES;
                [params addObject:@[[NSNumber numberWithInteger:kBSDataDelete], attributeLine.attributeLineID, [NSNumber numberWithBool:NO]]];
            }
        }
    }
    
    if (!isTotalEdited && bsAttributeLines.count == 0)
    {
        return nil;
    }
    
    for (int i = 0; i < bsAttributeLines.count; i++)
    {
        BSAttributeLine *attributeLine = [bsAttributeLines objectAtIndex:i];
        NSMutableArray *values = [NSMutableArray array];
        for (int j = 0; j < attributeLine.attributeValues.count; j++)
        {
            BSAttributeValue *attributeValue = [attributeLine.attributeValues objectAtIndex:j];
            [values addObject:attributeValue.attributeValueID];
        }
        
        NSArray *valueIds = @[@[[NSNumber numberWithInteger:kBSDataExist], [NSNumber numberWithBool:NO], values]];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              attributeLine.attributeID, @"attribute_id",
                              valueIds, @"value_ids", nil];
        [params addObject:@[[NSNumber numberWithInteger:kBSDataAdded], [NSNumber numberWithBool:NO], dict]];
    }
    
    return params;
}

- (NSMutableArray *)consumableParams
{
    NSMutableArray *params = [NSMutableArray array];
    NSMutableArray *bsConsumables = [NSMutableArray arrayWithArray:self.bsProjectItem.consumables];
    BOOL isTotalEdited = NO;
    if (self.editType == kProjectTemplateEdit)
    {
        for (int i = 0; i < self.projectTemplate.consumables.count; i++)
        {
            CDProjectConsumable *consumable = [self.projectTemplate.consumables objectAtIndex:i];
            BOOL isDelete = YES;
            for (int j = 0; j < bsConsumables.count; j++)
            {
                BSConsumable *bsConsumable = [bsConsumables objectAtIndex:j];
                if (bsConsumable.consumableID.integerValue != 0 && bsConsumable.consumableID.integerValue == consumable.consumableID.integerValue)
                {
                    isDelete = NO;
                    BOOL isEdited = NO;
                    if (bsConsumable.productID.integerValue != consumable.productID.integerValue || bsConsumable.uomID.integerValue != consumable.uomID.integerValue || bsConsumable.amount != consumable.amount.integerValue || bsConsumable.isStock != consumable.isStock.boolValue)
                    {
                        isEdited = YES;
                        isTotalEdited = YES;
                    }
                    
                    if (!isEdited)
                    {
                        [params addObject:@[[NSNumber numberWithInteger:kBSDataLinked], bsConsumable.consumableID, [NSNumber numberWithBool:NO]]];
                    }
                    else
                    {
                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        if (bsConsumable.productID.integerValue != consumable.productID.integerValue)
                        {
                            [dict setObject:bsConsumable.productID forKey:@"product_id"];
                        }
                        if (bsConsumable.uomID.integerValue != consumable.uomID.integerValue)
                        {
                            [dict setObject:bsConsumable.uomID forKey:@"uom_id"];
                        }
                        if (bsConsumable.amount != consumable.amount.integerValue)
                        {
                            [dict setObject:[NSNumber numberWithInteger:bsConsumable.amount] forKey:@"qty"];
                        }
                        if (bsConsumable.isStock != consumable.isStock.boolValue)
                        {
                            [dict setObject:[NSNumber numberWithBool:bsConsumable.isStock] forKey:@"is_stock"];
                        }
                        [params addObject:@[[NSNumber numberWithInteger:kBSDataUpdate], bsConsumable.consumableID, dict]];
                    }
                    
                    [bsConsumables removeObject:bsConsumable];
                    j--;
                    
                    break;
                }
            }
            
            if (isDelete)
            {
                isTotalEdited = YES;
                [params addObject:@[[NSNumber numberWithInteger:kBSDataDelete], consumable.consumableID, [NSNumber numberWithBool:NO]]];
            }
        }
    }
    
    if (!isTotalEdited && bsConsumables.count == 0)
    {
        return nil;
    }
    
    for (int i = 0; i < bsConsumables.count; i++)
    {
        BSConsumable *bsConsumable = [bsConsumables objectAtIndex:i];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              bsConsumable.productID, @"product_id",
                              bsConsumable.uomID, @"uom_id",
                              [NSNumber numberWithInteger:bsConsumable.amount], @"qty",
                              [NSNumber numberWithBool:bsConsumable.isStock], @"is_stock", nil];
        [params addObject:@[[NSNumber numberWithInteger:kBSDataAdded], [NSNumber numberWithBool:NO], dict]];
    }
    
    return params;
}

- (NSArray *)subItemsParams
{
    NSMutableArray *params = [NSMutableArray array];
    NSMutableArray *bsSubItems = [NSMutableArray arrayWithArray:self.bsProjectItem.subItems];
    BOOL isTotalEdited = NO;
    if (self.editType == kProjectTemplateEdit)
    {
        if (self.projectTemplate.projectItems.count == 0)
        {
            return nil;
        }
        
        CDProjectItem *projectItem = [self.projectTemplate.projectItems objectAtIndex:0];
        for (int i = 0; i < projectItem.subRelateds.count; i++)
        {
            BOOL isDelete = YES;
            CDProjectRelated *related = [projectItem.subRelateds.allObjects objectAtIndex:i];
            
            for (int j = 0; j < bsSubItems.count; j++)
            {
                BSSubItem *bsSubItem = [bsSubItems objectAtIndex:j];
                if (bsSubItem.relatedID.integerValue != 0 && bsSubItem.relatedID.integerValue == related.relatedID.integerValue)
                {
                    isDelete = NO;
                    BOOL isEdited = NO;
                    if (bsSubItem.itemID.integerValue != related.productID.integerValue || bsSubItem.amount != related.quantity.integerValue || bsSubItem.itemSetPrice != related.price.floatValue || bsSubItem.sameItems.count != related.sameItems.count)
                    {
                        isEdited = YES;
                        isTotalEdited = YES;
                    }
                    else if (bsSubItem.isUnlimited != related.isUnlimited.boolValue)
                    {
                        isEdited = YES;
                        isTotalEdited = YES;
                    }
                    else if (bsSubItem.isUnlimited == related.isUnlimited.boolValue && bsSubItem.isUnlimited && bsSubItem.unlimitedDays != related.unlimitedDays.integerValue)
                    {
                        isEdited = YES;
                        isTotalEdited = YES;
                    }
                    else
                    {
                        if (bsSubItem.sameItems.count != related.sameItems.count)
                        {
                            isEdited = YES;
                            isTotalEdited = YES;
                        }
                        else
                        {
                            for (int k = 0; k < bsSubItem.sameItems.count; k++)
                            {
                                BOOL isExist = NO;
                                CDProjectItem *bsItem = [bsSubItem.sameItems objectAtIndex:k];
                                for (int l = 0; l < related.sameItems.count; l++)
                                {
                                    CDProjectItem *item = [related.sameItems objectAtIndex:l];
                                    if (bsItem.itemID.integerValue == item.itemID.integerValue)
                                    {
                                        isExist = YES;
                                        break;
                                    }
                                }
                                
                                if (!isExist)
                                {
                                    isEdited = YES;
                                    isTotalEdited = YES;
                                    break;
                                }
                            }
                        }
                    }
                    
                    if (!isEdited)
                    {
                        [params addObject:@[[NSNumber numberWithInteger:kBSDataLinked], bsSubItem.relatedID, [NSNumber numberWithBool:NO]]];
                    }
                    else
                    {
                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        [dict setObject:[NSNumber numberWithBool:YES] forKey:@"is_show_more"];
                        if (bsSubItem.itemID.integerValue != 0 && bsSubItem.itemID.integerValue != related.productID.integerValue)
                        {
                            [dict setObject:bsSubItem.itemID forKey:@"product_id"];
                        }
                        
                        if (bsSubItem.itemSetPrice != related.price.floatValue)
                        {
                            [dict setObject:[NSNumber numberWithFloat:bsSubItem.itemSetPrice] forKey:@"lst_price"];
                        }
                        
                        if (bsSubItem.amount != related.quantity.integerValue)
                        {
                            [dict setObject:[NSNumber numberWithInteger:bsSubItem.amount] forKey:@"quantity"];
                        }
                        
                        if (bsSubItem.isUnlimited != related.isUnlimited.boolValue)
                        {
                            [dict setObject:[NSNumber numberWithInteger:bsSubItem.isUnlimited] forKey:@"limited_qty"];
                            if (bsSubItem.isUnlimited)
                            {
                                [dict setObject:[NSNumber numberWithInteger:bsSubItem.unlimitedDays] forKey:@"limited_date"];
                            }
                        }
                        else
                        {
                            if (bsSubItem.isUnlimited && bsSubItem.unlimitedDays != related.unlimitedDays.integerValue)
                            {
                                [dict setObject:[NSNumber numberWithInteger:bsSubItem.unlimitedDays] forKey:@"limited_date"];
                            }
                        }
                        
                        if (bsSubItem.projectType == kPadBornCategoryProject)
                        {
                            NSMutableArray *sameIds = [NSMutableArray array];
                            for (int k = 0; k < bsSubItem.sameItems.count; k++)
                            {
                                CDProjectItem *bsItem = [bsSubItem.sameItems objectAtIndex:k];
                                [sameIds addObject:bsItem.itemID];
                            }
                            [dict setObject:@[@[[NSNumber numberWithInteger:kBSDataExist], [NSNumber numberWithBool:NO], sameIds]] forKey:@"same_ids"];
                        }
                        
                        [params addObject:@[[NSNumber numberWithInteger:kBSDataUpdate], bsSubItem.relatedID, dict]];
                    }
                    
                    [bsSubItems removeObject:bsSubItem];
                    j--;
                    
                    break;
                }
            }
            
            if (isDelete)
            {
                isTotalEdited = YES;
                [params addObject:@[[NSNumber numberWithInteger:kBSDataDelete], related.relatedID, [NSNumber numberWithBool:NO]]];
            }
        }
    }
    
    if (!isTotalEdited && bsSubItems.count == 0)
    {
        return nil;
    }
    
    for (int i = 0; i < bsSubItems.count; i++)
    {
        BSSubItem *bsSubItem = [bsSubItems objectAtIndex:i];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     bsSubItem.itemID, @"product_id",
                                     [NSNumber numberWithFloat:bsSubItem.itemSetPrice], @"lst_price",
                                     [NSNumber numberWithInteger:bsSubItem.amount], @"quantity", nil];
        
        [dict setObject:[NSNumber numberWithInteger:bsSubItem.isUnlimited] forKey:@"limited_qty"];
        if (bsSubItem.isUnlimited)
        {
            [dict setObject:[NSNumber numberWithInteger:bsSubItem.unlimitedDays] forKey:@"limited_date"];
        }
        
        if (bsSubItem.projectType == kPadBornCategoryProject)
        {
            NSMutableArray *sames = [NSMutableArray array];
            for (int j = 0; j < bsSubItem.sameItems.count; j++)
            {
                CDProjectItem *item = [bsSubItem.sameItems objectAtIndex:j];
                [sames addObject:@[[NSNumber numberWithInteger:kBSDataAdded], [NSNumber numberWithBool:NO], item.itemID]];
            }
            [dict setObject:sames forKey:@"same_ids"];
        }
        [params addObject:@[[NSNumber numberWithInteger:kBSDataAdded], [NSNumber numberWithBool:NO], dict]];
    }
    
    return params;
}

- (void)didProjectItemEditRequest
{
    
    
    if (self.bsProjectItem.projectName.length == 0)
    {
        NSString *categorystr = [NSString stringWithFormat:@"BornCategory%d", self.type];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:[NSString stringWithFormat:LS(@"ProjectNameCanNotBeNULL"), LS(categorystr)]
                                                           delegate:nil
                                                  cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if (self.bsProjectItem.projectType.length == 0)
    {
        NSString *categorystr = [NSString stringWithFormat:@"BornCategory%d", self.type];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:[NSString stringWithFormat:LS(@"ProjectTypeCanNotBeNULL"), LS(categorystr)]
                                                           delegate:nil
                                                  cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    NSMutableDictionary *params = [self projectItemParams];
    [params setObject:[NSNumber numberWithInteger:self.type] forKey:@"born_category"];
    
    if (self.editType == kProjectItemEdit)
    {
        [[CBLoadingView shareLoadingView] show];
        BSProjectItemCreateRequest *request = [[BSProjectItemCreateRequest alloc] initWithProjectItemID:self.projectItem.itemID params:params];
        [request execute];
    }
    else if (self.editType == kProjectItemCreate)
    {
        [[CBLoadingView shareLoadingView] show];
        [params setObject:self.projectTemplate.templateID forKey:@"product_tmpl_id"];
        BSProjectItemCreateRequest *request = [[BSProjectItemCreateRequest alloc] initWithParams:params];
        [request execute];
    }
    else if (self.editType == kProjectTemplateEdit)
    {
        NSNumber *itemID = nil;
        if (self.type == kPadBornCategoryCourses || self.type == kPadBornCategoryPackage || self.type == kPadBornCategoryPackageKit)
        {
            if (self.projectTemplate.projectItems.count > 0)
            {
                CDProjectItem *item = [self.projectTemplate.projectItems objectAtIndex:0];
                itemID = item.itemID;
            }
            else
            {
                return ;
            }
        }
        else
        {
            itemID = self.projectTemplate.templateID;
        }
        
        [[CBLoadingView shareLoadingView] show];
        BSProjectTemplateCreateRequest *request = [[BSProjectTemplateCreateRequest alloc] initWithProjectTemplateID:itemID params:params];
        
        [request execute];
    }
    else if (self.editType == kProjectTemplateCreate)
    {
        [[CBLoadingView shareLoadingView] show];
        BSProjectTemplateCreateRequest *request = [[BSProjectTemplateCreateRequest alloc] initWithParams:params];
       
        [request execute];
    }
}

- (void)didBackBarButtonItemClick:(id)sender
{
    if (![self isProjectItemModified])
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    BNActionSheet *actionSheet = [[BNActionSheet alloc] initWithTitle:LS(@"ProjectInfoIsModified") items:[NSArray arrayWithObjects:LS(@"SaveModified"), LS(@"NotSave"), nil] cancelTitle:LS(@"ContinueEdit") delegate:self];
    actionSheet.tag = kBNActionSheetSaveModify;
    [actionSheet show];
}

- (void)didRightBarButtonItemClick:(id)sender
{
    if (![self isProjectItemModified])
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    [self didProjectItemEditRequest];
}

- (BOOL)startAttributePriceRequestWithTemplateID:(NSNumber *)templateID
{
    self.requestCount = 0;
    self.isRequestSuccess = YES;
    NSMutableArray *requests = [NSMutableArray array];
    for (int i = 0; i < self.bsProjectItem.attributeLines.count; i++)
    {
        BSAttributeLine *bsAttributeLine = [self.bsProjectItem.attributeLines objectAtIndex:i];
        for (int j = 0; j < bsAttributeLine.attributeValues.count; j++)
        {
            BSAttributeValue *bsAttributeValue = [bsAttributeLine.attributeValues objectAtIndex:j];
            BSAttributePriceCreateRequest *request = [[BSAttributePriceCreateRequest alloc] initWithTemplateID:templateID attributeValueID:bsAttributeValue.attributeValueID extraPrice:bsAttributeValue.attributeValueExtraPrice];
            [requests addObject:request];
        }
    }
    
    if (requests.count == 0)
    {
        return NO;
    }
    
    self.requestCount = requests.count;
    for (ICRequest *request in requests)
    {
        [request execute];
    }
    
    return YES;
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSPorjectInfoTypeSelected])
    {
        self.bsProjectItem.projectType = (NSString *)notification.object;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:kProjectInfoType inSection:kProjectSectionInfo];
        BSEditCell *cell = (BSEditCell *)[self.projectTableView cellForRowAtIndexPath:indexPath];
        cell.contentField.text = LS(self.bsProjectItem.projectType);
    }
    else if ([notification.name isEqualToString:kBSProjectPosCategoryEditFinish])
    {
        self.bsProjectItem.posCategory = (CDProjectCategory *)notification.object;
        NSIndexPath *indexPath = [NSIndexPath  indexPathForRow:kProjectInfoPosCategory inSection:kProjectSectionInfo];
        BSEditCell *cell = (BSEditCell *)[self.projectTableView cellForRowAtIndexPath:indexPath];
        [self posCategory:cell cellForRowAtIndexPath:indexPath];
    }
    else if ([notification.name isEqualToString:kBSAttributeLinesEditFinish])
    {
        [self.projectTableView reloadData];
    }
    else if ([notification.name isEqualToString:kBSProjectConsumableEditFinish])
    {
        NSIndexPath *indexPath;
        if (self.editType == kProjectTemplateEdit)
        {
            indexPath = [NSIndexPath indexPathForRow:kTemplateEditDetailConsumable inSection:kProjectSectionDetail];
        }
        else if (self.editType == kProjectTemplateCreate)
        {
            indexPath = [NSIndexPath indexPathForRow:kTemplateCreateDetailConsumable inSection:kProjectSectionDetail];
        }
        BSEditCell *cell = (BSEditCell *)[self.projectTableView cellForRowAtIndexPath:indexPath];
        [self consumableCell:cell cellForRowAtIndexPath:indexPath];
    }
    else if ([notification.name isEqualToString:kBSProjectSubItemEditFinish])
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:kProjectDetailSubItems inSection:kProjectSectionDetail];
        BSEditCell *cell = (BSEditCell *)[self.projectTableView cellForRowAtIndexPath:indexPath];
        [self subItemCell:cell cellForRowAtIndexPath:indexPath];
        
        if (self.type == kPadBornCategoryCourses || self.type == kPadBornCategoryPackage || self.type == kPadBornCategoryPackageKit)
        {
            if ( bPriceIsEdit )
                return;
            
            CGFloat totalPrice = 0.0;
            for (int i = 0; i < self.bsProjectItem.subItems.count; i++)
            {
                BSSubItem *subItem = [self.bsProjectItem.subItems objectAtIndex:i];
                totalPrice += subItem.amount * subItem.itemSetPrice;
            }
            self.bsProjectItem.projectPrice = totalPrice;
            [self.projectTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:kProjectInfoPrice inSection:kProjectSectionInfo]] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }
    else if ([notification.name isEqualToString:kBSProjectItemCreateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            NSString *message = [notification.userInfo stringValueForKey:@"rm"];
            if(message.length != 0)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:message
                                                                   delegate:nil
                                                          cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
    }
    else if ([notification.name isEqualToString:kBSProjectTemplateCreateResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            NSNumber *templateID;
            if (self.editType == kProjectTemplateEdit)
            {
                templateID = self.projectTemplate.templateID;
            }
            else if (self.editType == kProjectTemplateCreate)
            {
                templateID = [notification.userInfo numberValueForKey:@"TemplateID"];
            }
            
            if (![self startAttributePriceRequestWithTemplateID:templateID])
            {
                [[CBLoadingView shareLoadingView] hide];
                [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectTemplateEditFinish object:nil userInfo:nil];
                if (self.editType == kProjectTemplateEdit)
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else if (self.editType == kProjectTemplateCreate)
                {
                    UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:(self.navigationController.viewControllers.count - 3)];
                    [self.navigationController popToViewController:viewController animated:YES];
                }
            }
        }
        else
        {
            [[CBLoadingView shareLoadingView] hide];
            NSString *message = [notification.userInfo stringValueForKey:@"rm"];
            if(message.length != 0)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:message
                                                                   delegate:nil
                                                          cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
    }
    else if ([notification.name isEqualToString:kBSAttributePriceCreateResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            self.requestCount --;
        }
        else
        {
            self.requestCount --;
            [[CBLoadingView shareLoadingView] hide];
            if (self.isRequestSuccess)
            {
                self.isRequestSuccess = NO;
                NSString *message = [notification.userInfo stringValueForKey:@"rm"];
                if(message.length != 0)
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                        message:message
                                                                       delegate:nil
                                                              cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                              otherButtonTitles:nil, nil];
                    [alertView show];
                }
            }
        }
        
        if (self.requestCount == 0 && self.isRequestSuccess)
        {
            [[CBLoadingView shareLoadingView] hide];
            [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectTemplateEditFinish object:nil userInfo:nil];
            if (self.editType == kProjectTemplateEdit)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if (self.editType == kProjectTemplateCreate)
            {
                UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:(self.navigationController.viewControllers.count - 3)];
                [self.navigationController popToViewController:viewController animated:YES];
            }
        }
    }
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kProjectSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kProjectSectionImage)
    {
        return kProjectImageRowCount;
    }
    else if (section == kProjectSectionInfo)
    {
        return kProjectInfoRowCount;
    }
    else if (section == kProjectSectionSwitch)
    {
        return kProjectSwitchRowCount;
    }
    else if (section == kProjectSectionDetail)
    {
        if (self.editType == kProjectItemEdit || self.editType == kProjectItemCreate)
        {
            return kProjectItemDetailCount;
        }
        else if (self.editType == kProjectTemplateEdit || self.editType == kProjectTemplateCreate)
        {
            if (self.type == kPadBornCategoryCourses || self.type == kPadBornCategoryPackage || self.type == kPadBornCategoryPackageKit)
            {
                return kProjectCoursesDetailCount;
            }
            else if (self.type == kPadBornCategoryProduct || self.type == kPadBornCategoryProject)
            {
                if (self.editType == kProjectTemplateEdit)
                {
                    if (self.type == kPadBornCategoryProduct)
                    {
                        return kTemplateEditProductDetailCount;
                    }
                    else if (self.type == kPadBornCategoryProject)
                    {
                        return kTemplateEditProjectDetailCount;
                    }
                }
                else if (self.editType == kProjectTemplateCreate)
                {
                    if (self.type == kPadBornCategoryProduct)
                    {
                        return kTemplateCreateProductDetailCount;
                    }
                    else if (self.type == kPadBornCategoryProject)
                    {
                        return kTemplateCreateProjectDetailCount;
                    }
                }
            }
        }
    }
    else if (section == kProjectSectionActive)
    {
        return kProjectActiveRowCount;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kProjectSectionImage)
    {
        return kProjectImageCellHeight;
    }
    else
    {
        if (indexPath.section == kProjectSectionDetail)
        {
            if (self.type == kPadBornCategoryProduct || self.type == kPadBornCategoryProject)
            {
                if ((self.editType == kProjectTemplateEdit && indexPath.row == kTemplateEditDetailTemplate) || (self.editType == kProjectTemplateCreate && indexPath.row == kTemplateCreateDetailTemplate))
                {
                    CGFloat cellHeight = kProjectCommonCellHeight;
                    for (int i = 0; i < self.bsProjectItem.attributeLines.count; i++)
                    {
                        cellHeight += 36.0;
                        BSAttributeLine *bsAttributeLine = [self.bsProjectItem.attributeLines objectAtIndex:i];
                        NSInteger valueCount = 0;
                        if (bsAttributeLine.attributeValues.count % 3 == 0)
                        {
                            valueCount = bsAttributeLine.attributeValues.count / 3;
                        }
                        else
                        {
                            valueCount = bsAttributeLine.attributeValues.count / 3 + 1;
                        }
                        
                        cellHeight += valueCount * (32.0 + 12.0);
                    }
                    
                    if (cellHeight > kProjectCommonCellHeight)
                    {
                        cellHeight += 8.0;
                    }
                    
                    return cellHeight;
                }
            }
        }
        
        return kProjectCommonCellHeight;
    }
    
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kProjectSectionImage)
    {
        static NSString *CellIdentifier = @"ImageCellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.bounds = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, kProjectImageCellHeight);
            UIView *normalView = [[UIView alloc] initWithFrame:cell.bounds];
            normalView.backgroundColor = [UIColor clearColor];
            cell.backgroundView = normalView;
            UIView *selectedView = [[UIView alloc] initWithFrame:cell.bounds];
            selectedView.backgroundColor = [UIColor clearColor];
            cell.selectedBackgroundView = selectedView;
            
            UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
            editButton.frame = CGRectMake((IC_SCREEN_WIDTH - kProjectImageWidth)/2.0, kProjectImageOriginY, kProjectImageWidth, kProjectImageHeight);
            editButton.backgroundColor = [UIColor clearColor];
            [editButton addTarget:self action:@selector(didEditImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            editButton.layer.masksToBounds = YES;
            editButton.layer.cornerRadius = 5.0;
            editButton.tag = 101;
            [cell.contentView addSubview:editButton];
            
            UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kProjectImageCellHeight - 0.5, IC_SCREEN_WIDTH, 0.5)];
            lineImageView.backgroundColor = [UIColor clearColor];
            lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
            [cell.contentView addSubview:lineImageView];
        }
        
        [self imageCell:cell cellForRowAtIndexPath:indexPath];
        
        return cell;
    }
    else if (indexPath.section == kProjectSectionSwitch || indexPath.section == kProjectSectionActive)
    {
        static NSString *CellIdentifier = @"BSSwitchCellIdentifier";
        BSSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[BSSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.delegate = self;
        }
        
        cell.indexPath = indexPath;
        if (indexPath.section == kProjectSectionSwitch)
        {
            if (indexPath.row == kProjectSwitchCanSale)
            {
                cell.titleLabel.text = LS(@"CanSale");
                
                cell.isSwitchOn = self.bsProjectItem.canSale;
            }
            else if (indexPath.row == kProjectSwitchCanBook)
            {
                cell.titleLabel.text = LS(@"CanBook");
                cell.isSwitchOn = self.bsProjectItem.canBook;
            }
            else if (indexPath.row == kProjectSwitchCanPurchase)
            {
                cell.titleLabel.text = LS(@"CanPurchase");
                cell.isSwitchOn = self.bsProjectItem.canPurchase;
            }
        }
        else if (indexPath.section == kProjectSectionActive)
        {
            if (indexPath.row == kProjectActiveIsActive)
            {
                cell.titleLabel.text = LS(@"IsActive");
                cell.isSwitchOn = self.bsProjectItem.isActive;
            }
        }
        
        return cell;
    }
    else
    {
        if (indexPath.section == kProjectSectionDetail)
        {
            if (self.type == kPadBornCategoryProduct || self.type == kPadBornCategoryProject)
            {
                if ((self.editType == kProjectTemplateEdit && indexPath.row == kTemplateEditDetailTemplate) || (self.editType == kProjectTemplateCreate && indexPath.row == kTemplateCreateDetailTemplate))
                {
                    static NSString *CellIdentifier = @"TemplateCellIdentifier";
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if (cell == nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bs_common_cell_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(12.0, 12.0, 12.0, 12.0)]];
                        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bs_common_cell_h"] imageResizableWithCapInsets:UIEdgeInsetsMake(12.0, 12.0, 12.0, 12.0)]];
                        
                        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16.0, 0.0, 150.0, kProjectCommonCellHeight)];
                        titleLabel.backgroundColor = [UIColor clearColor];
                        titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
                        titleLabel.textColor = COLOR(72.0, 72.0, 72.0, 1.0);
                        titleLabel.adjustsFontSizeToFitWidth = YES;
                        titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
                        titleLabel.text = LS(@"ProjectDetailTemplateTitle");
                        titleLabel.tag = 101;
                        [cell.contentView addSubview:titleLabel];
                        
                        CGFloat contentWidth = IC_SCREEN_WIDTH - 2 * 16.0 - 150.0 - 16.0 - 4.0;
                        UITextField *contentField = [[UITextField alloc] initWithFrame:CGRectMake(IC_SCREEN_WIDTH - 16.0 - 16.0 - contentWidth - 4.0, 0.0, contentWidth, kProjectCommonCellHeight)];
                        contentField.backgroundColor = [UIColor clearColor];
                        contentField.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
                        [contentField setValue:COLOR(136.0, 136.0, 136.0, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
                        contentField.textAlignment = NSTextAlignmentRight;
                        contentField.font = [UIFont boldSystemFontOfSize:13.0];
                        contentField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                        contentField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                        contentField.enabled = false;
                        contentField.returnKeyType = UIReturnKeyDone;
                        contentField.enabled = NO;
                        contentField.placeholder = LS(@"PleaseSet");
                        contentField.tag = 102;
                        [cell.contentView addSubview:contentField];
                        
                        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(IC_SCREEN_WIDTH - 16.0 - 16.0, (kProjectCommonCellHeight - 16.0)/2.0, 16.0, 16.0)];
                        arrowImageView.backgroundColor = [UIColor clearColor];
                        arrowImageView.image = [UIImage imageNamed:@"bs_common_arrow"];
                        arrowImageView.tag = 103;
                        [cell.contentView addSubview:arrowImageView];
                        
                        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, cell.contentView.frame.size.height - 0.5, IC_SCREEN_WIDTH, 0.5)];
                        lineImageView.backgroundColor = [UIColor clearColor];
                        lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
                        lineImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
                        lineImageView.tag = 104;
                        [cell.contentView addSubview:lineImageView];
                    }
                    
                    return [self templateCell:cell cellForRowAtIndexPath:indexPath];
                }
            }
        }
        
        static NSString *CellIdentifier = @"BSEditCellIdentifier";
        BSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[BSEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.contentField.delegate = self;
            
            UIImage *scanImage = [UIImage imageNamed:@"navi_scan_h"];
            UIButton *scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
            scanButton.frame = CGRectMake(cell.arrowImageView.frame.origin.x - 4.0, (kProjectCommonCellHeight - scanImage.size.height)/2.0, scanImage.size.width, scanImage.size.height);
            scanButton.backgroundColor = [UIColor clearColor];
            [scanButton setBackgroundImage:scanImage forState:UIControlStateNormal];
            [scanButton setBackgroundImage:[UIImage imageNamed:@"navi_scan_n"] forState:UIControlStateHighlighted];
            [scanButton addTarget:self action:@selector(didScanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            scanButton.tag = 1001;
            scanButton.hidden = YES;
            [cell.contentView addSubview:scanButton];
        }
        
        cell.contentField.tag = indexPath.section * 100 + indexPath.row;
        
        cell.arrowImageView.alpha = 1.0;
        cell.arrowImageView.hidden = NO;
        cell.scanButton.hidden = YES;
        cell.contentField.keyboardType = UIKeyboardTypeDefault;
        
        if (indexPath.section == kProjectSectionInfo)
        {
            if (indexPath.row == kProjectInfoName)
            {
                cell.titleLabel.text = LS(@"ProjectInfoNameTitle");
                cell.contentField.enabled = YES;
                cell.contentField.placeholder = LS(@"PleaseEnter");
                cell.contentField.text = self.bsProjectItem.projectName;
            }
            else if (indexPath.row == kProjectInfoPrice)
            {
                cell.contentField.keyboardType = UIKeyboardTypeDecimalPad;
                cell.titleLabel.text = LS(@"ProjectInfoPriceTitle");
                if (self.type == kPadBornCategoryProduct || self.type == kPadBornCategoryProject)
                {
                    cell.contentField.text = [NSString stringWithFormat:@"%.2f", self.bsProjectItem.projectPrice];
                    if (self.editType == kProjectTemplateCreate || self.editType == kProjectTemplateEdit)
                    {
                        cell.contentField.enabled = YES;
                        cell.contentField.placeholder = LS(@"PleaseEnter");
                    }
                    else
                    {
                        cell.contentField.enabled = NO;
                        cell.arrowImageView.hidden = YES;
                    }
                }
                if (self.type == kPadBornCategoryCourses || self.type == kPadBornCategoryPackage || self.type == kPadBornCategoryPackageKit)
                {
                    //cell.contentField.enabled = NO;
                    //cell.arrowImageView.hidden = YES;
                    cell.contentField.enabled = YES;
                    cell.contentField.placeholder = LS(@"PleaseEnter");
                    cell.contentField.text = [NSString stringWithFormat:@"%.2f", self.bsProjectItem.projectPrice];
                }
            }
            else if (indexPath.row == kProjectInfoType)
            {
                cell.titleLabel.text = LS(@"ProjectInfoTypeTitle");
                cell.contentField.enabled = NO;
                cell.contentField.placeholder = LS(@"PleaseSelect");
                cell.contentField.text = LS(self.bsProjectItem.projectType);
            }
            else if (indexPath.row == kProjectInfoPosCategory)
            {
                cell.titleLabel.text = LS(@"ProjectInfoPosCategoryTitle");
                cell.contentField.enabled = NO;
                cell.contentField.placeholder = LS(@"PleaseSelect");
                
                [self posCategory:cell cellForRowAtIndexPath:indexPath];
            }
        }
        else if (indexPath.section == kProjectSectionDetail)
        {
            if (self.editType == kProjectItemEdit || self.editType == kProjectItemCreate)
            {
                if (indexPath.row == kProjectDetailBarCode)
                {
                    cell.scanButton.hidden = NO;
                    cell.scanButton.tag = indexPath.section * 100 + indexPath.row;
                    [cell.scanButton addTarget:self action:@selector(didScanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                    
                    cell.arrowImageView.alpha = 0.0;
                    cell.titleLabel.text = LS(@"ProjectDetailBarCodeTitle");
                    cell.contentField.enabled = YES;
                    cell.contentField.placeholder = LS(@"PleaseEnter");
                    cell.contentField.text = self.bsProjectItem.barcode;
                }
                else if (indexPath.row == kProjectDetailInternalNum)
                {
                    cell.titleLabel.text = LS(@"ProjectDetailInternalNumTitle");
                    cell.contentField.enabled = YES;
                    cell.contentField.placeholder = LS(@"PleaseEnter");
                    cell.contentField.text = self.bsProjectItem.defaultCode;
                }
            }
            else if (self.editType == kProjectTemplateEdit || self.editType == kProjectTemplateCreate)
            {
                if (self.type == kPadBornCategoryCourses || self.type == kPadBornCategoryPackage || self.type == kPadBornCategoryPackageKit)
                {
                    if (indexPath.row == kProjectDetailBarCode)
                    {
                        cell.scanButton.hidden = NO;
                        cell.scanButton.tag = indexPath.section * 100 + indexPath.row;
                        [cell.scanButton addTarget:self action:@selector(didScanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                        
                        cell.arrowImageView.alpha = 0.0;
                        cell.titleLabel.text = LS(@"ProjectDetailBarCodeTitle");
                        cell.contentField.enabled = YES;
                        cell.contentField.placeholder = LS(@"PleaseEnter");
                        cell.contentField.text = self.bsProjectItem.barcode;
                    }
                    else if (indexPath.row == kProjectDetailInternalNum)
                    {
                        cell.titleLabel.text = LS(@"ProjectDetailInternalNumTitle");
                        cell.contentField.enabled = YES;
                        cell.contentField.placeholder = LS(@"PleaseEnter");
                        cell.contentField.text = self.bsProjectItem.defaultCode;
                    }
                    else if (indexPath.row == kProjectDetailSubItems)
                    {
                        cell.titleLabel.text = LS(@"ProjectDetailSubItemTitle");
                        cell.contentField.enabled = NO;
                        cell.contentField.placeholder = LS(@"PleaseSelect");
                        [self subItemCell:cell cellForRowAtIndexPath:indexPath];
                    }
                }
                else if (self.type == kPadBornCategoryProduct || self.type == kPadBornCategoryProject)
                {
                    if (self.editType == kProjectTemplateEdit)
                    {
                        if (indexPath.row == kTemplateEditDetailTemplateList)
                        {
                            cell.titleLabel.text = LS(@"TemplateItemList");
                            cell.contentField.enabled = NO;
                            cell.contentField.placeholder = LS(@"PleaseSet");
                            cell.contentField.text = @"";
                        }
                        else if (indexPath.row == kTemplateEditDetailConsumable)
                        {
                            cell.titleLabel.text = LS(@"ProjectDetailConsumableTitle");
                            cell.contentField.enabled = NO;
                            cell.contentField.placeholder = LS(@"PleaseSelect");
                            [self consumableCell:cell cellForRowAtIndexPath:indexPath];
                        }
                    }
                    else if (self.editType == kProjectTemplateCreate)
                    {
                        if (indexPath.row == kProjectDetailBarCode)
                        {
                            cell.scanButton.hidden = NO;
                            cell.scanButton.tag = indexPath.section * 100 + indexPath.row;
                            [cell.scanButton addTarget:self action:@selector(didScanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                            
                            cell.arrowImageView.alpha = 0.0;
                            cell.titleLabel.text = LS(@"ProjectDetailBarCodeTitle");
                            cell.contentField.enabled = YES;
                            cell.contentField.placeholder = LS(@"PleaseEnter");
                            cell.contentField.text = self.bsProjectItem.barcode;
                        }
                        else if (indexPath.row == kProjectDetailInternalNum)
                        {
                            cell.titleLabel.text = LS(@"ProjectDetailInternalNumTitle");
                            cell.contentField.enabled = YES;
                            cell.contentField.placeholder = LS(@"PleaseEnter");
                            cell.contentField.text = self.bsProjectItem.defaultCode;
                        }
                        else if (indexPath.row == kTemplateCreateDetailTemplateList)
                        {
                            cell.titleLabel.text = LS(@"TemplateItemList");
                            cell.contentField.enabled = NO;
                            cell.contentField.placeholder = LS(@"PleaseSet");
                            cell.contentField.text = @"";
                        }
                        else if (indexPath.row == kTemplateCreateDetailConsumable)
                        {
                            cell.titleLabel.text = LS(@"ProjectDetailConsumableTitle");
                            cell.contentField.enabled = NO;
                            cell.contentField.placeholder = LS(@"PleaseSelect");
                            [self consumableCell:cell cellForRowAtIndexPath:indexPath];
                        }
                    }
                }
            }
        }
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == kProjectSectionInfo || section == kProjectSectionSwitch || section == kProjectSectionDetail)
    {
        return kBSSectionFooterHeight;
    }
    
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == kProjectSectionInfo || section == kProjectSectionSwitch || section == kProjectSectionDetail)
    {
        static NSString *CellIdentifier = @"BSSectionFooterIdentifier";
        BSSectionFooter *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[BSSectionFooter alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        return cell;
    }
    
    return nil;
}

- (void)didEditImageButtonClick:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    BNActionSheet *actionSheet = [[BNActionSheet alloc] initWithItems:[NSArray arrayWithObjects:LS(@"Camera"), LS(@"ChooseFromAlbum"), LS(@"Delete"), nil] cancelTitle:LS(@"Cancel") delegate:self];
    actionSheet.tag = kBNActionSheetEditImage;
    [actionSheet show];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    if (indexPath.section == kProjectSectionInfo)
    {
        if (indexPath.row == kProjectInfoType)
        {
            NSArray *options = [NSArray arrayWithObjects:@"product", @"consu", @"service", nil];
            BSOptionViewController *viewController = [[BSOptionViewController alloc] initWithTitle:LS(@"ProjectInfoTypeTitle") options:options selectedstr:self.bsProjectItem.projectType notification:kBSPorjectInfoTypeSelected];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else if (indexPath.row == kProjectInfoPosCategory)
        {
            PosCategoryViewController *viewController = [[PosCategoryViewController alloc] initWithPosCategoryType:kPosCategoryDefault posCategory:self.bsProjectItem.posCategory];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
    else if (indexPath.section == kProjectSectionDetail)
    {
        if (self.editType == kProjectItemEdit || self.editType == kProjectItemCreate)
        {
            if (indexPath.row == kProjectDetailBarCode)
            {
                ;
            }
        }
        else if (self.editType == kProjectTemplateEdit || self.editType == kProjectTemplateCreate)
        {
            if (self.type == kPadBornCategoryCourses || self.type == kPadBornCategoryPackage || self.type == kPadBornCategoryPackageKit)
            {
                if (indexPath.row == kProjectDetailSubItems)
                {
                    SubItemViewController *viewController = [[SubItemViewController alloc] initWithSubItems:self.bsProjectItem.subItems projectType:self.type];
    
                    [self.navigationController pushViewController:viewController animated:YES];
                }
            }
            else if (self.type == kPadBornCategoryProduct || self.type == kPadBornCategoryProject)
            {
                if (self.editType == kProjectTemplateEdit)
                {
                    if (indexPath.row == kTemplateEditDetailTemplate)
                    {
                        AttributeLineViewController *viewController = [[AttributeLineViewController alloc] initWithProjectTemplate:self.projectTemplate attributeLines:self.bsProjectItem.attributeLines];
                        [self.navigationController pushViewController:viewController animated:YES];
                    }
                    else if (indexPath.row == kTemplateEditDetailTemplateList)
                    {
                        TemplateListViewController *viewController = [[TemplateListViewController alloc] initWithProjectTemplate:self.projectTemplate];
                        [self.navigationController pushViewController:viewController animated:YES];
                    }
                    else if (indexPath.row == kTemplateEditDetailConsumable)
                    {
                        ConsumableViewController *viewController = [[ConsumableViewController alloc] initWithConsumables:self.bsProjectItem.consumables];
                        [self.navigationController pushViewController:viewController animated:YES];
                    }
                }
                else if (self.editType == kProjectTemplateCreate)
                {
                    if (indexPath.row == kTemplateCreateDetailTemplate)
                    {
                        AttributeLineViewController *viewController = [[AttributeLineViewController alloc] initWithProjectTemplate:self.projectTemplate attributeLines:self.bsProjectItem.attributeLines];
                        [self.navigationController pushViewController:viewController animated:YES];
                    }
                    else if (indexPath.row == kTemplateCreateDetailTemplateList)
                    {
                        TemplateListViewController *viewController = [[TemplateListViewController alloc] initWithProjectTemplate:self.projectTemplate];
                        [self.navigationController pushViewController:viewController animated:YES];
                    }
                    else if (indexPath.row == kTemplateCreateDetailConsumable)
                    {
                        ConsumableViewController *viewController = [[ConsumableViewController alloc] initWithConsumables:self.bsProjectItem.consumables];
                        [self.navigationController pushViewController:viewController animated:YES];
                    }
                }
            }
        }
    }
}

- (void)didScanButtonClick:(id)sender
{
    if (IS_SDK7)
    {
        BNScanCodeViewController *viewController = [[BNScanCodeViewController alloc] initWithDelegate:self];
        [self.navigationController pushViewController:viewController animated:NO];
    }
}


#pragma mark -
#pragma mark BSSwitchCellDelegate Methods

- (void)didSwitchCellSwitchButtonClick:(BSSwitchCell *)switchCell
{
    NSIndexPath *indexPath = switchCell.indexPath;
    if (indexPath.section == kProjectSectionSwitch)
    {
        if (indexPath.row == kProjectSwitchCanSale)
        {
            self.bsProjectItem.canSale = switchCell.isSwitchOn;
        }
        else if (indexPath.row == kProjectSwitchCanBook)
        {
            self.bsProjectItem.canBook = switchCell.isSwitchOn;
        }
        else if (indexPath.row == kProjectSwitchCanPurchase)
        {
            self.bsProjectItem.canPurchase = switchCell.isSwitchOn;
        }
    }
    else if (indexPath.section == kProjectSectionActive)
    {
        if (indexPath.row == kProjectActiveIsActive)
        {
            self.bsProjectItem.isActive = switchCell.isSwitchOn;
        }
    }
}


#pragma mark -
#pragma mark UITableViewCell refresh Methods

- (void)imageCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIButton *editButton = (UIButton *)[cell.contentView viewWithTag:101];
    if (self.bsProjectItem.projectImage != nil)
    {
        [editButton setBackgroundImage:self.bsProjectItem.projectImage forState:UIControlStateNormal];
        [editButton setBackgroundImage:self.bsProjectItem.projectImage forState:UIControlStateHighlighted];
    }
    else
    {
        [editButton setBackgroundImage:[UIImage imageNamed:@"project_image_add_n"] forState:UIControlStateNormal];
        [editButton setBackgroundImage:[UIImage imageNamed:@"project_image_add_n"] forState:UIControlStateHighlighted];
    }
}

- (void)posCategory:(BSEditCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.bsProjectItem.posCategory.parentName.length == 0)
    {
        cell.contentField.text = self.bsProjectItem.posCategory.categoryName;
    }
    else
    {
        cell.contentField.text = [NSString stringWithFormat:@"%@ / %@", self.bsProjectItem.posCategory.parentName, self.bsProjectItem.posCategory.categoryName];
    }
}

- (UITableViewCell *)templateCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (UIView *subview in cell.contentView.subviews)
    {
        if (subview.tag >= 1000)
        {
            [subview removeFromSuperview];
        }
    }
    
    CGFloat originY = kProjectCommonCellHeight;
    for (int i = 0; i < self.bsProjectItem.attributeLines.count; i++)
    {
        BSAttributeLine *bsAttributeLine = [self.bsProjectItem.attributeLines objectAtIndex:i];
        
        originY += 8.0;
        UILabel *attributeLabel = [[UILabel alloc] initWithFrame:CGRectMake(16.0, originY, IC_SCREEN_WIDTH - 2 * 16.0, 20.0)];
        attributeLabel.backgroundColor = [UIColor clearColor];
        attributeLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
        attributeLabel.font = [UIFont boldSystemFontOfSize:14.0];
        attributeLabel.text = [NSString stringWithFormat:@"%@: ", bsAttributeLine.attributeName];
        attributeLabel.tag = (i + 1) * 1000;
        [cell.contentView addSubview:attributeLabel];
        originY += attributeLabel.frame.size.height + 8.0;
        
        NSInteger rowCount = 0;
        if (bsAttributeLine.attributeValues.count % 3 == 0)
        {
            rowCount = bsAttributeLine.attributeValues.count / 3;
        }
        else
        {
            rowCount = bsAttributeLine.attributeValues.count / 3 + 1;
        }
        
        CGFloat frameWidth = (IC_SCREEN_WIDTH - 4 * 16.0)/3.0;
        for (int j = 0; j < rowCount; j++)
        {
            UIImageView *leftFrameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16.0, originY, frameWidth, 32.0)];
            leftFrameImageView.image = [[UIImage imageNamed:@"attribute_value_label"] imageResizableWithCapInsets:UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0)];
            leftFrameImageView.tag = (i + 1) * 1000 + 3 * j;
            [cell.contentView addSubview:leftFrameImageView];
            
            UILabel *leftTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.0, 0.0, leftFrameImageView.frame.size.width - 2 * 8.0, leftFrameImageView.frame.size.height)];
            leftTitleLabel.backgroundColor = [UIColor clearColor];
            leftTitleLabel.textColor = COLOR(251.0, 123.0, 120.0, 1.0);
            leftTitleLabel.font = [UIFont boldSystemFontOfSize:15.0];
            leftTitleLabel.textAlignment = NSTextAlignmentCenter;
            [leftFrameImageView addSubview:leftTitleLabel];
            
            UIImageView *centerFrameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftFrameImageView.frame.origin.x + leftFrameImageView.frame.size.width + 16.0, originY, frameWidth, 32.0)];
            centerFrameImageView.image = [[UIImage imageNamed:@"attribute_value_label"] imageResizableWithCapInsets:UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0)];
            centerFrameImageView.tag = (i + 1) * 1000 + 3 * j + 1;
            [cell.contentView addSubview:centerFrameImageView];
            
            UILabel *centerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.0, 0.0, centerFrameImageView.frame.size.width - 2 * 8.0, centerFrameImageView.frame.size.height)];
            centerTitleLabel.backgroundColor = [UIColor clearColor];
            centerTitleLabel.textColor = COLOR(251.0, 123.0, 120.0, 1.0);
            centerTitleLabel.font = [UIFont boldSystemFontOfSize:15.0];
            centerTitleLabel.textAlignment = NSTextAlignmentCenter;
            [centerFrameImageView addSubview:centerTitleLabel];
            
            UIImageView *rightFrameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(centerFrameImageView.frame.origin.x + centerFrameImageView.frame.size.width + 16.0, originY, frameWidth, 32.0)];
            rightFrameImageView.image = [[UIImage imageNamed:@"attribute_value_label"] imageResizableWithCapInsets:UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0)];
            rightFrameImageView.tag = (i + 1) * 1000 + 3 * j + 2;
            [cell.contentView addSubview:rightFrameImageView];
            
            UILabel *rightTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.0, 0.0, rightFrameImageView.frame.size.width - 2 * 8.0, rightFrameImageView.frame.size.height)];
            rightTitleLabel.backgroundColor = [UIColor clearColor];
            rightTitleLabel.textColor = COLOR(251.0, 123.0, 120.0, 1.0);
            rightTitleLabel.font = [UIFont boldSystemFontOfSize:15.0];
            rightTitleLabel.textAlignment = NSTextAlignmentCenter;
            [rightFrameImageView addSubview:rightTitleLabel];
            originY += 32.0 + 12.0;
            
            leftFrameImageView.hidden = NO;
            if (j == bsAttributeLine.attributeValues.count / 3)
            {
                if (bsAttributeLine.attributeValues.count % 3 == 1)
                {
                    centerFrameImageView.hidden = YES;
                    rightFrameImageView.hidden = YES;
                }
                else if (bsAttributeLine.attributeValues.count % 3 == 2)
                {
                    centerFrameImageView.hidden = NO;
                    rightFrameImageView.hidden = YES;
                }
                else
                {
                    centerFrameImageView.hidden = NO;
                    rightFrameImageView.hidden = NO;
                }
            }
            else
            {
                centerFrameImageView.hidden = NO;
                rightFrameImageView.hidden = NO;
            }
            
            BSAttributeValue *bsAttributeValue = [bsAttributeLine.attributeValues objectAtIndex:3 * j];
            leftTitleLabel.text = bsAttributeValue.attributeValueName;
            if (!centerFrameImageView.hidden)
            {
                BSAttributeValue *bsAttributeValue = [bsAttributeLine.attributeValues objectAtIndex:3 * j + 1];
                centerTitleLabel.text = bsAttributeValue.attributeValueName;
            }
            
            if (!rightFrameImageView.hidden)
            {
                BSAttributeValue *bsAttributeValue = [bsAttributeLine.attributeValues objectAtIndex:3 * j + 2];
                rightTitleLabel.text = bsAttributeValue.attributeValueName;
            }
        }
    }
    
    return cell;
}

- (void)consumableCell:(BSEditCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.bsProjectItem.consumables.count != 0)
    {
        cell.contentField.text = [NSString stringWithFormat:LS(@"ConsumableNum"), self.bsProjectItem.consumables.count];
    }
    else
    {
        cell.contentField.text = @"";
    }
}

- (void)subItemCell:(BSEditCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.bsProjectItem.subItems.count != 0)
    {
        cell.contentField.text = [NSString stringWithFormat:LS(@"SubItemsNum"), self.bsProjectItem.subItems.count];
    }
    else
    {
        cell.contentField.text = @"";
    }
}


#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSInteger section = textField.tag / 100;
    NSInteger row = textField.tag % 100;
    if (section == kProjectSectionInfo)
    {
        if (row == kProjectInfoPrice)
        {
            if (textField.text.floatValue == 0.0)
            {
                textField.text = @"";
            }
        }
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger section = textField.tag / 100;
    NSInteger row = textField.tag % 100;
    if (section == kProjectSectionInfo)
    {
        if (row == kProjectInfoName)
        {
            self.bsProjectItem.projectName = textField.text;
        }
        else if (row == kProjectInfoPrice)
        {
            self.bsProjectItem.projectPrice = textField.text.floatValue;
            [self.projectTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:row inSection:section], nil] withRowAnimation:UITableViewRowAnimationFade];
            if (textField.text.floatValue != 0)
            {
                bPriceIsEdit = TRUE;
            }
        }
    }
    else if (section == kProjectSectionDetail)
    {
        if (row == kProjectDetailInternalNum)
        {
            self.bsProjectItem.defaultCode = textField.text;
        }
    }
}


#pragma mark -
#pragma mark BNActionSheetDelegate Methods

- (void)bnActionSheet:(BNActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == kBNActionSheetEditImage)
    {
        switch (buttonIndex)
        {
            case 0:
            {
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                {
                    if (self.cameraPicker == nil)
                    {
                        self.cameraPicker = [[BSCameraPickerController alloc] initWithBSDelegate:self];
                    }
                    [self presentViewController:self.cameraPicker animated:YES completion:nil];
                }
            }
                break;
                
            case 1:
            {
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
                {
                    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    imagePicker.delegate = self;
                    imagePicker.allowsEditing = NO;
                    [self presentViewController:imagePicker animated:YES completion:nil];
                }
            }
                break;
                
            case 2:
            {
                if (self.bsProjectItem.projectImage != nil)
                {
                    self.bsProjectItem.isImageEdit = YES;
                    self.bsProjectItem.projectImage = nil;
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:kProjectImageEdit inSection:kProjectSectionImage];
                    UITableViewCell *cell = [self.projectTableView cellForRowAtIndexPath:indexPath];
                    [self imageCell:cell cellForRowAtIndexPath:indexPath];
                }
            }
                break;
                
            default:
                break;
        }
    }
    else if (actionSheet.tag == kBNActionSheetSaveModify)
    {
        switch (buttonIndex)
        {
            case 0:
            {
                [self didProjectItemEditRequest];
            }
                break;
                
            case 1:
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
                
            default:
                break;
        }
    }
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate Methods

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    picker = nil;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    AlbumViewController *viewController = [[AlbumViewController alloc] initWithAlbumImage:[image orientation] delegate:self];
    [self.navigationController pushViewController:viewController animated:NO];
}


#pragma mark -
#pragma mark AlbumViewControllerDelegate Methods

- (void)didAlbumImageEditFinished:(UIImage *)image
{
    self.bsProjectItem.isImageEdit = YES;
    self.bsProjectItem.projectImage = image;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:kProjectImageEdit inSection:kProjectSectionImage];
    UITableViewCell *cell = [self.projectTableView cellForRowAtIndexPath:indexPath];
    [self imageCell:cell cellForRowAtIndexPath:indexPath];
}


#pragma mark -
#pragma mark BSCameraPickerControllerDelegate Methods

- (void)didCameraImagePickerFinished:(UIImage *)image
{
    self.bsProjectItem.isImageEdit = YES;
    self.bsProjectItem.projectImage = image;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:kProjectImageEdit inSection:kProjectSectionImage];
    UITableViewCell *cell = [self.projectTableView cellForRowAtIndexPath:indexPath];
    [self imageCell:cell cellForRowAtIndexPath:indexPath];
}


#pragma mark -
#pragma mark QRCodeViewDelegate Methods

- (void)didQRBackButtonClick:(QRCodeView *)qrCodeView
{
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}


#pragma mark -
#pragma mark BNScanCodeDelegate Methods

- (void)scanCodeViewController:(BNScanCodeViewController *)viewController didScanSuccess:(NSString *)result
{
    self.bsProjectItem.barcode = result;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:kProjectDetailBarCode inSection:kProjectSectionDetail];
    BSEditCell *cell = (BSEditCell *)[self.projectTableView cellForRowAtIndexPath:indexPath];
    cell.contentField.text = result;
}


#pragma mark -
#pragma mark ZXingDelegate Methods


@end
