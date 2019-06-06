//
//  productCategoryController.m
//  Boss
//
//  Created by jiangfei on 16/6/7.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ProductCategoryController.h"
#import "AddCategoryController.h"
#import "CDProjectCategory+CoreDataClass.h"
#import "BSCoreDataManager.h"
#import "CategoryCell.h"
#import "AddCategoryController.h"

#define kLeftTableView   101
#define kRightTableView  102

@interface ProductCategoryController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *compleBtn;

@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@property (weak, nonatomic) IBOutlet UIButton *addLargeBtn;
@property (weak, nonatomic) IBOutlet UIButton *addSmallBtn;

/** 大分类数据*/
@property (nonatomic,strong)NSArray *topCategoryArray;
/** 小分类数据*/
@property (nonatomic,strong)NSArray *subCategoryArray;



/** indexPath*/
@property (nonatomic,strong)NSIndexPath *seletedIndexPath;
@end

@implementation ProductCategoryController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *backItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    backItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backItem;
    
    BNRightButtonItem *rightBtnItem = [[BNRightButtonItem alloc] initWithTitle:@"完成"];
    rightBtnItem.delegate = self;
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
    self.title = @"选择分类";
    
    [self initTableView];
    
    [self registerNofitificationForMainThread:kBSPosCategoryCreateResponse];
  
}

#pragma mark - initTableView
-(void)initTableView
{
    [self.leftTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"leftCell"];
 
    [self.rightTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"rightCell"];
    self.rightTableView.tableFooterView = [[UIView alloc] init];
    
    self.leftTableView.tag = kLeftTableView;
    self.rightTableView.tag = kRightTableView;

    [self reloadLeftTableView];
}


- (void)reloadLeftTableView
{
    self.topCategoryArray = [[BSCoreDataManager currentManager] fetchAllTopProjectCategory];
    [self.leftTableView reloadData];
}

- (void)reloadRightTableView
{
    self.subCategoryArray = self.topCategory.subCategory.array;
    [self.rightTableView reloadData];
}

- (void)setTopCategory:(CDProjectCategory *)topCategory
{
    if (_topCategory && _topCategory.categoryID.integerValue == topCategory.categoryID.integerValue) {
        return;
    }
    if (_topCategory) {
        self.subCategory = nil;
    }
    _topCategory = topCategory;

    [self reloadRightTableView];
}

#pragma mark - BNRightButtonItemDelegate
- (void)didRightBarButtonItemClick:(id)sender
{
    CDProjectCategory *category = nil;
    if (self.subCategory) {
        category = self.subCategory;
    }
    else if (self.topCategory) {
        category = self.topCategory;
    }
    
    if ([self.delegate respondsToSelector:@selector(didSelectedCategory:)]) {
        [self.delegate didSelectedCategory:category];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - receivedNotification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSPosCategoryCreateResponse]) {
        if ([[notification.userInfo numberValueForKey:@"rc"] integerValue] == 0) {
            [self reloadLeftTableView];
            [self reloadRightTableView];
        }
    }
}


#pragma mark - UITableViewDataSouce
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == kLeftTableView)
    {
        return self.topCategoryArray.count;
    }
    else
    {
        return self.subCategoryArray.count;
    }
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag == kLeftTableView)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        CDProjectCategory *category = self.topCategoryArray[indexPath.row];
        cell.textLabel.font = projectContentFont;
        cell.textLabel.text = category.categoryName;
        if (self.topCategory && self.topCategory.categoryID.integerValue == category.categoryID.integerValue) {
            cell.backgroundColor = [UIColor whiteColor];
        }
        else
        {
            cell.backgroundColor = [UIColor clearColor];
        }
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rightCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CDProjectCategory *category = self.subCategoryArray[indexPath.row];
        cell.textLabel.font = projectContentFont;
        cell.textLabel.text = category.categoryName;
        
        if (self.subCategory && self.subCategory.categoryID.integerValue == category.categoryID.integerValue) {
            cell.backgroundColor = [UIColor lightGrayColor];
        }
        else
        {
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == kLeftTableView) {
        CDProjectCategory *category = self.topCategoryArray[indexPath.row];
        if (category.categoryID.integerValue == self.topCategory.categoryID.integerValue) {
            return;
        }
        self.topCategory  = category;
        [self.leftTableView reloadData];
    }
    else
    {
        CDProjectCategory *category = self.subCategoryArray[indexPath.row];
        if (category.categoryID.integerValue == self.subCategory.categoryID.integerValue) {
            return;
        }

        self.subCategory = category;
        [self.rightTableView reloadData];
        
        
    }
}

//#pragma mark 完成按钮被点击
//- (IBAction)finish:(UIButton *)sender {
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[@"bigCategory"] = self.seletedCategory;
//    dict[@"smallCategory"] = self.seletedSmallCategory;
//    dict[@"tage"] = @(self.tage);
//    [myNotification postNotificationName:productCategoryCompele object:nil userInfo:dict];
//    [self.navigationController popViewControllerAnimated:YES];
//}

#pragma mark 新增大分类
- (IBAction)addLargeCategory:(UIButton *)sender {
    AddCategoryController *addCategoryVC = [[AddCategoryController alloc] init];
    [self.navigationController pushViewController:addCategoryVC animated:YES];
}

#pragma mark 新增小分类
- (IBAction)addSomllCategory:(UIButton *)sender {
    AddCategoryController *addCategoryVC = [[AddCategoryController alloc] init];
    addCategoryVC.parentCategory = self.topCategory;
    [self.navigationController pushViewController:addCategoryVC animated:YES];
    
}

@end
