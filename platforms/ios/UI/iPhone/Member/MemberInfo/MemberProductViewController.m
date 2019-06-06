//
//  MemberProductViewController.m
//  Boss
//
//  Created by lining on 16/5/12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberProductViewController.h"
#import "BSFetchMemberCardProjectRequest.h"
#import "CBLoadingView.h"
#import "MemberCardCell.h"

typedef enum TableType
{
    TableType_category = 1,
    TableType_date,
    TableType_price,
}TableType;

typedef enum PriceStatus
{
    PriceStatus_defalut,    //无
    PriceStatus_up,         //由低到高
    PriceStatus_down        //由高到低
}PriceStatus;

@interface MemberProductViewController ()
{
    
}
@property (nonatomic, assign) TableType currentType;
@property (nonatomic, assign) PriceStatus status;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *categorySections;
@property (nonatomic, strong) NSArray *sortCategoryArray;
@property (nonatomic, strong) NSMutableDictionary *categoryProductIDS;
@property (nonatomic, strong) NSMutableDictionary *categoryProductDict;
@property (nonatomic, strong) NSFetchedResultsController *categoryResultsController;
@property (nonatomic, strong) NSFetchedResultsController *dateResultesController;
@end

@implementation MemberProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *leftItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    leftItem.delegate = self;
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.navigationItem.title = @"购买的产品";
    
    self.currentType = TableType_category;
    
    [self sendRequest];
    [self registerNofitificationForMainThread:kBSFetchMemberCardProjectResponse];
    
    [self reloadData];
//    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - reload data
- (void)reloadData
{
    self.dataArray = [self fetchMemberProductesSortByPriceAscending:true];
    
    
    self.categoryResultsController = [[BSCoreDataManager currentManager] fetchMemberProductCategoryWithMemberID:self.member.memberID];
    
    
    self.categorySections = [NSMutableArray array];
    self.categoryProductDict = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    self.categoryProductIDS = [NSMutableDictionary dictionary];
    for (CDMemberCardProject *project in self.categoryResultsController.fetchedObjects) {
        NSMutableDictionary* dict = [mDict objectForKey:project.section_category];
        
        NSMutableArray *dictArray = [self.categoryProductDict objectForKey:project.section_category];
        if (dictArray == nil) {
            dictArray = [NSMutableArray array];
            [self.categoryProductDict setObject:dictArray forKey:project.section_category];
            [self.categorySections addObject:project.section_category];
        }
        
        if (dict == nil) {
            dict = [NSMutableDictionary dictionary];
            [mDict setObject:dict forKey:project.section_category];
//            [self.categorySections addObject:project.section_category];
        }
        
    
        NSMutableDictionary *itemDict = [dict objectForKey:project.projectID];
        
        if (itemDict == nil) {
            itemDict = [NSMutableDictionary dictionary];
            [dict setObject:itemDict forKey:project.projectID];
            [itemDict setObject:project.projectName forKey:@"name"];
            
            [dictArray addObject:itemDict];
//            [self.idArray addObject:project.projectID];
//            [self.dictArray]
        }
        NSInteger count = [[itemDict objectForKey:@"count"] integerValue];
        count += [project.purchaseQty integerValue];
        [itemDict setObject:@(count) forKey:@"count"];
        
        CGFloat totalMoney = [[itemDict objectForKey:@"total"] floatValue];
        totalMoney += [project.projectTotalPrice floatValue];
        [itemDict setObject:@(totalMoney) forKey:@"total"];
    }
    

//    for (NSArray *dictArray in self.categoryProductDict) {
//        [dictArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
////            NSDictionary *dict1 = obj1;
////            NSDictionary *dict2 = obj2;
//            NSInteger count1 = [[obj1 objectForKey:@"count"] integerValue];
//            NSInteger count2 = [[obj2 objectForKey:@"count"] integerValue];
//            return count1 > count2;
//        }];
//    }
    
    self.dateResultesController = [[BSCoreDataManager currentManager] fetchMemberProductDateWithMemberID:self.member.memberID];
    
    [self.tableView reloadData];
}

- (NSArray *)fetchMemberProductesSortByPriceAscending:(BOOL)ascending
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"member_id = %@",self.member.memberID];
    NSArray *dataArray = [[BSCoreDataManager currentManager] fetchItems:@"CDMemberCardProject" sortedByKey:@"projectTotalPrice" ascending:ascending predicate:predicate];
    return dataArray;
}


#pragma mark - send request
- (void)sendRequest
{
    BSFetchMemberCardProjectRequest *request = [[BSFetchMemberCardProjectRequest alloc] initWithMember:self.member];
    [request execute];
    
    [[CBLoadingView shareLoadingView] show];
}

#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSFetchMemberCardProjectResponse]) {
        [[CBLoadingView shareLoadingView] hide];
        if ([[notification.userInfo numberValueForKey:@"rc"] integerValue] == 0) {
            [self reloadData];
        }
    }
}

#pragma mark - type & status
- (void)setCurrentType:(TableType)currentType
{
    if (_currentType == currentType) {
        if (_currentType == TableType_price) {
            self.status = self.status%2 + 1;
        }
        return;
    }
    _currentType = currentType;
    
    self.productBtn.selected = false;
    self.dateBtn.selected = false;
    self.priceBtn.selected = false;
    self.status = PriceStatus_defalut;
    if (currentType == TableType_category)
    {
        self.productBtn.selected = true;
    }
    else if (currentType == TableType_date)
    {
        self.dateBtn.selected = true;
    }
    else if (currentType == TableType_price)
    {
        self.priceBtn.selected = true;
        self.status = PriceStatus_up;
    }
    [self.tableView reloadData];
}

