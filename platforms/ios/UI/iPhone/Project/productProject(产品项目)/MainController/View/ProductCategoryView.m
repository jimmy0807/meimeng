//
//  ProductCategoryView.m
//  ds
//
//  Created by lining on 2016/10/21.
//
//

#import "ProductCategoryView.h"
#import "ProductCategoryLeftController.h"
#import "ProductCategoryRightController.h"

@interface ProductCategoryView ()<CategoryLeftControllerDelegate,CategoryRightControllerDelegate>{
    BOOL isShowing;
}
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UIButton *bgBtn;

@property (nonatomic, strong) ProductCategoryLeftController *leftCategoryVC;
@property (nonatomic, strong) ProductCategoryRightController *rightCategoryVC;

@end

@implementation ProductCategoryView

+ (instancetype)createView
{
    ProductCategoryView *categoryView = [[ProductCategoryView alloc] init];

    return categoryView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubView];
    }
    
    return self;
}

- (void)initSubView
{
    self.bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bgBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    
    self.bgBtn.backgroundColor = [UIColor blackColor];
    self.bgBtn.alpha = 0.6;
    [self addSubview:self.bgBtn];
    [self.bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    
    
    self.menuView = [[UIView alloc] init];
    [self addSubview:self.menuView];
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.leading.offset(0);
        make.trailing.offset(0);
        make.height.equalTo(self.mas_height).multipliedBy(3/5.0);
    }];
    
    self.menuView.backgroundColor = [UIColor clearColor];
    
    
    self.leftCategoryVC = [[ProductCategoryLeftController alloc] init];
    self.leftCategoryVC.view.backgroundColor = COLOR(245, 245, 245, 1);
    self.leftCategoryVC.delegate = self;
    [self.menuView addSubview:self.leftCategoryVC.view];
    
    
    self.rightCategoryVC = [[ProductCategoryRightController alloc] init];
    self.rightCategoryVC.delegate = self;
    UINavigationController *rightCategoryNavigationVC = [[UINavigationController alloc] initWithRootViewController:self.rightCategoryVC];
    [self.menuView addSubview:rightCategoryNavigationVC.view];
    
    self.rightCategoryVC.view.backgroundColor = [UIColor whiteColor];
    
    [self.leftCategoryVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.leading.offset(0);
        //        make.trailing.offset(0);
        make.width.equalTo(rightCategoryNavigationVC.view.mas_width);
    }];
    
    [rightCategoryNavigationVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.leftCategoryVC.view.mas_trailing);
        make.top.offset(0);
        make.bottom.offset(0);
        make.trailing.offset(0);
    }];
    
    self.hidden = true;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initSubView];
}




#pragma mark - reload view & data

- (void)setBornCategory:(CDBornCategory *)bornCategory
{
    _bornCategory = bornCategory;
    [self reloadView];
    [self performSelectorInBackground:@selector(initCategorys) withObject:nil];
}


- (void)reloadView
{
    self.leftCategoryVC.bornCategory = self.bornCategory;
    self.rightCategoryVC.bornCategory = self.bornCategory;
}

