//
//  productCategoryRightController.m
//  Boss
//
//  Created by jiangfei on 16/5/18.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ProductCategoryRightController.h"
#import "UIBarButtonItem+JFExtension.m"
#import "ProductCategorySubRightController.h"
#import "rightNaviTitleView.h"
#import "CDProjectCategory+CoreDataClass.h"
#import "rightModel.h"
#import "CategoryRightCell.h"
/**
 *  产品分类左边的控制器tableView被点击
 *
 */
#define productProjectLeftTableViewClickNotification @"productProjectLeftTableViewClickNotification"
/**
 *  产品分类左边tableView被点击的
 */
#define productProjectLeftTalbeViewClickWithCategory @"productProjectLeftTalbeViewClickWithCategory"
/**
 *  通知
 */
#define  mainNotification  [NSNotificationCenter defaultCenter]
@interface ProductCategoryRightController ()<UITableViewDelegate,UITableViewDataSource>
/** naivView*/
@property (nonatomic,weak)rightNaviTitleView *naviView;
/** tableView*/
@property (nonatomic,strong)UITableView *tableView;
/**存放category(数据库里的数据)*/

/** 右边的tableView数据*/
@property (nonatomic,strong)NSMutableArray *rightArray;
/** subRightController*/
@property (nonatomic,strong)ProductCategorySubRightController *subRigthController;
/** category*/
@property (nonatomic,strong)CDProjectCategory *rightCategory;

@property (nonatomic, strong) NSArray *categoryArray;

@property (nonatomic, assign) NSInteger selectedIdx;

@end

@implementation ProductCategoryRightController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加控件
//    [self naviView];
    self.noKeyboardNotification = true;
    [self initTableView];
    self.view.backgroundColor =[UIColor whiteColor];
    self.navigationController.navigationBar.hidden = true;
    
    self.selectedIdx = -1;

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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CategoryRightCell" bundle:nil] forCellReuseIdentifier:@"CategoryRightCell"];
}


- (void)reloadData
{
    
}

- (void)setBornCategory:(CDBornCategory *)bornCategory
{
    if (_bornCategory != bornCategory) {
        _bornCategory = bornCategory;
        self.parentCategory = nil;
        self.selectedIdx = -1;
    }
    else
    {
        [self.tableView reloadData];
    }
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.categoryArray.count > 0) {
        return self.categoryArray.count + 1;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CategoryRightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryRightCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"全部";
        cell.countLabel.text = [NSString stringWithFormat:@"%d",self.totalCount];
    }
    else
    {
        CDProjectCategory *category = [self.categoryArray objectAtIndex:indexPath.row - 1];
        cell.titleLabel.text = category.categoryName ;
        cell.countLabel.text = [NSString stringWithFormat:@"%d",category.itemCount.integerValue];
    }
    
    UIImageView *backgroundView = [[UIImageView alloc] init];
    if (self.selectedIdx == indexPath.row) {
        backgroundView.image = [UIImage imageNamed:@"project_sub_category_cell_h.png"];
    }
    else
    {
        backgroundView.image = [UIImage imageNamed:@"project_sub_category_cell_n.png"];
    }
    cell.backgroundView = backgroundView;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.selectedIdx == indexPath.row) {
        return;
    }
    CDProjectCategory *category;
    BOOL hide;
    NSArray *items;
    NSArray *categoryIds = nil;
    if (indexPath.row == 0) {
        NSLog(@"全部");
        hide = true;
        categoryIds = [self subCategoryIds:self.parentCategory];
    }
    else
    {
        category = [self.categoryArray objectAtIndex:indexPath.row - 1];
        
        categoryIds = [self subCategoryIds:category];

        NSArray *subCategorys = [self getSubCategoryWithCategory:category];
        
        if (subCategorys.count == 0) {
            hide = true;
        }
        else
        {
            hide = false;
            items = [[BSCoreDataManager currentManager] fetchProjectTemplatesWithBornCategorys:@[self.bornCategory.code] categoryIds:categoryIds keyword:nil priceAscending:NO];
            ProductCategoryRightController *subRightVC = [[ProductCategoryRightController alloc] init];
            self.totalCount = items.count;
            subRightVC.parentCategory = category;
            [self.navigationController pushViewController:subRightVC animated:YES];
        }
    }
    
    self.selectedIdx = indexPath.row;
    [self.tableView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(didSelectedRightCategory:categoryIds:hide:)]) {
        [self.delegate didSelectedRightCategory:category categoryIds:categoryIds hide:hide];
    }
}


#pragma mark 根据category获取子菜单的数据数组
- (NSArray *)subCategoryIds:(CDProjectCategory *)category{
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


#pragma mark - 设置导航栏
#pragma mark 初始化导航View
-(rightNaviTitleView *)naviView
{
    if (!_naviView) {
        rightNaviTitleView *titleView = [rightNaviTitleView buttonWithType:UIButtonTypeCustom];
        titleView.frame = CGRectMake(0, 0, IC_SCREEN_WIDTH/2, 44);
        [titleView addTarget:self action:@selector(pushSubRightControll:) forControlEvents:UIControlEventTouchUpInside];
        _naviView = titleView;
        [self.view addSubview:_naviView];
    }
    
    return _naviView;
}

#pragma mark 隐藏导航栏的bar
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    self.navigationController.navigationBarHidden = YES;
}


- (void)setParentCategory:(CDProjectCategory *)parentCategory
{
    _parentCategory = parentCategory;
    self.selectedIdx = -1;
    self.categoryArray = [self getSubCategoryWithCategory:parentCategory];
    [self.tableView reloadData];
}


- (NSArray *)getSubCategoryWithCategory:(CDProjectCategory*)category
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemCount != %@", [NSNumber numberWithInteger:0]];

    return [category.subCategory.array filteredArrayUsingPredicate:predicate];
}


@end
