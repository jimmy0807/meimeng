//
//  productCategoryLeftController.m
//  Boss
//
//  Created by jiangfei on 16/5/18.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ProductCategoryLeftController.h"
#import "rightNaviTitleView.h"
#import "CategoryLeftCell.h"
#import "BSCoreDataManager.h"
#import "rightModel.h"
/**
 *  产品分类左边的控制器tableView被点击
 *
 */
#define productProjectLeftTableViewClickNotification @"productProjectLeftTableViewClickNotification"
/**
 *  产品分类左边tableView被点击的
 */
#define productProjectLeftTalbeViewClickWithCategory @"productProjectLeftTalbeViewClickWithCategory"

@interface ProductCategoryLeftController()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *categoryArray;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) NSInteger otherCount;

@property (nonatomic, assign) NSInteger selectedIdx;
@end

@implementation ProductCategoryLeftController
//cell标识
static NSString *cellId = @"cellLeft";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.noKeyboardNotification = true;
    self.view.backgroundColor = COLOR(245, 245, 245, 1);
    self.selectedIdx = -1;
    [self initTableView];
}

- (void)setBornCategory:(CDBornCategory *)bornCategory
{
    if (_bornCategory != bornCategory) {
        _bornCategory = bornCategory;
         self.selectedIdx = -1;
    }
    self.categoryArray = [[BSCoreDataManager currentManager] fetchTopProjectCategory];
    
    self.otherCount = [[BSCoreDataManager currentManager] fetchProjectTemplatesWithBornCategorys:@[bornCategory.code] categoryIds:@[[NSNumber numberWithInteger:0]] keyword:nil priceAscending:NO].count;
    self.totalCount = [[BSCoreDataManager currentManager] fetchProjectTemplatesWithBornCategorys:@[bornCategory.code] categoryIds:nil keyword:nil priceAscending:NO].count;
    [self.tableView reloadData];
   

}

#pragma mark 初始化tableView
- (void)initTableView
{
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CategoryLeftCell" bundle:nil] forCellReuseIdentifier:@"CategoryLeftCell"];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categoryArray.count + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryLeftCell"];
  
//    cell.selectionStyle = (indexPath.row == 0)?UITableViewCellSelectionStyleNone:UITableViewCellSelectionStyleDefault;
    
    if (indexPath.row == 0) {
        cell.titleNameView.text = @"全部";
        cell.titleCountView.text = [NSString stringWithFormat:@"%d",self.totalCount];
    }
    else if (indexPath.row == self.categoryArray.count + 1)
    {
        cell.titleNameView.text = @"其它";
        cell.titleCountView.text = [NSString stringWithFormat:@"%d",self.otherCount];
    }
    else
    {
        cell.category = [self.categoryArray objectAtIndex:indexPath.row - 1];
    }
    
    if (self.selectedIdx == indexPath.row) {
        cell.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        cell.backgroundColor = COLOR(245, 245, 245, 1);
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedIdx == indexPath.row) {
        return;
    }
    CDProjectCategory *category = nil;
    NSArray *categoryIds = nil;
    if (indexPath.row == 0) {
        NSLog(@"全部");
    }
    else if (indexPath.row == self.categoryArray.count + 1)
    {
        NSLog(@"其它");
        categoryIds = @[[NSNumber numberWithInteger:0]];
//        NSArray *items = [[BSCoreDataManager currentManager] fetchProjectTemplatesWithBornCategorys:@[self.bornCategory.code] categoryIds:@[[NSNumber numberWithInteger:0]] keyword:nil priceAscending:NO];
        NSLog(@"----");

    }
    else
    {
        category = [self.categoryArray objectAtIndex:indexPath.row - 1];
        categoryIds = [self subCategoryIds:category];
    }
    self.selectedIdx = indexPath.row;
    [self.tableView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(didSelectedLeftCategory:categoryIds:)]) {
        [self.delegate didSelectedLeftCategory:category categoryIds:categoryIds];
    }
    
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

@end