- (void)initCategorys
{
    NSArray *allItems = [[BSCoreDataManager currentManager] fetchAllProjectItem];
    NSArray *categorys = [[BSCoreDataManager currentManager] fetchAllProjectCategory];
    
    if (allItems.count == 0)
    {
        for (int i = 0; i < categorys.count; i++)
        {
            CDProjectCategory *category = [categorys objectAtIndex:i];
            category.itemCount = [NSNumber numberWithInteger:0];
        }
        [[BSCoreDataManager currentManager] save:nil];
        
        [self performSelectorOnMainThread:@selector(reloadView) withObject:nil waitUntilDone:YES];
        return;
    }
    
    for (int i = 0; i < categorys.count; i++)
    {
        CDProjectCategory *category = [categorys objectAtIndex:i];
        
        NSArray *categoryIds = [self subCategoryIds:category];
        
        NSArray *items = [[BSCoreDataManager currentManager] fetchProjectTemplatesWithBornCategorys:@[self.bornCategory.code] categoryIds:categoryIds keyword:nil priceAscending:NO];
        category.itemCount = [NSNumber numberWithInteger:items.count];
        
//        NSLog(@"categoryIds: (%@)  itemCount: %d",[categoryIds componentsJoinedByString:@","],category.itemCount.integerValue);
        
        //        if (self.controllerType == ProductControllerType_Default)
        //        {
        //
        //        }
        //        else
        //        {
        //            NSArray *items = [[BSCoreDataManager currentManager] fetchProjectItemsWithType:kProjectItemDefault bornCategorys:@[bornCategory.code] categoryIds:categoryIds existItemIds:nil keyword:nil priceAscending:NO];
        //            category.itemCount = [NSNumber numberWithInteger:items.count];
        //        }
    }
    
    [[BSCoreDataManager currentManager] save:nil];
    [self performSelectorOnMainThread:@selector(reloadView) withObject:nil waitUntilDone:YES];
}


- (NSArray *)subCategoryIds:(CDProjectCategory *)category
{
    NSMutableArray *ids = [NSMutableArray array];
    [ids addObject:category.categoryID];
    for (int i = 0; i < category.subCategory.count; i++)
    {
        CDProjectCategory *subCategory = [category.subCategory objectAtIndex:i];
        NSArray *subIds = [self subCategoryIds:subCategory];
        [ids addObjectsFromArray:subIds];
    }
    
    return  [NSArray arrayWithArray:ids];
}

#pragma mark - show & hide
- (void)show
{
    if (isShowing) {
        return;
    }
    isShowing = true;
    self.hidden = false;
    self.bgBtn.alpha = 0.0;
    NSLog(@"show");
    [self.menuView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.leading.offset(0);
        make.trailing.offset(0);
        make.height.equalTo(self.mas_height).multipliedBy(3/5.0);
        
    }];
//     self.bgBtn.alpha = 0.6;
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
        self.bgBtn.alpha = 0.6;
    } completion:^(BOOL finished) {
    
    }];
}

- (void)hide
{
    NSLog(@"hide");
    if (!isShowing) {
        return;
    }
    isShowing = false;
    [self.menuView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(0);
        make.trailing.offset(0);
        make.bottom.equalTo(self.mas_top).offset(0);
        make.height.equalTo(self.mas_height).multipliedBy(3/5.0);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
        self.bgBtn.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.hidden = true;
    }];
}

#pragma mark - CategoryLeftControllerDelegate

- (void)didSelectedLeftCategory:(CDProjectCategory *)category categoryIds:(NSArray *)categoryIds
{
    if ([self getSubCategoryWithCategory:category].count == 0) {
        [self hide];
    }
    else
    {
        NSArray *items = [[BSCoreDataManager currentManager] fetchProjectTemplatesWithBornCategorys:@[self.bornCategory.code] categoryIds:categoryIds keyword:nil priceAscending:NO];
        self.rightCategoryVC.totalCount = items.count;
        self.rightCategoryVC.parentCategory = category;
    }
    if ([self.delegate respondsToSelector:@selector(didSelectedCategoryWithCategoryIds:)]) {
        [self.delegate didSelectedCategoryWithCategoryIds:categoryIds];
    }
}

#pragma mark - CategoryRightControllerDelegate
- (void)didSelectedRightCategory:(CDProjectCategory *)category categoryIds:(NSArray *)categoryIds hide:(BOOL)hide
{
    if (hide) {
        [self hide];
    }
    if ([self.delegate respondsToSelector:@selector(didSelectedCategoryWithCategoryIds:)]) {
        [self.delegate didSelectedCategoryWithCategoryIds:categoryIds];
    }
}


- (NSArray *)getSubCategoryWithCategory:(CDProjectCategory*)category
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemCount != %@", [NSNumber numberWithInteger:0]];
    
    return [category.subCategory.array filteredArrayUsingPredicate:predicate];
}



@end