- (void)setStatus:(PriceStatus)status
{
    _status = status;
    if (status == PriceStatus_defalut) {
        self.priceImgView.image = [UIImage imageNamed:@"member_price_sort_default.png"];
    }
    else if (status == PriceStatus_up)
    {
        self.priceImgView.image = [UIImage imageNamed:@"member_price_sort_up.png"];
        self.dataArray = [self fetchMemberProductesSortByPriceAscending:true];
        [self.tableView reloadData];
    }
    else if (status == PriceStatus_down)
    {
        self.priceImgView.image = [UIImage imageNamed:@"member_price_sort_down.png"];
        self.dataArray = [self fetchMemberProductesSortByPriceAscending:false];
        [self.tableView reloadData];
    }
}

#pragma mark - Button Action
- (IBAction)topBtnPressed:(id)sender {
    int type = ((UIButton *)sender).tag - 100;
    self.currentType = type;
    
    if (type == TableType_price) {
        
    }
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.currentType == TableType_category) {
//        return self.categoryResultsController.sections.count;
        return self.categorySections.count;
    }
    else if (self.currentType == TableType_date)
    {
        return self.dateResultesController.sections.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.currentType == TableType_category) {
//        id<NSFetchedResultsSectionInfo> sectionInfo = self.categoryResultsController.sections[section];
//        return [sectionInfo numberOfObjects];
        NSArray *dictArray = [self.categoryProductDict objectForKey:[self.categorySections objectAtIndex:section]];
        return dictArray.count;
    }
    else if (self.currentType == TableType_date)
    {
        id<NSFetchedResultsSectionInfo> sectionInfo = self.dateResultesController.sections[section];
        return [sectionInfo numberOfObjects];
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    MemberCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCardCell"];
    if (cell == nil) {
        cell = [MemberCardCell createCell];
        cell.valueLabel.font = [UIFont systemFontOfSize:17];
        cell.valueLabel.textColor = [UIColor blackColor];
        //        self.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        cell.titleLabel.textColor = COLOR(72.0, 72.0, 72.0, 1.0);
    }
    cell.arrowImgViewHidden = true;
    CDMemberCardProject *product;
    if (self.currentType == TableType_category) {
        product = [self.categoryResultsController objectAtIndexPath:indexPath];
        
        NSArray *dictArray = [self.categoryProductDict objectForKey:[self.categorySections objectAtIndex:indexPath.section]];
        
         NSArray *sortArray = [dictArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        //            NSDictionary *dict1 = obj1;
        //            NSDictionary *dict2 = obj2;
                    NSInteger count1 = [[obj1 objectForKey:@"count"] integerValue];
                    NSInteger count2 = [[obj2 objectForKey:@"count"] integerValue];
                    return count1 < count2;
                }];
    NSDictionary *itemDict = [sortArray objectAtIndex:indexPath.row];
        cell.titleLabel.text = [itemDict objectForKey:@"name"];
        cell.valueLabel.text = [NSString stringWithFormat:@"￥%.2f",[[itemDict objectForKey:@"total"] floatValue]];
//        [NSDictionary dictionary]
        cell.countLabel.text = @"";
        cell.detailLabel.text = [NSString stringWithFormat:@"%@个",[itemDict objectForKey:@"count"]];
    }
    else if (self.currentType == TableType_date)
    {
        product = [self.dateResultesController objectAtIndexPath:indexPath];
        cell.titleLabel.text = product.projectName;
        cell.detailLabel.text = product.create_date;
        cell.countLabel.text = [NSString stringWithFormat:@"x%@",product.purchaseQty];
        cell.valueLabel.text = [NSString stringWithFormat:@"￥%.2f",[product.projectTotalPrice floatValue]];
    }
    else if (self.currentType == TableType_price)
    {
        product = [self.dataArray objectAtIndex:indexPath.row];
        cell.titleLabel.text = product.projectName;
        cell.detailLabel.text = product.create_date;
        cell.countLabel.text = [NSString stringWithFormat:@"x%@",product.purchaseQty];
        cell.valueLabel.text = [NSString stringWithFormat:@"￥%.2f",[product.projectTotalPrice floatValue]];
        cell.arrowImgViewHidden = true;
    }
    
//    cell.titleLabel.text = product.projectName;
//    cell.detailLabel.text = product.create_date;
//    cell.countLabel.text = [NSString stringWithFormat:@"x%@",product.purchaseQty];
//    cell.valueLabel.text = [NSString stringWithFormat:@"￥%.2f",[product.projectTotalPrice floatValue]];
//    cell.arrowImgViewHidden = true;
    return cell;

}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.currentType != TableType_price) {
        return 35;
    }
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *view = [[UIImageView alloc] init];
    view.backgroundColor = COLOR(245, 245, 245, 1);
//    view.image = [UIImage imageNamed:@"member_follow_head_bg.png"];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, (35-20)/2.0, 100, 20)];
    label.font = [UIFont systemFontOfSize:15.0];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    
    id<NSFetchedResultsSectionInfo> sectionInfo;
    if (self.currentType == TableType_category) {
        sectionInfo = self.categoryResultsController.sections[section];
//        NSString *typestr = [NSString stringWithFormat:@"BornCategory%@", sectionInfo.name];
//        [items insertObject:LS(typestr) atIndex:items.count];
//        label.text = LS(typestr);
        label.text = sectionInfo.name;
    }
    else if (self.currentType == TableType_date)
    {
        sectionInfo = self.dateResultesController.sections[section];
        label.text = sectionInfo.name;
    }
//    label.text = sectionInfo.name;
//    label.text = [NSString stringWithFormat:@"%@年",self.years[section]];
    [view addSubview:label];
    return view;
}


#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
